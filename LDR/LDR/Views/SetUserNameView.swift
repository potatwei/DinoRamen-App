//
//  SetUserNameView.swift
//  LDR
//
//  Created by Shihang Wei on 1/18/24.
//

import SwiftUI

struct SetUserNameView: View {
    var setUserName = SetUserNameViewViewModel()
    @State var enteredUserName = ""
    @Binding var ifUserExist: Bool
    
    var body: some View {
        VStack {
            Text("Set up User Name")
                .fontWeight(.heavy)
                .font(.system(size: 37))
                .foregroundStyle(Gradient(colors: [.sugarOrange, .sugarYellow]))
                .padding()
                .padding(.top, 180)
            Text("User name is used in searching and notifications")
                .frame(width: 300)
                .bold()
                .font(.system(size: 19))
                .foregroundStyle(.gray)
                .padding(.bottom, 30)
            
            if setUserName.errorMessage != "" {
                Text(setUserName.errorMessage)
                    .foregroundStyle(.sugarOrange)
                    .padding()
            }
            
            TextField("your user name", text: $enteredUserName)
                .padding()
                .background((Gradient(colors: [.white, .white])))
                .clipShape(RoundedRectangle(cornerRadius: 20))
                .padding(.horizontal, 30)
                .padding()
                .shadow(radius: 10)
                
            Button {
                setUserName.register(userName: enteredUserName)
                ifUserExist = true
            } label: {
                Label("Submit user name", systemImage: "arrow.right.circle")
                    .labelStyle(.iconOnly)
                    .fontWeight(.light)
                    .font(.system(size: 70))
                    .foregroundStyle(Gradient(colors: [.sugarOrange, .sugarYellow]))
            }
            .padding(30)
            
            Spacer()
        }
    }
}

#Preview {
    SetUserNameView(ifUserExist: .constant(true))
}
