//
//  UserBarView.swift
//  LDR
//
//  Created by Shihang Wei on 12/28/23.
//

import SwiftUI

struct UserBarView: View {
    
    var userBar: UserBarViewViewModel
    
    var body: some View {
        HStack {
            // Profile Image
            profileImage
            
            // Name and Time Joined
            nameAndTimeJoined
            
            Spacer()
            
            // Button to Send friend request
            Button{
                Task {
                    await userBar.getOldRequestAndReceived()
                    await userBar.sendRequest()
                    await userBar.updateFriendStatus()
                }
            } label: {
                //
                Label("Add", systemImage: "plus")
                    .labelStyle(.iconOnly)
                    .foregroundStyle(.tint)
            }
            .padding()
        }
        .background(.white)
        .onAppear {
            Task {
                await userBar.updateFriendStatus()
            }
        }
    }
    
    /// - Returns: `AsyncImage` object that download the current user profile image from firebase
    /// the `AsyncImage` has a default lable of "person.circle"
    var profileImage: some View {
        let imageURL = URL(string: userBar.userToDisplay.profileImage)
        return AsyncImage(url: imageURL) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Image(systemName: "person.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.blue)
        }
        .frame(width: 50, height: 50)
        .clipShape(Circle())
        .padding(.leading, 7)
    }
    
    /// Vertical aligned user name and date joined
    var nameAndTimeJoined: some View {
        VStack(alignment: .leading){
            // Name
            Text("\(userBar.userToDisplay.name)")
                .bold()
                .font(.system(size: 18))
            
            // Time Joined
            Text("Joined: \(Date(timeIntervalSince1970: userBar.userToDisplay.joined).formatted(date: .abbreviated, time: .omitted))")
                .font(.system(size: 12))
                .foregroundStyle(.gray)
        }
        .padding(.leading, 7)
    }
}

#Preview {
    UserBarView(userBar: UserBarViewViewModel(userToDisplay: User(id: "BgvoT3j8TIftJMA1zmjn3rEQLTA3",
                                                                  name: "weishihang",
                                                                  email: "asdfgis@g.com",
                                                                  joined: 1703912994.081756,
                                                                  profileImageId: "ECCCC5CF-C7D1-4DB3-B829-8E1B48E0C32B",
                                                                  profileImage: "https://firebasestorage.googleapis.com:443/v0/b/longdistanceconnection-28d62.appspot.com/o/BgvoT3j8TIftJMA1zmjn3rEQLTA3%2FECCCC5CF-C7D1-4DB3-B829-8E1B48E0C32B.jpeg?alt=media&token=d7951b95-d277-42ad-a67f-fa5f958071a2")) )
}
