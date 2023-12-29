//
//  SearchFriendView.swift
//  LDR
//
//  Created by Shihang Wei on 12/28/23.
//

import SwiftUI

struct SearchFriendView: View {
    var searchFriend = SearchFriendViewViewModel()
    @State var friendToSearch: String = ""
    
    var body: some View {
        let friendToSearchBinding = Binding<String> (
            get: {
                friendToSearch
            }, set: {
                friendToSearch = $0
                searchFriend.fetchUsers(from: friendToSearch)
            }
        )
        
        VStack {
            // Title
            Text("Connect to a Friend")
                .font(.largeTitle)
                .padding()
                .padding(.top, 30)
            
            VStack {
                // Search Bar
                HStack {
                    TextField("Search Friend...", text: friendToSearchBinding)
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
                
                // Displaying Users
                ScrollView {
                    ForEach(searchFriend.queriedUsers, id: \.id) { user in
                        UserBarView(userToDisplay: user)
                    }
                }
                
                Spacer()
            }
            .offset(y: 30)
            .background(.orange)
            .clipShape(RoundedCornersShape(corners: [.topLeft, .topRight], radius: 30))
            
        }
    }
}

struct RoundedCornersShape: Shape {
    let corners: UIRectCorner
    let radius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect,
                                byRoundingCorners: corners,
                                cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    SearchFriendView()
}
