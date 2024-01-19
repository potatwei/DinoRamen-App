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
    @EnvironmentObject var signInStatus: SignInEnvironment
    @State var buttonHaptic = true
    
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
                .foregroundStyle(.black)
                
            Button {
                setUserName.register(userName: enteredUserName)
                signInStatus.isUserExist()
                buttonHaptic.toggle()
            } label: {
                Label("Submit user name", systemImage: "arrow.right.circle")
                    .labelStyle(.iconOnly)
                    .fontWeight(.light)
                    .font(.system(size: 70))
                    .foregroundStyle(Gradient(colors: [.sugarOrange, .sugarYellow]))
            }
            .padding(30)
            .sensoryFeedback(.impact(weight: .light, intensity: 0.7), trigger: buttonHaptic)
            
            Spacer()
        }
    }
}

#Preview {
    SetUserNameView()
        .environmentObject(SignInEnvironment())
}
