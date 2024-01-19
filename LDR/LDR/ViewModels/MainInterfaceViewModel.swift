//
//  MainInterface.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import FirebaseAuth
import FirebaseFirestore
import Foundation
import SwiftUI

@MainActor
class MainInterfaceViewModel: ObservableObject {
    @Published var currentUserId: String = ""
    @Published var isSignIn: Bool = false
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async{
                self?.currentUserId = user?.uid ?? ""
                self?.ifSignIn()
            }
        }
    }
    
    func ifSignIn() {
        if currentUserId != "" {
            
                self.isSignIn = true
            
        } else {
            self.isSignIn = false
        }
    }
    
    var isEmailSetUp: Bool {
        return Auth.auth().currentUser?.email != nil
    }
}
