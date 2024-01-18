const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");
const {getFirestore} = require("firebase-admin/firestore");

admin.initializeApp();

exports.sendNotification = functions.firestore
    .document("users/{userId}/status/{userStatus}")
    .onWrite( async (snapshot, context) => { // When document changes
      const db = getFirestore();

      // Get current user id
      const newStatus = snapshot.after.data();
      const senderId = newStatus.id;
      console.log("Current user ID: " + senderId);

      if (senderId !== undefined) {
        // document reference in database
        const connectedFriendIdRef = db.collection("users")
            .doc(senderId)
            .collection("friend")
            .doc("connected");
        const doc = await connectedFriendIdRef.get()
            .catch((err) => {
              console.log("Error getting document", err);
            });

        // Get connect user id
        if (doc.exists) {
          console.log("Connected document get", doc.data());
          let receiverId;
          for (const [key, value] of Object.entries(doc.data())) {
            receiverId = key;
            console.log("Connect user id:", value);
          }
          console.log("Connect user id:", receiverId);

          // Get connect user fcmToken document
          const connectedUserRef = db.collection("users").doc(receiverId);
          const connectedUserDoc = await connectedUserRef.get()
              .catch((err) => {
                console.log("Error getting document", err);
              });

          if (connectedUserDoc.exists) {
            console.log("Connected doc get", connectedUserDoc.data());
            // Construct message based on changes made in status
            const oldStatus = snapshot.before.data();
            let notificationBodyText;
            let notificationBodyName;
            if (oldStatus.commentMade != newStatus.commentMade) {
              notificationBodyText = " commented your status";
            } else if (oldStatus.reaction != newStatus.reaction) {
              notificationBodyText = " reacted to your status";
            } else {
              notificationBodyText = " updated their status";
            }
            // Get current user name
            const currentUserProfileRef = db.collection("users").doc(senderId);
            const currentUserProfile = await currentUserProfileRef.get()
                .catch((err) => {
                  console.log("Error getting document", err);
                });
            if (currentUserProfile.exists) {
              console.log("Current user doc get", currentUserProfile.data());
              notificationBodyName = currentUserProfile.data().name;
            } else {
              console.log("Current user doc doesnt exist");
            }
            const notifiBody = notificationBodyName + notificationBodyText;
            // Get token string from document
            const receiverFCMToken = connectedUserDoc.data().fcmToken;
            // Send notification
            const message = {
              notification: {
                title: "LDR",
                body: notifiBody,
              },
              token: receiverFCMToken,
            };
            await admin.messaging().send(message)
                .then((response) => {
                  console.log("Successfully sent message:", response);
                })
                .catch((error) => {
                  console.log("Error sending message:", error);
                });
          }
        } else {
          console.log("Connected document doesn't exist");
        }
      } else {
        console.log("Sender Id is undefined");
      }
      return Promise.resolve;
    });
