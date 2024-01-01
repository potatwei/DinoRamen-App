//
//  FriendsRequestsViewViewModel.swift
//  LDR
//
//  Created by Shihang Wei on 12/31/23.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

@Observable class FriendsRequestsViewViewModel {
    var queriedUsers: [User] = []
    var receivedUserIds: [String] = []
    var currentUserId: String {
        guard let currentUserId = Auth.auth().currentUser?.uid else {
            print("Fail to get current user id")
            return ""
        }
        return currentUserId
    }
    private let db = Firestore.firestore()
    
    ///
    @MainActor
    func fetchReceivedId() async {
        do {
            let document = try await db.document("users/\(currentUserId)/friend/received").getDocument()
            if document.exists{
                print("Successfully getting received document")
                let data = document.data() ?? [:]
                receivedUserIds = []
                for (id, _) in data {
                    receivedUserIds.append(id)
                }
            } else {
                print("Received document does not exist")
            }
        } catch {
            print("Error getting received document: \(error)")
        }
    }
    
    // TODO: Use Task Group
    ///
    @MainActor
    func fetchUsers() async {
        queriedUsers = []
        for receivedId in receivedUserIds {
            do {
                let document = try await db.document("users/\(receivedId)").getDocument()
                if document.exists{
                    print("Successfully geting received document")
                    do {
                        let receivedUser = try document.data(as: User.self)
                        print("Sucessfully retrieved received user")
                        queriedUsers.append(receivedUser)
                    } catch {
                        print("Error retrieved received user: \(error)")
                    }
                } else {
                    print("Received document does not exist")
                }
            } catch {
                print("Error getting received user document \(error)")
            }
        }
    }
}
