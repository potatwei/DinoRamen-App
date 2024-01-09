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
    @Published var connUserStatus: Status?
    
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
            }
        } catch {
            print("Unable to update Status or fail to get document \(error)")
        }
    }
    
    func changeEmoji(by value: Int) {
        currUserStatus.emoji += value
        if currUserStatus.emoji < 0 {
            currUserStatus.emoji += 12
        }
        if currUserStatus.emoji > 11 {
            currUserStatus.emoji -= 12
        }
    }
}
