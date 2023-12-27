//
//  MainInterface.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import FirebaseAuth
import Foundation

class MainInterfaceViewModel: ObservableObject {
    @Published var currentUserId: String = ""
    private var handler: AuthStateDidChangeListenerHandle?
    
    init() {
        self.handler = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            DispatchQueue.main.async{
                self?.currentUserId = user?.uid ?? ""
                print(self?.currentUserId ?? "p")
                print(self!.isSignIn)
            }
        }
    }
    
    var isSignIn: Bool {
        return Auth.auth().currentUser != nil
    }
}
