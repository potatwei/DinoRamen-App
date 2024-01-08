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
                if friendsRequests.queriedUsers.count != 0 {
                    List(friendsRequests.queriedUsers, id: \.self.id) { user in
                        HStack {
                            UserBarView(userBar: UserBarViewViewModel(userToDisplay: user))
                            Spacer()
                            AddFriendButtonView(addFriendButton: AddFriendButtonViewViewModel(user), isPresenting: $isPresenting)
                        }
                    }
                } else {
                    VStack {
                        Image(systemName: "list.bullet.circle")
                            .foregroundStyle(Color.sugarBlue)
                            .font(.system(size: 100))
                            .fontWeight(.ultraLight)
                        Text("Connect Requests")
                            .padding(13)
                            .fontWeight(.semibold)
                            .font(.system(size: 30))
                        Text("When people ask to connect with you, you'll see their requests here.")
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: 310)
                            .foregroundStyle(.gray)
                            .font(.system(size: 17))
                    }
                    .offset(y:-120)
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
