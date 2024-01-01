//
//  FriendsRequestsView.swift
//  LDR
//
//  Created by Shihang Wei on 12/31/23.
//

import SwiftUI

struct FriendsRequestsView: View {
    @Environment(\.dismiss) private var dismiss
    var friendsRequests = FriendsRequestsViewViewModel()
    @Binding var isPresenting: Bool
    
    var body: some View {
        NavigationStack {
            Group {
                List(friendsRequests.queriedUsers, id: \.self.id) { user in
                    HStack {
                        UserBarView(userBar: UserBarViewViewModel(userToDisplay: user))
                        Spacer()
                        AddFriendButtonView(addFriendButton: AddFriendButtonViewViewModel(user), isPresenting: $isPresenting)
                    }
                }
            }
            .toolbar {
                ToolbarItem {
                    Button("Dismiss") {
                        dismiss()
                    }
                }
            }
        }
        .onAppear {
            Task {
                await friendsRequests.fetchReceivedId()
                await friendsRequests.fetchUsers()
            }
        }
    }
}

#Preview {
    FriendsRequestsView(isPresenting: .constant(true))
}
