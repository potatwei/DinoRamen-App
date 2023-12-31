//
//  UserBarViewViewModel.swift
//  LDR
//
//  Created by Shihang Wei on 12/28/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

@Observable class UserBarViewViewModel {
    let userToDisplay: User
    init(userToDisplay: User) {
        self.userToDisplay = userToDisplay
    }
}
