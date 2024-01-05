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
    
    init() {
        Task {
            await fetchStatus()
        }
    }
    
    var takenImage = UIImage()
    
    var showReactions = false
    var ownStatus = Status(id: "", emoji: 0, comment: "")
    var othersStatus = Status(id: "", emoji: 0, comment: "")
    var emojis = ["😁","😅","🥰","😣","😭","😋","🙃","🤪","😪","😵‍💫","🤢","🤒"]
    var emojiToDisplay: Int { return othersStatus.emoji }
    var commentToDisplay: String { return othersStatus.comment }
    var ownsReaction: String { return ownStatus.reaction }
    var othersReaction: String { return othersStatus.reaction}
    
    ///
    
    
    ///
    func selectReaction(_ reaction: String) {
        // Set user reaction to document users/\(currentUserId)/status/user_reaction
        ownStatus.changeReaction(reaction)
        Task {
            do {
                // Update local reaction variable
                try await db.document("users/\(currentUserId)/status/user_status").setData(ownStatus.asDictionary())
                print("Successfully set reaction in database")
            } catch {
                print("Error setting reaction document in database: \(error)")
            }
        }
        
    }
    
    
    
    ///
    @MainActor
    func fetchStatus() async {
        do {
            let document = try await db.document("users/\(currentUserId)/status/user_status").getDocument()
            if document.exists {
                ownStatus = try document.data(as: Status.self)
                print("Updated userStatus Successfully")
            } else {
                print("user_status document doesn't exist")
            }
        } catch {
            print("Unable to update userStatus or fail to get document \(error)")
        }
        
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
                othersStatus = try document.data(as: Status.self)
                print("Updated userStatus Successfully")
            } else {
                print("user_status document doesn't exist")
            }
        } catch {
            print("Unable to update userStatus or fail to get document \(error)")
        }
    }
}
