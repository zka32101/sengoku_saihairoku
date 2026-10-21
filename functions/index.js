const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {defineSecret} = require("firebase-functions/params");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");
const {getMessaging} = require("firebase-admin/messaging");
const {google} = require("googleapis");

initializeApp();
const db = getFirestore();
const messaging = getMessaging();

// App Store（Apple）レシート検証用の共有シークレット。
// `firebase functions:secrets:set APPLE_SHARED_SECRET` で設定する
// （App Store Connect > サブスクリプション > 共有シークレット から取得）。
const appleSharedSecret = defineSecret("APPLE_SHARED_SECRET");

// Google Play の商品パッケージ名（android/app/build.gradle.ktsのapplicationIdと一致させる）
const ANDROID_PACKAGE_NAME = "com.petitworksapps.sengokusaihairoku";

/**
 * users/{userId}/purchases/{purchaseId} に新しい購入記録（status: 'pending'）が
 * 作成されたら、ストア（Google Play / App Store）に対してレシートの
 * サーバー検証を行い、結果に応じて status を 'verified' / 'rejected' に更新する。
 *
 * クライアント（PurchaseService）は、この関数がstatusを'verified'に
 * 更新するのを確認してから初めてゴールド付与・バトルパス有効化を行う
 * （firestore.rulesにより、クライアントはstatus自体を書き換えられない）。
 *
 * セットアップが必要な前提条件：
 * - Google Play: このFunctionのデフォルトサービスアカウントを、
 *   Play Console > ユーザーと権限 で「表示権限」以上を付与して連携する
 *   （Android Publisher APIをGCPプロジェクトで有効化しておくこと）。
 * - App Store: 上記のAPPLE_SHARED_SECRETシークレットを設定する。
 * どちらも未設定の場合、該当ストアの検証は例外となりstatusは'rejected'に
 * なる（安全側に倒れる＝誤って付与されることはない）。
 */
exports.onPurchaseRecordCreated = onDocumentCreated(
    {document: "users/{userId}/purchases/{purchaseId}", secrets: [appleSharedSecret]},
    async (event) => {
      const snap = event.data;
      const data = snap?.data();
      if (!data || data.status !== "pending") return;

      let verified = false;
      try {
        if (data.verificationSource === "google_play") {
          verified = await verifyGooglePlayReceipt(
              data.productId,
              data.serverVerificationData,
          );
        } else if (data.verificationSource === "app_store") {
          verified = await verifyAppStoreReceipt(
              data.serverVerificationData,
              appleSharedSecret.value(),
          );
        } else {
          console.error(`Unknown verificationSource: ${data.verificationSource}`);
        }
      } catch (err) {
        console.error("Receipt verification failed", err);
        verified = false;
      }

      await snap.ref.set({
        status: verified ? "verified" : "rejected",
        verifiedAt: new Date(),
      }, {merge: true});
    },
);

/**
 * Google Play Developer API (Android Publisher) でワンタイム商品
 * （ゴールドパック・バトルパスプレミアムとも非サブスクリプション商品として
 * 販売する想定）の購入トークンを検証する。
 * purchaseState: 0 = 購入済み, 1 = キャンセル, 2 = 保留中。
 */
async function verifyGooglePlayReceipt(productId, purchaseToken) {
  if (!productId || !purchaseToken) return false;

  const auth = new google.auth.GoogleAuth({
    scopes: ["https://www.googleapis.com/auth/androidpublisher"],
  });
  const androidpublisher = google.androidpublisher({version: "v3", auth});

  const res = await androidpublisher.purchases.products.get({
    packageName: ANDROID_PACKAGE_NAME,
    productId,
    token: purchaseToken,
  });

  return res.data.purchaseState === 0;
}

/**
 * App StoreのverifyReceiptエンドポイントでレシートを検証する。
 * 本番レシートが誤ってSandboxから送られてきた場合（status 21007）は
 * Sandboxエンドポイントへ再送する（Appleの標準的な実装パターン）。
 */
