const {onDocumentCreated} = require("firebase-functions/v2/firestore");
const {initializeApp} = require("firebase-admin/app");
const {getFirestore} = require("firebase-admin/firestore");
const {getMessaging} = require("firebase-admin/messaging");

initializeApp();
const db = getFirestore();
const messaging = getMessaging();

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
