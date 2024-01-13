//
//  SearchFriendView.swift
//  LDR
//
//  Created by Shihang Wei on 12/28/23.
//

import SwiftUI

struct SearchFriendView: View {
    var searchFriend = SearchFriendViewViewModel()
    @Environment(\.dismiss) private var dismiss
    @Environment(\.colorScheme) var colorScheme
    @State var friendToSearch: String = ""
    
    var body: some View {
        let friendToSearchBinding = Binding<String> (
            get: {
                friendToSearch
            }, set: {
                friendToSearch = $0
                if friendToSearch.isEmpty {
                    searchFriend.queriedUsers = []
                }
                searchFriend.fetchUsers(from: friendToSearch.uppercased())
            }
        )
        
        NavigationStack {
            List(searchFriend.queriedUsers, id: \.self.id) { user in
                HStack {
                    UserBarView(userBar: UserBarViewViewModel(userToDisplay: user))
                    Spacer()
                    FriendRequestButtonView(friendRequestButton: FriendRequestViewViewModel(userToDisplay: user))
                }
            }
            .listStyle(.plain)
            .searchable(text: friendToSearchBinding)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
            .overlay {
                if searchFriend.queriedUsers.isEmpty, !friendToSearch.isEmpty {
                    ContentUnavailableView.search
                }
            }
            if friendToSearch == "" {
                VStack {
                    Spacer()
                    Image(systemName: colorScheme == .light ? "person.crop.circle.fill.badge.plus" : "person.crop.circle.badge.plus")
                        .foregroundStyle(Color.sugarOrange)
                        .font(.system(size: 100))
                        .fontWeight(.ultraLight)
                        .offset(y: 20)
                    Text("Search Friends")
                        .padding(13)
                        .fontWeight(.semibold)
                        .font(.system(size: 30))
                    Text("Looking for connections by entering friend's user name or email")
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 310)
                        .foregroundStyle(.gray)
                        .font(.system(size: 17))
                }
                .offset(y:-340)
                .ignoresSafeArea(.keyboard, edges: .bottom)
            }
        }
    }
}

#Preview {
    SearchFriendView()
}
