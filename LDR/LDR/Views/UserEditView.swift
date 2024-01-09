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
    
    @EnvironmentObject var userStatus: UserStatusEnvironment
    
    var body: some View {
        VStack {
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
            
            // Emoji displaying with edit switches
            HStack {
                // Left switch
                emojiSwitchButton(offset: -1) { userStatus.changeEmoji(by: -1) }
                // Emoji
                ZStack{
                    Circle()
                        .frame(maxWidth: 250)
                    Text(userEdit.emojis[userStatus.currUserStatus.emoji])
                        .font(.system(size: 180))
                }
                // Right Switch
                emojiSwitchButton(offset: 1) { userStatus.changeEmoji(by: 1) }
            }
            .padding()
            .minimumScaleFactor(0.5)
            
            // Picuture to be displayed
            ZStack {
                if userEdit.takenImage != nil || userStatus.currUserStatus.image != nil {
                    if userEdit.takenImage != nil {
                        Image(uiImage: userEdit.takenImage!)
                            .resizable()
                            .scaledToFill()
                            .frame(maxWidth: 250, maxHeight: 200)
                            .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    } else if let imageURL = userStatus.currUserStatus.image{
                        let imageURL = URL(string: imageURL)
                        AsyncImage(url: imageURL) { Image in
                            Image
                                .resizable()
                        } placeholder: {
                            RoundedRectangle(cornerRadius: 25.0)
                        }
                        .scaledToFill()
                        .frame(maxWidth: 250, maxHeight: 200)
                        .clipShape(RoundedRectangle(cornerRadius: 25.0))
                    }
                    Button {
                        // turn on camera
                        showCamera = true
                    } label: {
                        RoundedRectangle(cornerRadius: 25.0)
                            .frame(maxWidth: 250, maxHeight: 200)
                    }
                    .foregroundStyle(.clear)
                } else {
                    // Photo to display
                    RoundedRectangle(cornerRadius: 25.0)
                        .frame(maxWidth: 250, maxHeight: 200)
                    
                    Button {
                        // turn on camera
                        showCamera = true
                    } label: {
                        Label("Add Image", systemImage: "plus")
                            .labelStyle(.iconOnly)
                    }
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .font(.system(size: 80))
                }
            }
            
            // Comment to be displayed
            HStack {
                Image(systemName: "book.pages.fill")
                TextField("\(userStatus.currUserStatus.comment == "" ? "Comment..." : userStatus.currUserStatus.comment)",
                          text: $enteredText)
            }
            .modifier(customViewModifier(roundedCornes: 10,
                                         startColor: .orange,
                                         endColor: .purple,
                                         textColor: .white))
            // Upload Button
            uploadButton
            
            Spacer()
        }
        .onAppear {
            // fetch data from database and sync comment
            Task {
                await userStatus.fetchCurrentUserStatus()
            }
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
    
    var uploadButton: some View {
        Button {
            Task {
                userStatus.currUserStatus = await userEdit.upload(userStatus.currUserStatus, comment: enteredText)
            }
            tabSelection = 0
        } label: {
            Text("UpLoad")
                .font(.largeTitle)
                .padding(6)
        }
        .buttonStyle(.bordered)
        .foregroundStyle(.white)
        .background(.blue)
        .clipShape(RoundedRectangle(cornerRadius: 15.0))
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
