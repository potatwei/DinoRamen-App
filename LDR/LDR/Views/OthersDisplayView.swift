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
    @State var showCommentEnter = false
    @State var userComment = ""
    
    @EnvironmentObject var userStatus: UserStatusEnvironment
    
    var body: some View {
        VStack {
            HStack {
                HStack {
                    if userStatus.currUserStatus.image != nil {
                        ZStack {
                            // Show own uploaded image
                            AsyncImage(url: URL(string: userStatus.currUserStatus.image!)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Circle()
                                    .foregroundStyle(.gray)
                            }
                            .frame(width: 80, height: 80)
                            .clipShape(Circle())
                            .padding(10)
                            
                            Text(display.emojis[userStatus.currUserStatus.emoji])
                                .font(.title)
                                .offset(x: 25, y: -25)
                        }
                        Text(userStatus.currUserStatus.comment)
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 6)
                            .background(.thickMaterial)
                            .clipShape(.capsule)
                            .padding(.trailing, 25)
                        
                    }

                     // Display other's reaction
                }
                .background(.sugarBlueLowContrast)
                .clipShape(Capsule())
                .border(/*@START_MENU_TOKEN@*/Color.black/*@END_MENU_TOKEN@*/)
                .padding(.leading, 20)
                
                othersReaction
                
                Spacer()
                
                profileButton // Profile button that jumps to profile page
            }
            
            Divider().frame(maxWidth: 330).padding()
            
            if userStatus.connUserStatus.image != nil {
                ZStack {
                    othersPhoto // Photo to display
                    
                    VStack {
                        othersEmoji // Others Emoji Displayed
                            .frame(maxWidth: 100,maxHeight: 100)
                        
                        Rectangle()
                            .foregroundStyle(.clear)
                        
                        othersComment // Display other's comment
                            .font(.system(size: 18))
                            .offset(y: -25)
                    }
                }
            } else {
                othersEmoji // Others Emoji Displayed
                    .frame(maxWidth: 260, maxHeight: 260)
                    .offset(y: 50)
                
                othersComment
                    .font(.system(size: 27))
            }

            Spacer()
            
            Divider().frame(maxWidth: 320)
            
            HStack {
                reaction // Display four reaction buttons
                
                Spacer()
                
                editComment
            }
            .frame(width: 322)
        }
        .task {
            await userStatus.fetchCurrentUserStatus()
            await userStatus.fetchOtherUserStatus()
        }
    }
    
    ///
    @ViewBuilder
    var reactionButtons: some View {
        ZStack{
            HStack{
                // Thumbs Up
                reactionButton(defau: "hand.thumbsup.fill")
                
                // Exclamationmark
                reactionButton(defau: "exclamationmark.2")
                    .offset(x: showCommentEnter ? -55 : 0)
                
                // Heart
                reactionButton(defau: "heart.fill")
                    .offset(x: showCommentEnter ? -115 : 0)
        
                // Thumbs Down
                reactionButton(defau: "hand.thumbsdown.fill")
                    .offset(x: showCommentEnter ? -175 : 0)
            }
            .opacity(showCommentEnter ? 0.2 : 1)
            // Show Reaction Button
            Button {
                withAnimation(.bouncy(duration: 0.25, extraBounce: -0.05)) {
                    showCommentEnter = false
                }
            } label: {
                Label("Show Reaction", systemImage: "suit.heart")
                    .foregroundStyle(.foreground)
            }
            .offset(x: showCommentEnter ? 0 : -220 , y: 1)
        }
        .labelStyle(.iconOnly)
        .font(.system(size: 28))
    }
    
    ///
    @ViewBuilder
    var editComment: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 70)
                .frame(width: 255, height: 60)
                .foregroundStyle(.regularMaterial)
            
            TextField("Comment...", text: $userComment)
                .offset(x: showCommentEnter ? 0 : 200)
                .padding()
                .frame(width: showCommentEnter ? 255 : 0)
                //.background(.sugarBlue)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
            
            Button {
                withAnimation(.bouncy(duration: 0.25, extraBounce: -0.2)) {
                    showCommentEnter = true
                }
            } label: {
                Label("Text Comment", systemImage: "text.bubble")
                    .labelStyle(.iconOnly)
                    .font(.system(size: 25))
                    .foregroundStyle(.foreground)
            }
            .offset(x: showCommentEnter ? 200 : 0)
            .sensoryFeedback(.impact(weight: .light, intensity: 0.7), trigger: showCommentEnter)
            
            
        }
        .frame(width: showCommentEnter ? 255 : 60)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 70))
        .padding(.vertical)
        .onChange(of: userComment) {
            Task {
                userStatus.currUserStatus = await display.uploadComment(userComment, status: userStatus.currUserStatus)
            }
        }
    }
    
    ///
    @ViewBuilder
    var reaction: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 70)
                .frame(width: 255, height: 60)
                .foregroundStyle(.regularMaterial)
            
            reactionButtons
        }
        .frame(width: showCommentEnter ? 60 : 255)
        .clipped()
        .clipShape(RoundedRectangle(cornerRadius: 70))
        .padding(.vertical)
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
        .padding(.trailing, 20)
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
                .offset(x: -32, y: 36)
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
        .frame(maxWidth: 280, maxHeight: 400)
        .scaledToFit()
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
