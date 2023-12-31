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
                if profile.user != nil {
                    // Showing Profile Image
                    profileImage

                    // Change Profile Image
                    photoPickerButton
                    
                    // Add friend button and bring out a sheet
                    addFriendButton
                    
                    // User Info
                    userInformation
                    
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
                    .foregroundStyle(.red)
                }
            }
            .toolbar{
                ToolbarItem{
                    Button {
                        profile.isSheetPresented = true
                    } label: {
                        Label("Friend Request", systemImage: "person.crop.circle.fill.badge.plus")
                    }
                }
            }
            .sheet(isPresented: $profile.isSheetPresented, content: {
                /*@START_MENU_TOKEN@*//*@PLACEHOLDER=Content@*/Text("Sheet Content")/*@END_MENU_TOKEN@*/
            })
            .navigationTitle("Profile")
        }
        .onAppear() {
            profile.fetchUser()
        }
    }
    
    /// - Returns: `AsyncImage` object that download the current user profile image from firebase
    /// the `AsyncImage` has a default lable of "person.circle"
    var profileImage: some View {
        let imageURL = URL(string: profile.user!.profileImage)
        return AsyncImage(url: imageURL) { image in
            image
                .resizable()
                .scaledToFill()
        } placeholder: {
            Image(systemName: "person.circle")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .foregroundStyle(.blue)
        }
        .frame(width: 125, height: 125)
        .clipShape(Circle())
        .padding(.bottom, 20)
    }
    
    /// When an image is selected, the current profile image will be deleted from database, then a new image
    /// will be save in and `profileImageId` and `profileImage` in `profile.user` will be changed accordingly
    var photoPickerButton: some View {
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
                                await profile.deleteOldImage()
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
    }
    
    /// Bring out a sheet that contains `SearchFriendView()`
    var addFriendButton: some View {
        Button{
            profile.showingSearchFriendView = true
        } label: {
            Label("Add Friend", systemImage: "person.fill.badge.plus")
        }
        .sheet(isPresented: $profile.showingSearchFriendView) {
            SearchFriendView()
        }
    }
    
    /// Display three fields, Name, Email, and Memeber Since
    var userInformation: some View {
        VStack(alignment: .leading, spacing: 20) {
            HStack {
                Text("Name: ")
                    .bold()
                Text(profile.user!.name)
            }
            HStack {
                Text("Email: ")
                    .bold()
                Text(profile.user!.email)
            }
            HStack {
                Text("Memeber Since: ")
                    .bold()
                Text("\(Date(timeIntervalSince1970: profile.user!.joined).formatted(date: .abbreviated, time: .omitted))")
            }
        }
    }
}

#Preview {
    ProfileView()
}
