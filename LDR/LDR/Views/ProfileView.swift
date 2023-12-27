//
//  ProfileView.swift
//  LDR
//
//  Created by Shihang Wei on 12/27/23.
//

import SwiftUI

struct ProfileView: View {
    var profile = ProfileViewViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if let user = profile.user {
                    Image(systemName: "person.circle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundStyle(.blue)
                        .frame(width: 125, height: 125)
                        .padding(.bottom, 20)
                    
                    // User Info
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("Name: ")
                                .bold()
                            Text(user.name)
                        }
                        HStack {
                            Text("Email: ")
                                .bold()
                            Text(user.email)
                        }
                        HStack {
                            Text("Memeber Since: ")
                                .bold()
                            Text("\(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .shortened))")
                        }
                    }
                    
                    // Sign Out
                    Button("Log Out") {
                        profile.logOut()
                    }
                    .padding(.top, 20)
                    .foregroundStyle(.red)
                } else {
                    Text("Loading Profile")
                }
            }
            .navigationTitle("Profile")
        }
        .onAppear() {
            profile.fetchUser()
        }
    }
}

#Preview {
    ProfileView()
}
