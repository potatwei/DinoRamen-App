//
//  MainInterface.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation

@MainActor
class MainInterfaceViewModel: ObservableObject {
    @Published var currentUserId: String = ""
    @Published var ifExist = false
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async{
                self?.currentUserId = user?.uid ?? ""
            }
        }
        isUserExist()
    }
    
    var isSignIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    func isUserExist() {
        let currentUserId = Auth.auth().currentUser?.uid ?? "a"
        let db = Firestore.firestore()
        //var ifExist = false
        let userRef = db.collection("users").document(currentUserId)
        userRef.getDocument { (document, error) in
            if let document = document, document.exists {
                self.ifExist = true
                //return
            } else {
                //return
            }
        }
        //return ifExist
    }
}
