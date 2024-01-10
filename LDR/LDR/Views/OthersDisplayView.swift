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
                
                othersReaction // Display other's reaction
                
                Spacer()
                
                profileButton // Profile button that jumps to profile page
            }
            
            Divider().frame(maxWidth: 330).padding()
            
            if userStatus.connUserStatus.image != nil {
                ZStack {
                    othersPhoto // Photo to display
                    
                    VStack {
                        othersEmoji // Others Emoji Displayed
                            .frame(width: 100,height: 100)
                        
                        Spacer()
                        
                        othersComment // Display other's comment
                            .font(.system(size: 18))
                            .offset(y: -25)
                    }
                }
            } else {
                othersEmoji // Others Emoji Displayed
                    .frame(width: 260,height: 260)
                    .offset(y: 50)
                
                othersComment
                    .font(.system(size: 27))
            }

            Spacer()
            
            Divider().frame(maxWidth: 320)
            
            reaction // Display four reaction buttons
        }
        .onAppear {
            Task {
                await userStatus.fetchCurrentUserStatus()
                await userStatus.fetchOtherUserStatus()
            }
        }
        
    }
    
    ///
    @ViewBuilder
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
    
    ///
    @ViewBuilder
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
    
    ///
    @ViewBuilder
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
    
    ///
    @ViewBuilder
    var profileButton: some View {
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
    
    ///
    @ViewBuilder
    var othersReaction: some View {
        if userStatus.connUserStatus.reaction != "" {
            Image(systemName: userStatus.connUserStatus.reaction)
                .font(.system(size: 20))
                .padding(8)
                .background(.bar)
                .foregroundStyle(.tint)
                .clipShape(Circle())
                .offset(x: -39, y: 30)
        }
    }
    
    ///
    @ViewBuilder
    var othersEmoji: some View {
        ZStack {
            Circle()
                .frame(width: 230)
                .foregroundStyle(.ultraThinMaterial)
            Text(display.emojis[userStatus.connUserStatus.emoji])
                .font(.system(size: 300))
        }
        .padding(1)
        .minimumScaleFactor(0.1)
    }
    
    ///
    @ViewBuilder
    var othersPhoto: some View {
        let imageURL = URL(string: userStatus.connUserStatus.image!)
        AsyncImage(url: imageURL) { Image in
            Image
                .resizable()
        } placeholder: {
            RoundedRectangle(cornerRadius: 25.0)
        }
        .scaledToFill()
        .frame(maxWidth: 280, maxHeight: 400)
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
    }
    
    ///
    @ViewBuilder
    var othersComment: some View {
        Text(userStatus.connUserStatus.comment)
            .padding(8)
            .padding(.horizontal, 12)
            .background(.thinMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .fontWeight(.medium)
            .frame(maxWidth: 280, maxHeight: 100)
    }
}



#Preview {
    OthersDisplayView(tabSelection: .constant(0))
        .environmentObject(UserStatusEnvironment())
}
