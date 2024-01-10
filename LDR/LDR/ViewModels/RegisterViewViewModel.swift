//
//  RegisterViewViewModel.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import FirebaseAuth
import Foundation
import FirebaseFirestore
import SwiftUI



@Observable
class RegisterViewViewModel {
    
    // Binding Variables
    var name = ""
    var email = ""
    var password = ""
    
    var errorMessage = ""

    func register() {
        guard validate() else {
            return
        }
        
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] result, error in
            if let error = error {
                print("REGISTER ERROR: \(error.localizedDescription)")
                self?.errorMessage = "\(error.localizedDescription)"
            } else {
                print(" Registration Success")
            }
            
            guard let userId = result?.user.uid else {
                return
            }
            
            self?.insertUserRecord(id: userId)
        }
    }
    
    private func insertUserRecord(id: String) {
        let newUser = User(id: id,
                           name: name,
                           email: email,
                           joined: Date().timeIntervalSince1970)
        
        let db = Firestore.firestore()
        
        do {
            let document = db.collection("users").document(id)
            try document.setData(from: newUser)
            document.updateData(["keywordsForLookup": newUser.keywordsForLookup])
        } catch {
            print("Error adding \(error)")
        }
    }
    
    private func validate() -> Bool {
        guard !name.trimmingCharacters(in: .whitespaces).isEmpty,
              !email.trimmingCharacters(in: .whitespaces).isEmpty,
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all fields"
            return false
        }
        
        guard password.count >= 6 else {
            errorMessage = "Passward is too weak"
            return false
        }
        
        return true
    }
}
