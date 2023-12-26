//
//  LoginViewViewModel.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import Foundation
import SwiftUI
import FirebaseAuth

@Observable class LoginViewViewModel {
    
    var email = ""
    var password = ""
    var errorMessage = ""
    
    init() {
    }
    
    func login() {
        guard validate() else {
            return
        }
        
        // Try login using firebase
        Auth.auth().signIn(withEmail: email, password: password)
    }
    
    private func validate() -> Bool {
        errorMessage = ""
        // Check if entered filled two fields
        guard !email.trimmingCharacters(in: .whitespaces).isEmpty &&
              !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            
            errorMessage = "Please fill in all fields"
            return false
        }
        
        // Validate email address
        guard email.contains("@") && email.contains(".") else {
            errorMessage = "Please enter valid email"
            return false
        }
        
        return true
    }
}
