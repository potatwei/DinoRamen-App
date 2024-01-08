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
                    HStack {
                        // Showing Profile Image
                        profileImage
                        
                        // Showing Name and Email and Member Since
                        userInformation
                        
                        Spacer()
                    }
                    .padding(.vertical, 35)
                    
                    // Change Profile Image
                    VStack(alignment: .leading) { photoPickerButton }
                    
                    Divider().frame(maxWidth: 200)
                    
                    VStack(alignment: .leading) {
                        // Add friend button and bring out a sheet
                        addFriendButton
                        
                        // Show Friend Request
                        connectRequestsButton
                    }
                    
                    Divider().frame(maxWidth: 200)
                    
                    // Sign Out
                    signoutButton
                    
                    Spacer()
                    
                } else {
                    Text("Loading Profile...")
                    signoutButton
                }
            }
            .sheet(isPresented: $profile.isSheetPresented, content: {
                FriendsRequestsView(isPresenting: $profile.isSheetPresented)
            })
            .navigationTitle("Profile")
        }
        .onAppear() {
            Task {
                await profile.fetchUser()
            }
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
        .frame(width: 100, height: 100)
        .clipShape(Circle())
        .padding(15)
        .padding(.leading, 15)

    }
    
    /// When an image is selected, the current profile image will be deleted from database, then a new image
    /// will be save in and `profileImageId` and `profileImage` in `profile.user` will be changed accordingly
    var photoPickerButton: some View {
        PhotosPicker(selection: $profile.selectedPhoto, matching: .images, preferredItemEncoding: .automatic) {
            HStack {
                Image(systemName: "photo")
                    .foregroundStyle(.sugerLightMint)
                    .frame(width: 30, height: 30)
                    .padding(.leading, 10)
                    .padding(.trailing, 3)
                Group { Text("Change profile image")}
                    .foregroundStyle(.foreground)
                
                Spacer()
                
                Image(systemName: "chevron.forward")
                    .foregroundStyle(.foreground)
                    .padding(.trailing, 15)
            }
            .padding(.bottom, 15)
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
            HStack {
                Image(systemName: "person.fill.badge.plus")
                    .foregroundStyle(.sugerLightMint)
                    .frame(width: 30, height: 30)
                    .padding(.leading, 10)
                    .padding(.trailing, 3)
                    .offset(y: 1)
                    
                Group { Text("Search friend") }
                    .foregroundStyle(.foreground)
                
                Spacer()
                
                Image(systemName: "chevron.forward")
                    .foregroundStyle(.foreground)
                    .padding(.trailing, 15)
            }
            .padding(.top, 15)
        }
        .sheet(isPresented: $profile.showingSearchFriendView) {
            SearchFriendView()
        }
    }
    
    /// Display three fields, Name, Email, and Memeber Since
    var userInformation: some View {
        VStack(alignment:.leading){
            Text(profile.user!.name)
                .font(.system(size: 35))
                .bold()
                .minimumScaleFactor(0.9)
            
            Spacer()
            
            Group {
                Text(profile.user!.email)
                
                HStack {
                    Text("Since")
                    Text("\(Date(timeIntervalSince1970: profile.user!.joined).formatted(date: .abbreviated, time: .omitted))")
                }
            }
            .foregroundStyle(.gray)
            .font(.system(size: 17))
            .minimumScaleFactor(0.9)
        }
        .frame(maxHeight: 85)
    }
    
    ///
    var connectRequestsButton: some View {
        Button {
            profile.isSheetPresented = true
        } label: {
            HStack {
                Image(systemName: "list.dash")
                    .foregroundStyle(.sugerLightMint)
                    .frame(width: 30, height: 30)
                    .padding(.leading, 10)
                    .padding(.trailing, 3)
                    .offset(y: 0.5)
                    
                Group { Text("Connect requests") }
                    .foregroundStyle(.foreground)
                
                Spacer()
                
                Image(systemName: "chevron.forward")
                    .foregroundStyle(.foreground)
                    .padding(.trailing, 15)
            }
            .padding(.bottom, 18)
        }
    }
    
    ///
    var signoutButton: some View {
        Button {
            profile.logOut()
        } label: {
            Text("Log out")
                .padding(12)
                .padding(.horizontal, 50)
                .foregroundStyle(.white)
                .background(.red)
                .clipShape(Capsule())
                .padding(.top, 20)
        }
        
    }
}

#Preview {
    ProfileView()
}
