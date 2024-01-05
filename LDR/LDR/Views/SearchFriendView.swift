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
    @State var friendToSearch: String = ""
    
    var body: some View {
        let friendToSearchBinding = Binding<String> (
            get: {
                friendToSearch
            }, set: {
                friendToSearch = $0
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
        }
    }
}

#Preview {
    SearchFriendView()
}
