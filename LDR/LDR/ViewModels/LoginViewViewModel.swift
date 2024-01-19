//
//  LoginViewViewModel.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import Foundation
import SwiftUI
import FirebaseAuth
import AuthenticationServices
import CryptoKit

@Observable class LoginViewViewModel {
    
    var email = ""
    var password = ""
    var errorMessage = ""
    fileprivate var currentNonce: String?
    
    func login() {
        guard validate() else {
            return
        }
        
        // Try login using firebase
        Auth.auth().signIn(withEmail: email, password: password) {_,error in
            if let error = error {
                self.errorMessage = "\(error.localizedDescription)"
                if self.errorMessage == "The supplied auth credential is malformed or has expired." {
                    self.errorMessage = "Invalid password or email"
                }
            }
        }
    }
    
    func appleLoginRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.email]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    
    func appleLoginCompletion(_ result: Result<ASAuthorization, Error>) {
        if case .failure(let failure) = result {
            errorMessage = failure.localizedDescription
        } else if case .success(let success) = result {
            if let appleIDCredential = success.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: a login callback was received, but no login request was sent")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identify token.")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialise token string from data: \(appleIDToken.debugDescription)")
                    return
                }
                
                let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                          idToken: idTokenString,
                                                          rawNonce: nonce)
                Task {
                    do {
                        let _ = try await Auth.auth().signIn(with: credential)
                        await updateUserEmail(to: appleIDCredential.email)
                    } catch {
                        print("Error authenticating: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    func updateUserEmail(to email: String?) async {
        if let currentUserEmail = Auth.auth().currentUser?.email, !currentUserEmail.isEmpty {
            // current user's email is not empty, dont over write it
        } else {
            Task {
                do {
                    try await Auth.auth().currentUser?.updateEmail(to: email ?? "")
                } catch {
                    print(error)
                }
            }
        }
    }
    
    private func randomNonceString(length: Int = 32) -> String {
        precondition(length > 0)
        var randomBytes = [UInt8](repeating: 0, count: length)
        let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
        if errorCode != errSecSuccess {
            fatalError(
                "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
            )
        }
        
        let charset: [Character] =
        Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
        
        let nonce = randomBytes.map { byte in
            // Pick a random character from the set, wrapping around if needed.
            charset[Int(byte) % charset.count]
        }
        
        return String(nonce)
    }
    
    private func sha256(_ input: String) -> String {
        let inputData = Data(input.utf8)
        let hashedData = SHA256.hash(data: inputData)
        let hashString = hashedData.compactMap {
            String(format: "%02x", $0)
        }.joined()
        
        return hashString
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
