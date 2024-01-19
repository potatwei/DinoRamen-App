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
import FirebaseMessaging


@Observable
class RegisterViewViewModel {
    
    // Binding Variables
    var name = ""
    var email = ""
    
    var errorMessage = ""

    func register() {
        guard validate() else {
            return
        }
        let userId = Auth.auth().currentUser?.uid
        insertUserRecord(id: userId ?? "")

    }
    
    private func insertUserRecord(id: String) {
        var newUser = User(id: id,
                           name: name,
                           email: email,
                           joined: Date().timeIntervalSince1970)
        
        if let fcm = Messaging.messaging().fcmToken {
            print("fcm", fcm)
            newUser.fcmToken = fcm
        }
        
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
              !email.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all fields"
            return false
        }
        
        return true
    }
}
