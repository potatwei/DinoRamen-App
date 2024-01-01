//
//  OthersDisplayView.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import SwiftUI

struct OthersDisplayView: View {
    var display = OthersDisplayViewViewModel()
    
    var body: some View {
        VStack {
            HStack {
                Circle() // Profile Image
                    .frame(maxWidth: 80)
                    .padding(40)
                
                Spacer()
            }
            
            // Others Emoji Displayed
            ZStack {
                Circle()
                    .frame(maxWidth: 250)
                Text(display.emojis[display.emojiToDisplay])
                    .font(.system(size: 180))
            }
            .padding(1)
            
            // Reactions and photo display
            ZStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .frame(maxWidth: 250, maxHeight: 200)
                
                reaction
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
                await display.getReaction()
            }
        }
    }
    
    var reactionButtons: some View {
        HStack{
            Button {
                display.selectReaction("hand.thumbsup.fill")
            } label: {
                if display.reaction != "hand.thumbsup.fill"{
                    Label("Thumbs Up", systemImage: "hand.thumbsup.fill")
                } else {
                    Label("Selected Thumbs Up", systemImage: "hand.thumbsup.circle")
                }
            }
            .padding(5)
            
            Button("Thumbs Up", systemImage: "exclamationmark.2") {
                display.reaction = "exclamationmark.2"
            } .padding(5)
            
            Button("Thumbs Up", systemImage: "heart.fill") {
                display.reaction = "heart.fill"
            } .padding(5)
            
            Button("Thumbs Up", systemImage: "hand.thumbsdown.fill") {
                display.reaction = "hand.thumbsdown.fill"
            } .padding(5)
        }
        .labelStyle(.iconOnly)
        .font(.largeTitle)
        .onAppear {
            Task {
                await display.getReaction()
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
