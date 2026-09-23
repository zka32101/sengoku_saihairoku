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
