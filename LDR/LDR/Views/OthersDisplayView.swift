//
//  OthersDisplayView.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import SwiftUI

struct OthersDisplayView: View {
    @Bindable var display = OthersDisplayViewViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Circle() // Profile Image
                    .frame(maxWidth: 80)
                    .padding(40)
                
                if display.othersReaction != "" {
                    Image(systemName: display.othersReaction)
                        .font(.system(size: 20))
                        .padding(8)
                        .background(.bar)
                        .foregroundStyle(.tint)
                        .clipShape(Circle())
                        .offset(x: -70, y: 30)
                }
                
                Spacer()
            }
            
            // Others Emoji Displayed
            ZStack {
                Circle()
                    .frame(maxWidth: 250)
                Text(display.emojis[display.emojiToDisplay])
                    .font(.system(size: 180))
                Button {
                    display.showReactions.toggle()
                } label: {
                    Circle()
                        .frame(maxWidth: 180)
                        .opacity(0)
                }
            }
            .padding(1)
            
            // Reactions and photo display
            ZStack {
                // Photo to display
                RoundedRectangle(cornerRadius: 25.0)
                    .frame(maxWidth: 250, maxHeight: 200)
                
                
                // Reactions
                if display.showReactions {
                    reaction
                }
            }
            .padding()
            
            ZStack {
                RoundedRectangle(cornerRadius: 25.0)
                Text(display.commentToDisplay)
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: 350, maxHeight: 100)
                
            
            Spacer()
        }
        .onAppear {
            Task {
                await display.fetchStatus()
            }
        }
        
    }
    
    var reactionButtons: some View {
        HStack{
            // TODO: Better Animation
            // Thumbs Up
            Button {

                    display.selectReaction("hand.thumbsup.fill")
                
            } label: {
                if display.ownsReaction != "hand.thumbsup.fill"{
                    Label("Thumbs Up", systemImage: "hand.thumbsup.fill")
                } else {
                    Label("Selected Thumbs Up", systemImage: "hand.thumbsup.circle")
                }
            }
            .padding(5)
            
            // Exclamationmark
            Button {

                    display.selectReaction("exclamationmark.2")
                
            } label: {
                if display.ownsReaction != "exclamationmark.2"{
                    Label("Exclamationmark", systemImage: "exclamationmark.2")
                } else {
                    Label("Selected Exclamationmark", systemImage: "exclamationmark")
                }
            }
            .padding(5)
            
            // Heart
            Button {
                
                    display.selectReaction("heart.fill")
                
            } label: {
                if display.ownsReaction != "heart.fill"{
                    Label("Heart", systemImage: "heart.fill")
                } else {
                    Label("Selected Heart", systemImage: "heart.circle")
                }
            }
            .padding(5)

            // Thumbs Down
            Button {
           
                    display.selectReaction("hand.thumbsdown.fill")
      
            } label: {
                if display.ownsReaction != "hand.thumbsdown.fill"{
                    Label("Thumbsdown", systemImage: "hand.thumbsdown.fill")
                } else {
                    Label("Selected Thumbsdown", systemImage: "hand.thumbsdown.circle")
                }
            }
            .padding(5)
        }
        .labelStyle(.iconOnly)
        .font(.largeTitle)
        .onAppear {
            Task {
                await display.fetchStatus()
            }
        }
    }
    
    var reaction: some View {
        Group {
            RoundedRectangle(cornerRadius: 25)
                .frame(maxWidth: 250, maxHeight: 60)
                .padding()
                .foregroundStyle(.bar)
            
            reactionButtons
        }
        .offset(y: -80)
    }
}

#Preview {
    OthersDisplayView()
}
