//
//  OthersDisplayView.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import SwiftUI

struct OthersDisplayView: View {
    @Bindable var display = OthersDisplayViewViewModel()
    @Binding var tabSelection: Int
    
    @EnvironmentObject var userStatus: UserStatusEnvironment
    
    var body: some View {
        VStack {
            HStack {
                Circle() // Profile Image
                    .frame(height: 80)
                    .padding(10)
                    .padding(.leading, 20)
                
                if userStatus.connUserStatus.reaction != "" {
                    Image(systemName: userStatus.connUserStatus.reaction)
                        .font(.system(size: 20))
                        .padding(8)
                        .background(.bar)
                        .foregroundStyle(.tint)
                        .clipShape(Circle())
                        .offset(x: -39, y: 30)
                }
                
                Spacer()
                
                Button {
                    tabSelection = 2
                } label: {
                    Label("profile", systemImage: "person.circle")
                        .labelStyle(.iconOnly)
                        .foregroundStyle(.sugarYellow)
                }
                .padding(.trailing, 25)
                .font(.system(size: 37))
                .offset(y: -22)
            }
            
            Divider().padding().frame(maxWidth: 300)
            
            // Others Emoji Displayed
            ZStack {
                Circle()
                    .frame(maxWidth: 250)
                Text(display.emojis[userStatus.connUserStatus.emoji])
                    .font(.system(size: 180))
            }
            .padding(1)
            .minimumScaleFactor(0.1)
            
            // Photo to display
            if userStatus.connUserStatus.image != nil {
                let imageURL = URL(string: userStatus.connUserStatus.image!)
                AsyncImage(url: imageURL) { Image in
                    Image
                        .resizable()
                } placeholder: {
                    RoundedRectangle(cornerRadius: 25.0)
                }
                .scaledToFill()
                .frame(maxWidth: 210, maxHeight: 160)
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
            }
            
            Text(userStatus.connUserStatus.comment)
                .padding(10)
                .padding(.horizontal, 15)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .font(.system(size: 20))
                .fontWeight(.medium)
                .frame(maxWidth: 350, maxHeight: 100)
            
            Spacer()
            
            Divider().frame(maxWidth: 300)
            
            reaction

        }
        .onAppear {
            Task {
                await userStatus.fetchCurrentUserStatus()
                await userStatus.fetchOtherUserStatus()
            }
        }
        
    }
    
    var reactionButtons: some View {
        HStack{
            // TODO: Better Animation
            // Thumbs Up
            reactionButton(defau: "hand.thumbsup.fill", selected: "hand.thumbsup.circle")
            
            // Exclamationmark
            reactionButton(defau: "exclamationmark.2", selected: "exclamationmark")
            
            // Heart
            reactionButton(defau: "heart.fill", selected: "heart.circle")
    
            // Thumbs Down
            reactionButton(defau: "hand.thumbsdown.fill", selected: "hand.thumbsdown.circle")
            
        }
        .labelStyle(.iconOnly)
        .font(.largeTitle)
    }
    
    var reaction: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .frame(width: 250, height: 60)
                .padding()
                .foregroundStyle(.bar)
            
            reactionButtons
        }
        .minimumScaleFactor(0.8)
    }
    
    func reactionButton(defau: String, selected: String) -> some View {
        Button {
            userStatus.currUserStatus.reaction = defau
            Task {
                userStatus.currUserStatus = await display.selectReaction(defau, status: userStatus.currUserStatus)
            }
        } label: {
            if userStatus.currUserStatus.reaction != defau{
                Label(defau, systemImage: defau)
            } else {
                Label(selected, systemImage: selected)
            }
        }
        .padding(5)
    }
}



#Preview {
    OthersDisplayView(tabSelection: .constant(0))
        .environmentObject(UserStatusEnvironment())
}
