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
                UserBarView(userBar: UserBarViewViewModel(userToDisplay: user))
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
