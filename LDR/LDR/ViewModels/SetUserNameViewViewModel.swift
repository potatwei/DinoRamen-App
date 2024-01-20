//
//  SetUserNameViewViewModel.swift
//  LDR
//
//  Created by Shihang Wei on 1/18/24.
//

import Foundation
import FirebaseAuth
import FirebaseMessaging
import FirebaseFirestore

@Observable
class SetUserNameViewViewModel {
    var errorMessage = ""
    
    func register(userName: String) {
        guard validate(enteredUserName: userName) else {
            return
        }
        let userId = Auth.auth().currentUser?.uid
        insertUserRecord(id: userId ?? "", userName)
    }
    
    private func insertUserRecord(id: String, _ enteredUserName: String) {
        let email = Auth.auth().currentUser?.email
        
        var newUser = User(id: id,
                           name: enteredUserName,
                           email: email ?? "",
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
    
    private func validate(enteredUserName: String) -> Bool {
        guard !enteredUserName.trimmingCharacters(in: .whitespaces).isEmpty else {
            errorMessage = "Please fill in all fields"
            return false
        }
        guard enteredUserName.trimmingCharacters(in: .whitespaces).count <= 36 else {
            errorMessage = "User name is too long"
            return false
        }
        
        return true
    }

}
