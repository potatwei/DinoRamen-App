//
//  UserBarViewViewModel.swift
//  LDR
//
//  Created by Shihang Wei on 12/28/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@Observable class UserBarViewViewModel {

    let userToDisplay: User
    private let db = Firestore.firestore()
    
    init(userToDisplay: User) {
        self.userToDisplay = userToDisplay
    }
    
    @MainActor
    func sendRequest() async {
        // Get user id
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("Fail to get current user id")
            return
        }
        
        // Update document /"users"/currentUserId/"friend"/"requested" with [targetUserId : targetUserId]
        do {
            try await db.collection("users").document(currentUserId).collection("friend").document("requested")
                        .setData([userToDisplay.id : userToDisplay.id])
            print("Target id successfully set in requested")
        } catch {
            print("Could not set target id in requested")
        }
        
        // Update document /"users"/targetUserId/"friend"/"received" with [currentUserId : currentUserId]
        do {
            try await db.collection("users").document(userToDisplay.id).collection("friend").document("received")
                        .setData([currentUserId : currentUserId])
            print("Current id successfully set in received")
        } catch {
            print("Could not set current id in received")
        }
        
    }
}
