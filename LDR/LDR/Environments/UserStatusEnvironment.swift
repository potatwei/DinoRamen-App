//
//  CurrentUserStatus.swift
//  LDR
//
//  Created by Shihang Wei on 1/8/24.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class UserStatusEnvironment: ObservableObject {
    @Published var currUserStatus = Status(id: "", emoji: 0, comment: "")
    @Published var connUserStatus = Status(id: "", emoji: 0, comment: "")
    private let db = Firestore.firestore()
    
    var currentUserId: String {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("Fail to get current user id")
            return "b"
        }
        return currentUserId
    }

    
    init() {
        Task {
            await fetchCurrentUserStatus()
        }
    }
    
    @MainActor
    func fetchCurrentUserStatus() async {
        let db = Firestore.firestore()
        do {
            let document = try await db.collection("users").document(currentUserId).collection("status").document("user_status").getDocument()
            if document.exists {
                currUserStatus = try document.data(as: Status.self)
                print("get current user status Successfully")
            }
        } catch {
            print("Unable to update Status or fail to get document \(error)")
        }
    }
    
    ///
    @MainActor
    func fetchOtherUserStatus() async {
        // Get connected user id
        var connectedId = "a"
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
        
        // Get connected user status
        do {
            let document = try await db.document("users/\(connectedId)/status/user_status").getDocument()
            if document.exists {
                connUserStatus = try document.data(as: Status.self)
                print("Updated userStatus Successfully")
            } else {
                print("user_status document doesn't exist")
            }
        } catch {
            print("Unable to update userStatus or fail to get document \(error)")
        }
    }
    
    func changeEmoji(by value: Int) {
        currUserStatus.emoji += value
        if currUserStatus.emoji < 0 {
            currUserStatus.emoji += 6
        }
        if currUserStatus.emoji > 5 {
            currUserStatus.emoji -= 6
        }
    }
}
