//
//  FriendRequestViewViewModel.swift
//  LDR
//
//  Created by Shihang Wei on 12/31/23.
//

import FirebaseFirestore
import FirebaseAuth
import Foundation

@Observable class FriendRequestViewViewModel {
    var sentfriendRequests: [String] = []
    var receivedFriendRequests: [String] = []
    var connectedFriends: [String] = []
    
    private var requestedData: [String: Any] = [:]
    private var receivedData: [String: Any] = [:]
    
    let userToDisplay: User
    private let db = Firestore.firestore()
    var currentUserId: String {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("Fail to get current user id")
            return ""
        }
        return currentUserId
    }
    
    init(userToDisplay: User) {
        self.userToDisplay = userToDisplay
    }
    
    ///
    @MainActor
    func getOldRequestAndReceived() async {
        let requestedDocumentPath = "users/\(currentUserId)/friend/requested"
        let receivedDocumentPath = "users/\(userToDisplay.id)/friend/received"
        
        do {
            let document = try await db.document(requestedDocumentPath).getDocument()
            if document.exists {
                let data = document.data()
                self.requestedData = data ?? [:]
                self.requestedData[self.userToDisplay.id] = self.userToDisplay.id
                print("Preparing to Save in current user \(self.requestedData)")
            } else {
                print("Document does not exist")
            }
        } catch {
            print("Error getting document: \(error)")
        }
        
        do {
            let document = try await db.document(receivedDocumentPath).getDocument()
            if document.exists {
                let data = document.data()
                self.receivedData = data ?? [:]
                self.receivedData[currentUserId] = currentUserId
                print("Preparing to Save in other user \(self.receivedData)")
            } else {
                print("Document does not exist")
            }
        } catch {
            print("Error getting document: \(error)")
        }
    }
    
    
    ///
    @MainActor
    func sendRequest() async {
        print("\(requestedData) is going to be saved in current user")
        print("\(receivedData) is going to be saved in other user")
        let requestedDocumentPath = "users/\(currentUserId)/friend/requested"
        let receivedDocumentPath = "users/\(userToDisplay.id)/friend/received"
        
        // Update document /"users"/currentUserId/"friend"/"requested" with [targetUserId : targetUserId]
        do {
            try await db.document(requestedDocumentPath).setData(requestedData)
            print("Target id successfully set in requested")
        } catch {
            print("Could not set target id in requested")
        }
        
        // Update document /"users"/targetUserId/"friend"/"received" with [currentUserId : currentUserId]
        do {
            try await db.document(receivedDocumentPath).setData(receivedData)
            print("Current id successfully set in received")
        } catch {
            print("Could not set current id in received")
        }
    }
    
    ///
    @MainActor
    func updateFriendStatus() async {
        // Update sentfriendRequests
        await update(&self.sentfriendRequests, location: "requested", id: currentUserId)
        
        // Update receivedFriendRequests
        await update(&self.receivedFriendRequests, location: "received", id: currentUserId)
        
        // Update connectedFriends
        await update(&self.connectedFriends, location: "connected", id: currentUserId)
    }
    
    ///
    @MainActor
    func update(_ savedData: inout [String], location: String, id: String) async {
        do {
            let document = try await db.document("users/\(id)/friend/\(location)").getDocument()
            if document.exists {
                let data = document.data()
                savedData = []
                if let data = data {
                    for (id, _) in data {
                        savedData.append(id)
                        print(savedData)
                    }
                } else {
                    print("Data doesn't exist")
                }
            } else {
                print("Document does not exist")
            }
        } catch {
            print("Error getting document: \(error)")
        }
    }
}