async function verifyAppStoreReceipt(receiptData, sharedSecret) {
  if (!receiptData || !sharedSecret) return false;

  const body = JSON.stringify({
    "receipt-data": receiptData,
    "password": sharedSecret,
    "exclude-old-transactions": true,
  });

  const fetchReceiptStatus = async (url) => {
    const res = await fetch(url, {
      method: "POST",
      headers: {"Content-Type": "application/json"},
      body,
    });
    return res.json();
  };

  let json = await fetchReceiptStatus("https://buy.itunes.apple.com/verifyReceipt");
  if (json.status === 21007) {
    json = await fetchReceiptStatus("https://sandbox.itunes.apple.com/verifyReceipt");
  }

  return json.status === 0;
}

/**
 * users/{userId}/friends/{friendId} にドキュメントが作成されたら、
 * userId 側にプッシュ通知を送る。
 *
 * FriendRepository.addFriendByCode() は1つのバッチ書き込みで双方向に
 * ドキュメントを作成するため、このトリガーは友達関係が成立するたびに
 * 両ユーザーに対してそれぞれ1回ずつ発火する。
 */
/**
 * rankings/{rankingId} に新しいバトル結果が書き込まれたら、同じシナリオで
 * それまで自分より上位だったフレンドを新スコアが上回っていないか確認し、
 * 上回っていれば「抜かれた」フレンドにプッシュ通知を送る。
 *
 * FriendRepository.getFriendsRanking() はフレンドの合計スコアで比較するが、
 * ここでは通知を素早く判定するため、シナリオ単位のベストスコア比較に
 * 単純化している（合計スコアの逆転をすべて検知するものではない）。
 */
exports.onRankingWritten = onDocumentCreated(
    "rankings/{rankingId}",
    async (event) => {
      const ranking = event.data?.data();
      if (!ranking) return;

      const {userId, scenarioId, score} = ranking;
      if (!userId || !scenarioId || typeof score !== "number") return;

      const friendsSnapshot = await db
          .collection("users")
          .doc(userId)
          .collection("friends")
          .get();
      if (friendsSnapshot.empty) return;

      const actorDoc = await db.collection("users").doc(userId).get();
      const actorName = actorDoc.data()?.displayName || "武将";

      for (const friendDoc of friendsSnapshot.docs) {
        const friendId = friendDoc.id;

        const bestSnapshot = await db
            .collection("rankings")
            .where("userId", "==", friendId)
            .where("scenarioId", "==", scenarioId)
            .orderBy("score", "desc")
            .limit(1)
            .get();
        if (bestSnapshot.empty) continue; // フレンドが未プレイなら通知しない

        const friendBestScore = bestSnapshot.docs[0].data().score;
        if (typeof friendBestScore !== "number" || score <= friendBestScore) {
          continue;
        }

        const friendUserDoc = await db.collection("users").doc(friendId).get();
        const fcmToken = friendUserDoc.data()?.fcmToken;
        if (!fcmToken) continue;

        try {
          await messaging.send({
            token: fcmToken,
            notification: {
              title: "順位が変動しました",
              body: `${actorName}さんに${scenarioId}のスコアを抜かれました！`,
            },
          });
        } catch (err) {
          console.error("Failed to send ranking-overtaken notification", err);
        }
      }
    },
);

exports.onFriendAdded = onDocumentCreated(
    "users/{userId}/friends/{friendId}",
    async (event) => {
      const {userId, friendId} = event.params;

      const userDoc = await db.collection("users").doc(userId).get();
      const fcmToken = userDoc.data()?.fcmToken;
      if (!fcmToken) return;

      const friendDoc = await db.collection("users").doc(friendId).get();
      const friendName = friendDoc.data()?.displayName || "武将";

      try {
        await messaging.send({
          token: fcmToken,
          notification: {
            title: "フレンドが増えました",
            body: `${friendName}さんとフレンドになりました！`,
          },
        });
      } catch (err) {
        console.error("Failed to send friend-added notification", err);
      }
    },
);
