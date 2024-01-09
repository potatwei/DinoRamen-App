//
//  UserEnvironment.swift
//  LDR
//
//  Created by Shihang Wei on 1/8/24.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class UserEnvironment: ObservableObject {
    @Published var currentUser = User(id: "", name: "", email: "", joined: 0.0)
    
    init() {
        Task {
            await fetchCurrentUser()
        }
    }
    
    @MainActor
    func fetchCurrentUser() async {
        guard let userId = Auth.auth().currentUser?.uid else {
            return
        }
        let db = Firestore.firestore()
        do {
            let document = try await db.collection("users").document(userId).getDocument()
            if document.exists {
                currentUser = try document.data(as: User.self)
                print("Updated User Successfully")
            } else {
                print("Error: User document do not exist")
            }
        } catch {
            print("Unable to update User or fail to get document \(error)")
        }
    }
}
