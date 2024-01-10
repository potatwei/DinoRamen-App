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
            
            HStack {
                reaction // Display four reaction buttons
                
                ZStack {
                    Circle()
                        .frame(width: 60)
                        .foregroundStyle(.regularMaterial)
                    
                    Button {
                        
                    } label: {
                        Label("Text Comment", systemImage: "text.bubble")
                            .labelStyle(.iconOnly)
                            .font(.system(size: 25))
                            .foregroundStyle(.foreground)
                    }
                    //.sensoryFeedback(.impact(weight: .light, intensity: 0.7), trigger: )
                }
            }
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
            reactionButton(defau: "hand.thumbsup.fill")
            
            // Exclamationmark
            reactionButton(defau: "exclamationmark.2")
            
            // Heart
            reactionButton(defau: "heart.fill")
    
            // Thumbs Down
            reactionButton(defau: "hand.thumbsdown.fill")
            
        }
        .labelStyle(.iconOnly)
        .font(.system(size: 28))
    }
    
    ///
    //@ViewBuilder
    
    ///
    @ViewBuilder
    var reaction: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 70)
                .frame(width: 255, height: 60)
                .padding(.vertical)
                .foregroundStyle(.regularMaterial)
            
            reactionButtons
        }
        .minimumScaleFactor(0.8)
    }
    
    ///
    @ViewBuilder
    func reactionButton(defau: String) -> some View {
        Button {
            withAnimation(.spring(response: 0.2, dampingFraction: 0.5)) {
                userStatus.currUserStatus.reaction = defau
            }
            Task {
                userStatus.currUserStatus = await display.selectReaction(defau, status: userStatus.currUserStatus)
            }
        } label: {
            ZStack {
                Circle()
                    .frame(width: 50)
                    .scaleEffect(userStatus.currUserStatus.reaction == defau ? 1 : 0)
                    .foregroundStyle(.sugarPink)
                    .opacity(userStatus.currUserStatus.reaction == defau ? 1 : 0)
                Label(defau, systemImage: defau)
                    .foregroundStyle(userStatus.currUserStatus.reaction == defau ? .white : .sugarGreen)
                    .offset(y: 0.5)
                    .animation(nil, value: userStatus.currUserStatus.reaction)
            }
        }
        .sensoryFeedback(.impact(weight: .light, intensity: 0.5), trigger: userStatus.currUserStatus.reaction)
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
        .sensoryFeedback(.impact(weight: .heavy, intensity: 0.7), trigger: tabSelection) // Provide feedback when change tab
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
