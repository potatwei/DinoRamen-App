//
//  OthersDisplayViewViewModel.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

@Observable class OthersDisplayViewViewModel {
    private let db = Firestore.firestore()
    var currentUserId: String {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("Fail to get current user id")
            return ""
        }
        return currentUserId
    }
    
    var userStatus = OthersInterface(emoji: 0, comment: "")
    var emojis = ["😁","😅","🥰","😣","😭","😋","🙃","🤪","😪","😵‍💫","🤢","🤒"]
    var emojiToDisplay: Int { return userStatus.emoji }
    var commentToDisplay: String { return userStatus.comment }
    var reaction = ""
    
    ///
    func fetchStatus() async {
        // Get connected user id
        var connectedId = ""
        do {
            let document = try await db.document("users/\(currentUserId)/friend/connected").getDocument()
            if document.exists {
                if let data = document.data() {
                    for (id, _) in data {
                        connectedId = id
                    }
                    print("get connected user id Successfully")
                }
            } else {
                print("Connected document doesn't exist")
            }
        } catch {
            print("Unable to update user id or fail to get document \(error)")
        }
        
        do {
            let document = try await db.document("users/\(connectedId)/status/user_status").getDocument()
            if document.exists {
                userStatus = try document.data(as: OthersInterface.self)
                print("Updated userStatus Successfully")
            } else {
                print("user_status document doesn't exist")
            }
        } catch {
            print("Unable to update userStatus or fail to get document \(error)")
        }
    }
}
