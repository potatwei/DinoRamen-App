const functions = require("firebase-functions/v1");
const admin = require("firebase-admin");
const {getFirestore} = require("firebase-admin/firestore");

admin.initializeApp();

exports.sendNotification = functions.firestore
    .document("users/{userId}/status/{userStatus}")
    .onWrite( (snapshot, context) => { // When document changes
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
        const doc = connectedFriendIdRef.get()
            .then((doc) => {
              if (!doc.exists) {
                console.log("No connected document");
              } else {
                console.log("Connected document get", doc.data());
              }
            })
            .catch((err) => {
              console.log("Error getting document", err);
            });

        // Get connect user id
        if (doc.exists) {
          let receiverId;
          for (const [key, value] of Object.entries(doc.data())) {
            receiverId = key;
            console.log("Connect user id:", value);
          }
          console.log("Connect user id:", receiverId);

          // Get connect user fcmToken document
          const connectedUserRef = db.collection("users").doc(receiverId);
          const connectedUserDoc = connectedUserRef.get()
              .then((connectedUserDoc) => {
                if (!connectedUserDoc.exists) {
                  console.log("No connected document");
                } else {
                  console.log("Connected doc get", connectedUserDoc.data());
                }
              })
              .catch((err) => {
                console.log("Error getting document", err);
              });

          if (connectedUserDoc.exists) {
            // Get token string from document
            const receiverFCMToken = connectedUserDoc.data().fcmToken;
            // Send notification
            const message = {
              data: {
                title: "LDR",
                body: "Your friend just updated their status",
              },
              token: receiverFCMToken,
            };
            admin.messaging().send(message);
          }
        } else {
            console.log("Connected document doesn't exist");
        }
      } else {
        console.log("Sender Id is undefined");
      }
      return Promise.resolve;
    });
