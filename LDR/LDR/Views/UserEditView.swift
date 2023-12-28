//
//  UserEditView.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import SwiftUI

struct UserEditView: View {
    
    var userEdit = UserEditViewViewModel()
    
    var body: some View {
        VStack {
            
            // Emoji displaying with edit switches
            HStack {
                emojiSwitchButton(offset: -1) {
                    userEdit.changeEmoji(by: -1)
                }
                
                ZStack{
                    Circle()
                        .frame(maxWidth: 250)
                    Text(userEdit.emojis[userEdit.emojiToDisplay])
                        .font(.system(size: 180))
                }
                .animation(.default, value: userEdit.emojiToDisplay)
                
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
            ZStack {
                RoundedRectangle(cornerRadius: 25.0)
                    .frame(maxWidth: 350, maxHeight: 100)
                    .padding(.bottom, 10)
                
            }
            
            uploadButton
            
            Spacer()
        }
    }
    
    var uploadButton: some View {
        Button {
            // Upload photo, reaction and comment
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



#Preview {
    UserEditView()
}
