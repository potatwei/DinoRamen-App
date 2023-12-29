//
//  ProfileView.swift
//  LDR
//
//  Created by Shihang Wei on 12/27/23.
//

import SwiftUI
import _PhotosUI_SwiftUI

struct ProfileView: View {
    @Bindable var profile = ProfileViewViewModel()
    
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
                    
                    // Change Profile Image
                    PhotosPicker(selection: $profile.selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
                        Image(systemName: "photo")
                        Text("Change Profile Image")
                    }
                    .onChange(of: profile.selectedPhoto) { oldValue, newValue in
                        Task {
                            do {
                                if let data = try await newValue?.loadTransferable(type: Data.self) {
                                    if let uiImage = UIImage(data: data) {
                                        Task {
                                            _ = await profile.saveImage(user: &profile.user!, image: uiImage)
                                        }
                                        print("Successfully selected image")
                                    }
                                }
                            } catch {
                                print("Selecting image failed \(error.localizedDescription)")
                            }
                        }
                    }
                    
                    // Add friend button and bring out a sheet
                    Button{
                        profile.showingSearchFriendView = true
                    } label: {
                        Label("Add Friend", systemImage: "person.fill.badge.plus")
                    }
                    .sheet(isPresented: $profile.showingSearchFriendView) {
                        SearchFriendView()
                    }
                    
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
                            Text("\(Date(timeIntervalSince1970: user.joined).formatted(date: .abbreviated, time: .omitted))")
                        }
                    }
                    
                    // Sign Out
                    Button("Log Out") {
                        profile.logOut()
                    }
                    .padding(.top, 20)
                    .foregroundStyle(.red)
                } else {
                    Text("Loading Profile...")
                    Button("Log Out") {
                        profile.logOut()
                    }
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
