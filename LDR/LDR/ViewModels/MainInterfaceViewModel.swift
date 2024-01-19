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
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async{
                self?.currentUserId = user?.uid ?? ""
            }
        }
    }
    
    var isSignIn: Bool {
        return Auth.auth().currentUser != nil
    }
    
    var isEmailSetUp: Bool {
        return Auth.auth().currentUser?.email != nil
    }
}
