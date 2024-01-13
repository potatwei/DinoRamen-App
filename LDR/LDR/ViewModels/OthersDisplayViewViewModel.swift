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
            return "0"
        }
        return currentUserId
    }
    
    
    var showReactions = false
    var emojis = ["laugh","sweat","loveEye","loveHeart","largeCry","smallCry"]
    
    ///
    func selectReaction(_ reaction: String, status: Status) async -> Status {
        var newStatus = status
        // Set user reaction to document users/\(currentUserId)/status/user_reaction
        newStatus.reaction = reaction
        
        do {
            // Update local reaction variable
            try await db.document("users/\(currentUserId)/status/user_status").setData(newStatus.asDictionary())
            print("Successfully set reaction in database")
            return newStatus
        } catch {
            print("Error setting reaction document in database: \(error)")
            return status
        }
    }
    
    ///
    func uploadComment(_ comment: String, status: Status) async -> Status {
        var newStatus = status
        newStatus.commentMade = comment
        
        do {
            try await db.document("users/\(currentUserId)/status/user_status").setData(newStatus.asDictionary())
            print("Successfully set commentMade in database")
            return newStatus
        } catch {
            print("Error setting commentMade document in database: \(error)")
            return status
        }
    }
}
