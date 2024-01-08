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
                    .frame(height: 80)
                    .padding(10)
                    .padding(.leading, 20)
                
                if display.othersReaction != "" {
                    Image(systemName: display.othersReaction)
                        .font(.system(size: 20))
                        .padding(8)
                        .background(.bar)
                        .foregroundStyle(.tint)
                        .clipShape(Circle())
                        .offset(x: -39, y: 30)
                }
                
                Spacer()
            }
            
            Divider().padding().frame(maxWidth: 300)
            
            // Others Emoji Displayed
            ZStack {
                Circle()
                    .frame(maxWidth: 250)
                Text(display.emojis[display.emojiToDisplay])
                    .font(.system(size: 180))
            }
            .padding(1)
            .minimumScaleFactor(0.1)
            
            // Photo to display
            if display.photoToDisplay != nil {
                let imageURL = URL(string: display.photoToDisplay!)
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
            
            Text(display.commentToDisplay)
                .padding(10)
                .padding(.horizontal, 15)
                .background(.regularMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .font(.system(size: 20))
                .fontWeight(.medium)
                .frame(maxWidth: 350, maxHeight: 100)
            
            Divider().frame(maxWidth: 300)
            
            reaction

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
        ZStack {
            RoundedRectangle(cornerRadius: 25)
                .frame(width: 250, height: 60)
                .padding()
                .foregroundStyle(.bar)
            
            reactionButtons
        }
        .minimumScaleFactor(0.8)
        
    }
}

#Preview {
    OthersDisplayView()
}
