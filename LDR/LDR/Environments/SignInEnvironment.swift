//
//  SignInEnvironment.swift
//  LDR
//
//  Created by Shihang Wei on 1/18/24.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

class SignInEnvironment: ObservableObject {
    @Published var ifUserDocumentExist: Bool?
    
    init() {
        isUserExist()
    }
    
    func isUserExist() {
        let currentUserId = Auth.auth().currentUser?.uid ?? "a"
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUserId)
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.ifUserDocumentExist = true
            } else {
                self.ifUserDocumentExist = false
            }
        }
    }
}
