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
    @State var refreshImage = false
    
    @EnvironmentObject var userStatus: UserStatusEnvironment
    
    var body: some View {
        VStack {
            HStack {
                ZStack {
                    if userStatus.connUserStatus.id != "" && userStatus.currUserStatus.id != "" {
                        if userStatus.currUserStatus.image != nil {
                            ownImageAndOwnEmoji // Display Image and Own's Emoji
                        } else {
                            ownEmojiOnly // Display Own's Emoji Only
                        }
                        ifOwnHasComment // Show own comment in three dots
                        
                        userEditViewButton // Go to UserEditView
                    } else {
                        ShimmerEffectBox() // Display loading screen when still getting info from server
                            .frame(width: 90, height: 90)
                            .clipShape(Circle())
                    }
                }
                .padding(.leading, 20)
                
                VStack(alignment: .leading) {
                    othersReaction // Show other's reaction on own status
                    
                    othersCommentEdit // Show other's comment on own status
                }
                
                Spacer()
                
                profileButton // Profile button that jumps to profile page
            }
            
            Divider().frame(maxWidth: 330).padding()
            
            if userStatus.connUserStatus.id != "" && userStatus.currUserStatus.id != "" {
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
                    
                    if userStatus.connUserStatus.comment != "" {
                        othersComment
                            .font(.system(size: 27))
                    }
                }
            } else {
                ShimmerEffectBox()
                    .frame(maxWidth: 280, maxHeight: 400)
                    .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    .padding(.top, 60)
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
        .onDisappear {
            refreshImage.toggle()
        }
        .task {
            await userStatus.fetchCurrentUserStatus()
            await userStatus.fetchOtherUserStatus()
        }
    }
    
    ///
    @ViewBuilder
    var othersCommentEdit: some View {
        Text(userStatus.connUserStatus.commentMade ?? "")
            .font(.system(size: 15))
            .padding(5)
            .padding(.horizontal, 10)
            .background(.bar)
            .foregroundStyle(.sugarOrange)
            .clipShape(Capsule())
            .offset(x: -22, y: 10)
            .lineLimit(2)
            // Below are for fly-in animation
            .offset(x: userStatus.connUserStatus.commentMade != nil && userStatus.connUserStatus.commentMade != "" ? 0 : 300)
            .opacity(userStatus.connUserStatus.commentMade != nil && userStatus.connUserStatus.commentMade != "" ? 1 : 0)
            .animation(.bouncy(duration: 0.2, extraBounce: -0.1), value: userStatus.connUserStatus.commentMade)
    }
    
    ///
    @ViewBuilder
    var ifOwnHasComment: some View {
        if userStatus.currUserStatus.comment != "" {
            Image(systemName: "ellipsis")
                .font(.system(size: 17))
                .fontWeight(.semibold)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(.thickMaterial)
                .clipShape(.capsule)
                .offset(y: 27)
        }
    }
    
    ///
    @ViewBuilder
    var userEditViewButton: some View {
        Button {
            tabSelection = 1
        } label: {
            Circle().foregroundStyle(.clear)
        }
        .frame(width: 90, height: 90)
    }
    
    ///
    @ViewBuilder
    var ownImageAndOwnEmoji: some View {
        // Show own uploaded image
        AsyncImage(url: URL(string: userStatus.currUserStatus.image!)) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            ShimmerEffectBox()
        }
        .accentColor(refreshImage ? .black : .black)
        .frame(width: 90, height: 90)
        .clipShape(Circle())
        .opacity(0.7)
        
        // Show own emoji
        Text(display.emojis[userStatus.currUserStatus.emoji])
            .font(.title)
            .offset(x: -30, y: -30)
            .opacity(0.7)
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
                hideKeyboard()
                withAnimation(.bouncy(duration: 0.25, extraBounce: -0.05)) {
                    showCommentEnter = false
                }
                Task {
                    userStatus.currUserStatus = await display.uploadComment(userComment, status: userStatus.currUserStatus)
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
            
            TextField(userStatus.currUserStatus.commentMade != nil && userStatus.currUserStatus.commentMade != "" ?  userStatus.currUserStatus.commentMade! :"Comment...", text: $userComment)
                .offset(x: showCommentEnter ? 0 : 200)
                .padding()
                .frame(width: showCommentEnter ? 255 : 0)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .onSubmit {
                    hideKeyboard()
                    Task {
                        userStatus.currUserStatus = await display.uploadComment(userComment, status: userStatus.currUserStatus)
                    }
                }
            
            Button {
                withAnimation(.bouncy(duration: 0.25, extraBounce: -0.05)) {
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
//        .onChange(of: userComment) {
//            Task {
//                userStatus.currUserStatus = await display.uploadComment(userComment, status: userStatus.currUserStatus)
//            }
//        }
    }
    
    ///
    @ViewBuilder
    var ownEmojiOnly: some View {
        // Only show own emoji
        ZStack {
            Circle().foregroundStyle(.regularMaterial)
            
            Text(display.emojis[userStatus.currUserStatus.emoji])
                .font(.system(size: 80))
                .opacity(0.7)
        }
        .frame(width: 90, height: 90)
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
                    .foregroundStyle(userStatus.currUserStatus.reaction == defau ? .white : .sugarBlue)
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
                .padding(7)
                .background(.sugarPink)
                .foregroundStyle(.white)
                .clipShape(Circle())
                .offset(x: userStatus.connUserStatus.commentMade != nil && userStatus.connUserStatus.commentMade != "" ? -12 : -30,
                        y: userStatus.connUserStatus.commentMade != nil && userStatus.connUserStatus.commentMade != "" ? 19 : 46)
                .animation(.bouncy, value: userStatus.connUserStatus.commentMade)
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
            ShimmerEffectBox()
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
        }
        .accentColor(refreshImage ? .black : .black)
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
