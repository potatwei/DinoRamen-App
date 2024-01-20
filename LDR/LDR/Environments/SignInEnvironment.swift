//
//  SignInEnvironment.swift
//  LDR
//
//  Created by Shihang Wei on 1/18/24.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation
import SwiftUI

class SignInEnvironment: ObservableObject {
    @Published var ifUserDocumentExist: Bool?
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async{
                self?.isUserExist()
            }
        }
    }
    
    func isUserExist() {
        let currentUserId = Auth.auth().currentUser?.uid ?? "a"
        print(currentUserId, "😁")
        let db = Firestore.firestore()
        let userRef = db.collection("users").document(currentUserId)
        if currentUserId != "a" {
            userRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    withAnimation {
                        self.ifUserDocumentExist = true
                    }
                } else {
                    print("Cannot get userRef document")
                    withAnimation(.easeInOut){
                        self.ifUserDocumentExist = false
                    }
                }
            }
        }
    }
}
