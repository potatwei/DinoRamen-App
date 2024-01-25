//
//  AddFriendButtonView.swift
//  LDR
//
//  Created by Shihang Wei on 12/31/23.
//

import SwiftUI

struct AddFriendButtonView: View {
    var addFriendButton: AddFriendButtonViewViewModel
    @Environment(\.dismiss) private var dismiss
    @Binding var isPresenting: Bool
    
    var body: some View {
        Button {
            Task {
                _ = await addFriendButton.acceptRequest()
            }
            isPresenting = false
        } label: {
            Text("Accept")
                .font(.system(size: 14))
                .foregroundStyle(.white)
                .padding(5)
                .padding(.horizontal, 4)
                .background(.tint)
                .clipShape(RoundedRectangle(cornerRadius: 6))
        }
    }
}

#Preview {
    AddFriendButtonView(addFriendButton: AddFriendButtonViewViewModel(User(id: "BgvoT3j8TIftJMA1zmjn3rEQLTA3",
                                                                           name: "weishihang",
                                                                           email: "asdfgis@g.com",
                                                                           joined: 1703912994.081756,
                                                                           profileImageId: "ECCCC5CF-C7D1-4DB3-B829-8E1B48E0C32B",
                                                                           profileImage: "https://firebasestorage.googleapis.com:443/v0/b/longdistanceconnection-28d62.appspot.com/o/BgvoT3j8TIftJMA1zmjn3rEQLTA3%2FECCCC5CF-C7D1-4DB3-B829-8E1B48E0C32B.jpeg?alt=media&token=d7951b95-d277-42ad-a67f-fa5f958071a2")), isPresenting: .constant(true))
}
