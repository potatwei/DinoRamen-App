//
//  UserBarView.swift
//  LDR
//
//  Created by Shihang Wei on 12/28/23.
//

import SwiftUI

struct UserBarView: View {
    let userToDisplay: User
    
    var body: some View {
        HStack {
            Text("\(userToDisplay.name)")
                .padding()
            Spacer()
        }
        .background(.white)
    }
}

#Preview {
    UserBarView(userToDisplay: User(id: "123",
                                    name: "Shihang Wei",
                                    email: "sw5672@nyu.edu",
                                    joined: Date().timeIntervalSince1970))
}
