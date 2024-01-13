//
//  UserEditView.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct UserEditView: View {
    
    @Bindable var userEdit = UserEditViewViewModel()
    @Binding var tabSelection: Int
    @State var enteredText = ""
    @State var showCamera = false
    @State var refreshImage = false
    
    @EnvironmentObject var userStatus: UserStatusEnvironment
    
    var body: some View {
        VStack {
            // Title and Back Button
            titleAndBackButton
            
            // Picuture to be displayed
            ZStack {
                if userEdit.takenImage != nil {
                    // Straightly display the taken image with a clear camera button covering it
                    displayTakenImage
                } else if userStatus.currUserStatus.image != nil {
                    // Display uploaded image with a blur and camera button over it
                    currentUserUploadedImage
                } else {
                    // Colorful image and a camera button as default
                    defaultImage
                }
            }
            .frame(minHeight: 300)
            .sensoryFeedback(.impact(weight: .light, intensity: 0.7), trigger: showCamera)
            
            // Emoji displaying with edit switches
            
            
            Spacer()
            
            // Comment to be displayed
            ZStack {
                HStack {
                    // Left switch
                    emojiSwitchButton(offset: -1) { userStatus.changeEmoji(by: -1) }
                    // Emoji
                    Image(userEdit.emojis[userStatus.currUserStatus.emoji])
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: 120, maxHeight: 120)
                    // Right Switch
                    emojiSwitchButton(offset: 1) { userStatus.changeEmoji(by: 1) }
                }
                .sensoryFeedback(.impact(weight: .light, intensity: 0.7), trigger: userStatus.currUserStatus.emoji)
                .offset(x: 0, y: -90)
                
                HStack {
                    Image(systemName: "book.pages.fill")
                    TextField("\(userStatus.currUserStatus.comment == "" ? "Comment..." : userStatus.currUserStatus.comment)",
                              text: $enteredText)
                }
                .modifier(customViewModifier(roundedCornes: 10, startColor: .orange, endColor: .purple, textColor: .white))
                .offset(y: 15)
            }
            
            // Upload Button
            uploadButton
        }
        .onDisappear(perform: {
            userEdit.takenImage = nil
            enteredText = ""
            refreshImage.toggle()
        })
        .task {
            // fetch data from database and sync comment
            await userStatus.fetchCurrentUserStatus()
        }
        .fullScreenCover(isPresented: $showCamera, content: {
            // Show Camera View
            CustomCameraView(capturedImage: $userEdit.takenImage)
                .gesture(
                    DragGesture(minimumDistance: 50, coordinateSpace: .local)
                        .onEnded {value in
                            if value.translation.height > 50 {
                                showCamera = false
                            }
                        }
                )
        })
    }
    
    ///
    @ViewBuilder
    var defaultImage: some View {
        // Photo to display
        Group {
            RoundedRectangle(cornerRadius: 25.0)
                .frame(maxWidth: 280, maxHeight: 401)
                .foregroundStyle(Gradient(colors: [.sugarMint,.sugarBlue]))
            
            Button {
                // turn on camera
                showCamera = true
            } label: {
                Label("Add Image", systemImage: "plus")
                    .foregroundStyle(Gradient(colors: [.sugarOrange, .sugarYellow]))
                    .labelStyle(.iconOnly)
            }
            .foregroundStyle(.white)
            .fontWeight(.bold)
            .font(.system(size: 90))
        }
    }
    
    ///
    @ViewBuilder
    var currentUserUploadedImage: some View {
        Group {
            let imageURL = URL(string: userStatus.currUserStatus.image!)
            AsyncImage(url: imageURL) { Image in
                Image
                    .resizable()
            } placeholder: {
                ShimmerEffectBox()
                    .aspectRatio(0.6984127, contentMode: .fit)
                    .clipShape(RoundedRectangle(cornerRadius: 25))
            }
            .accentColor(refreshImage ? .black : .black)
            .frame(maxWidth: 280, maxHeight: 401)
            .scaledToFit()
            .clipShape(RoundedRectangle(cornerRadius: 25.0))
            
            RoundedRectangle(cornerRadius: 25.0)
                .frame(maxWidth: 280, maxHeight: 401)
                .foregroundStyle(.ultraThinMaterial)
                .aspectRatio(0.6984127, contentMode: .fit)
            
            Button {
                // turn on camera
                showCamera = true
            } label: {
                Label("Add Image", systemImage: "plus")
                    .labelStyle(.iconOnly)
                    .foregroundStyle(Gradient(colors: [.sugarOrange, .sugarYellow]))
                    .fontWeight(.bold)
                    .font(.system(size: 90))
            }
        }
    }
    
    ///
    @ViewBuilder
    var displayTakenImage: some View {
        Group {
            Image(uiImage: userEdit.takenImage!)
                .resizable()
                .frame(maxWidth: 280, maxHeight: 401)
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 25.0))
            
            Button {
                // turn on camera
                showCamera = true
            } label: {
                RoundedRectangle(cornerRadius: 25)
                    .frame(maxWidth: 220, maxHeight: 315)
                    .foregroundStyle(.clear)
            }
        }
    }
    
    ///
    @ViewBuilder
    var uploadButton: some View {
        ZStack {
            Button {
                Task {
                    userStatus.currUserStatus = await userEdit.upload(userStatus.currUserStatus, comment: enteredText)
                }
                tabSelection = 0
            } label: {
                    Label("Upload", systemImage: "link")
                        .labelStyle(.iconOnly)
                        .font(.system(size: 40))
                        .padding(4)
                        .foregroundStyle(.white)
            }
            .buttonStyle(.bordered)
            .frame(maxWidth: 70, maxHeight: 70)
            .background(Gradient(colors: [.sugarPink, .sugarOrange]))
            .clipShape(Circle())
            
            Circle()
                .stroke(Gradient(colors: [.sugarPink, .sugarOrange]), lineWidth: 5)
                .frame(maxWidth: 78,maxHeight: 78)
            
            Spacer()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .padding(5)
    }
    
    ///
    @ViewBuilder
    var titleAndBackButton: some View {
        HStack {
            Text("Edit")
                .font(.system(size: 42))
                .fontWeight(.bold)
                .padding(.horizontal, 20)
                .padding(.top, 35)
            
            Spacer()
            
            Button {
                tabSelection = 0
            } label: {
                Image(systemName: "chevron.right")
                    .foregroundStyle(.foreground)
                    .font(.system(size: 30))
                    .fontWeight(.bold)
                    .offset(y: 18)
                    .padding(.trailing, 10)
            }
        }
    }
}

struct customViewModifier: ViewModifier {
    var roundedCornes: CGFloat
    var startColor: Color
    var endColor: Color
    var textColor: Color

    func body(content: Content) -> some View {
        content
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [startColor, endColor]),
                                       startPoint: .topLeading,
                                       endPoint: .bottomTrailing))
            .cornerRadius(roundedCornes)
            .padding(.horizontal, 20)
            .padding()
            .foregroundColor(textColor)
            .font(.custom("Open Sans", size: 20))
            .shadow(radius: 10)
    }
}

#Preview {
    UserEditView(tabSelection: .constant(0))
        .environmentObject(UserEnvironment())
        .environmentObject(UserStatusEnvironment())
}
