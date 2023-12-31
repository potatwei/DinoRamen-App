//
//  FriendRequestButtonView.swift
//  LDR
//
//  Created by Shihang Wei on 12/31/23.
//

import SwiftUI

struct FriendRequestButtonView: View {
    var friendRequestButton: FriendRequestViewViewModel
    
    var body: some View {
        Button{
            Task {
                await friendRequestButton.getOldRequestAndReceived()
                await friendRequestButton.sendRequest()
                await friendRequestButton.updateFriendStatus()
            }
        } label: {
            //
            if friendRequestButton.connectedFriends.contains(friendRequestButton.userToDisplay.id) {
                Text("Connected")
            }
            else if friendRequestButton.sentfriendRequests.contains(friendRequestButton.userToDisplay.id) {
                Text("Sent")
            }
            else if friendRequestButton.receivedFriendRequests.contains(friendRequestButton.userToDisplay.id) {
                Text("Requesting")
            }
            else {
                Label("Add", systemImage: "plus")
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.tint)
            }
        }
        .padding()
        .disabled(friendRequestButton.connectedFriends.contains(friendRequestButton.userToDisplay.id) ||
                  friendRequestButton.sentfriendRequests.contains(friendRequestButton.userToDisplay.id) ||
                  friendRequestButton.receivedFriendRequests.contains(friendRequestButton.userToDisplay.id) ||
                  friendRequestButton.userToDisplay.id == friendRequestButton.currentUserId)
        .opacity(friendRequestButton.userToDisplay.id == friendRequestButton.currentUserId ? 0 : 1)
        .onAppear {
            Task {
                await friendRequestButton.updateFriendStatus()
            }
        }
    }
}

#Preview {
    FriendRequestButtonView(friendRequestButton: 
                                FriendRequestViewViewModel(userToDisplay: User(id: "BgvoT3j8TIftJMA1zmjn3rEQLTA3",
                                                name: "weishihang",
                                                email: "asdfgis@g.com",
                                                joined: 1703912994.081756,
                                                profileImageId: "ECCCC5CF-C7D1-4DB3-B829-8E1B48E0C32B",
                                                profileImage: "https://firebasestorage.googleapis.com:443/v0/b/longdistanceconnection-28d62.appspot.com/o/BgvoT3j8TIftJMA1zmjn3rEQLTA3%2FECCCC5CF-C7D1-4DB3-B829-8E1B48E0C32B.jpeg?alt=media&token=d7951b95-d277-42ad-a67f-fa5f958071a2")))
}
