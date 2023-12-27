//
//  OthersDisplayView.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import SwiftUI

struct OthersDisplayView: View {
    var display = OthersDisplayViewViewModel()
    
    private let userId: String
    
    init(userId: String) {
        self.userId = userId
    }
    
    var body: some View {
        VStack {
            HStack {
                Circle() // Profile Image
                    .frame(maxWidth: 80)
                    .padding(40)
                
                Spacer()
            }
            
            // Others Emoji Displayed
            Circle()
                .frame(maxWidth: 250)
            
            // Reactions and photo display
            ZStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .frame(maxWidth: 250, maxHeight: 200)
                
                Group {
                    RoundedRectangle(cornerRadius: 25)
                        .frame(maxWidth: 250, maxHeight: 60)
                        .padding()
                        .foregroundStyle(.bar)
                    HStack{
                        Button("Thumbs Up", systemImage: "hand.thumbsup.fill") {
                            display.reaction = "hand.thumbsup.circle.fill"
                        } .padding(2)
                        
                        Button("Thumbs Up", systemImage: "hand.thumbsup.fill") {
                            display.reaction = "hand.thumbsup.circle.fill"
                        } .padding(2)
                        
                        Button("Thumbs Up", systemImage: "hand.thumbsup.fill") {
                            display.reaction = "hand.thumbsup.circle.fill"
                        } .padding(2)
                        
                        Button("Thumbs Up", systemImage: "hand.thumbsup.fill") {
                            display.reaction = "hand.thumbsup.circle.fill"
                        } .padding(2)
                    }
                    .labelStyle(.iconOnly)
                    .font(.largeTitle)
                }
                .offset(y: -80)
            }
            .padding()
            
            RoundedRectangle(cornerRadius: 25.0)
                .frame(maxWidth: 350, maxHeight: 100)
            
            Spacer()
        }
    }
}

#Preview {
    OthersDisplayView(userId: "")
}
