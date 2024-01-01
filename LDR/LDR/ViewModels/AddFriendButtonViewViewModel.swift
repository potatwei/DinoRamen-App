//
//  AddFriendButtonViewViewModel.swift
//  LDR
//
//  Created by Shihang Wei on 12/31/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@Observable class AddFriendButtonViewViewModel {
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
        // Add received user's id to user/currentUserId/friend/connected
        async let ifAddedToCurrentUserConnected = addToDatabase(requestingUser.id, path: "users/\(currentUserId)/friend/connected")
        
        // Remove received user's id from user/currentUserId/friend/received
        async let ifRemovedFromCurrentUserReceived = removeItemFromDataBase(requestingUser.id, path: "users/\(currentUserId)/friend/received")
        
        // Add current user's id to user/requestingUser.id/friend/connected
        async let ifAddedToRequestUserConnected = addToDatabase(currentUserId, path: "users/\(requestingUser.id)/friend/connected")
        
        // Remove current user's id from user/requestingUser.id/friend/requested
        async let ifRemovedFromRequestUserRequested = removeItemFromDataBase(currentUserId, path: "users/\(requestingUser.id)/friend/requested")
        
        return await [ifAddedToCurrentUserConnected, ifAddedToRequestUserConnected, ifRemovedFromCurrentUserReceived, ifRemovedFromRequestUserRequested]
    }
    
    func addToDatabase(_ data: String, path: String) async -> Bool{
        do {
            try await db.document(path).setData([data : data])
            print("Successfully set data in \(path)")
            return true
        } catch {
            print("Error setting data in \(path): \(error)")
            return false
        }
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
    
        // Add the edited dictionary to path
        do {
            try await db.document(path).setData(userIds)
            print("Successfully set data in \(path)")
            return true
        } catch {
            print("Error setting data in \(path): \(error)")
            return false
        }
    }
}
