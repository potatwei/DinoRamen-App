//
//  FriendsRequestsView.swift
//  LDR
//
//  Created by Shihang Wei on 12/31/23.
//

import SwiftUI

struct FriendsRequestsView: View {
    var friendsRequests = FriendsRequestsViewViewModel()
    
    var body: some View {
        Text("")
        List(friendsRequests.queriedUsers, id: \.self.id) { user in
            HStack {
                UserBarView(userBar: UserBarViewViewModel(userToDisplay: user))
                Spacer()
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
    FriendsRequestsView()
}
