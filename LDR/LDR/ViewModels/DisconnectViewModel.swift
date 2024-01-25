//
//  DisconnectViewViewModel.swift
//  LDR
//
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@Observable class DisconnectViewViewModel {
    private let db = Firestore.firestore()
    let requestingUser: User
    var currentUserId: String {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("Fail to get current user id")
            return ""
        }
        return currentUserId
    }
    
    init(_ requestingUser: User) {
        self.requestingUser = requestingUser
    }
    
    func acceptRequest() async -> [Bool]{
        
        // Remove received user's id from user/currentUserId/friend/received
        async let ifRemovedFromCurrentUserFriendConnected = removeItemFromDataBase(requestingUser.id, path: "users/\(currentUserId)/friend/connected")
        
        
        // Remove current user's id from user/requestingUser.id/friend/requested
        async let ifRemovedFromOtherUserFriendConnected = removeItemFromDataBase(currentUserId, path: "users/\(requestingUser.id)/friend/connected")
        
        return await [ifRemovedFromCurrentUserFriendConnected, ifRemovedFromOtherUserFriendConnected]
    }
    
    func removeItemFromDataBase(_ data: String, path: String) async -> Bool{
        // Get all received user's id from path
        var userIds: [String : Any] = [:]
        do {
            let document = try await db.document(path).getDocument()
            if document.exists {
                userIds = document.data() ?? [:]
            } else {
                print("Document at \(path) does not exist")
                return false
            }
        } catch {
            print("Error getting document at \(path): \(error)")
            return false
        }
    
        // Remove according data from the dictionary
        userIds.removeValue(forKey: data)
    
        // delete the edited dictionary to path
        do {
            try await db.document(path).delete()
            print("Successfully delete friend in \(path)")
            return true
        } catch {
            print("Error deleting friend in \(path): \(error)")
            return false
        }
    }
}

