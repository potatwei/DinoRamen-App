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
    
    var body: some View {
        VStack {
            
            // Emoji displaying with edit switches
            HStack {
                // Left switch
                emojiSwitchButton(offset: -1) {
                    userEdit.changeEmoji(by: -1)
                }
                // Emoji
                ZStack{
                    Circle()
                        .frame(maxWidth: 250)
                    Text(userEdit.emojis[userEdit.emojiToDisplay])
                        .font(.system(size: 180))
                }
                .animation(.default, value: userEdit.emojiToDisplay)
                // Right Switch
                emojiSwitchButton(offset: 1) {
                    userEdit.changeEmoji(by: 1)
                }
            }
            .padding()
            .padding(.top, 80)
            
            // Picuture to be displayed
            RoundedRectangle(cornerRadius: 25.0)
                .frame(maxWidth: 250, maxHeight: 200)
                .padding()
            
            // Comment to be displayed
            HStack {
                Image(systemName: "book.pages.fill")
                TextField("How do you feel", text: $userEdit.commentEntered)
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
            userEdit.fetchStatus()
            userEdit.syncComment()
        }
    }
    
    var uploadButton: some View {
        Button {
            userEdit.upload()
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
    UserEditView()
}
