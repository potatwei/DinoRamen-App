//
//  SearchFriendView.swift
//  LDR
//
//  Created by Shihang Wei on 12/28/23.
//

import SwiftUI

struct SearchFriendView: View {
    @Bindable var searchFriend = SearchFriendViewViewModel()
    
    var body: some View {
        VStack {
            // Title
            Text("Connect to a Friend")
                .font(.largeTitle)
                .padding()
                .padding(.top, 30)
                .offset(y: 50)
            
            ZStack {
                // Background
                RoundedRectangle(cornerRadius: 25.0)
                    .frame(height: 800)
                    
                    .foregroundStyle(.orange)
                
                
                VStack {
                    // Search Bar
                    HStack {
                        TextField("Search Friend...", text: $searchFriend.friendToSearch)
                            .padding()
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                            .padding(.leading)
                        
                        Button{
                            // Search in data base and return userId
                            //searchFriend.search()
                        } label: {
                            Label("Search Button", systemImage: "magnifyingglass.circle")
                                .labelStyle(.iconOnly)
                        }
                        .padding(.trailing, 25)
                        .font(.largeTitle)
                        .foregroundStyle(.white)
                    }
                        
                    // display userInfo using returned userId with an add button
                    
                    Spacer()
                }
                .offset(y: 30)
            }
            .offset(y: 50)
        }
    }
}

#Preview {
    SearchFriendView()
}
