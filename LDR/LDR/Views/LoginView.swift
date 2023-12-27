//
//  LoginView.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import SwiftUI

struct LoginView: View {
    
    @Bindable private var login = LoginViewViewModel()
    
    var body: some View {
        VStack {
            // Header
            HeaderView(title: "LDR App",
                       subTitle: "Stay Connected",
                       angle: 15,
                       background: .mint)
            
            // Login Form
            Form {
                if !login.errorMessage.isEmpty {
                    Text(login.errorMessage)
                        .foregroundStyle(.red)
                }
                
                TextField("Email Address", text: $login.email)
                    .autocorrectionDisabled()
                SecureField("Password", text: $login.password)
                    .autocorrectionDisabled()
                    .autocapitalization(.none)
                
                LDRButton(title: "Log In",
                          background: .accentColor) {
                    // Attempt to Login
                    login.login()
                }
            }
            .offset(y: -50)
            
            // Create Account
            VStack {
                Text("New around here?")
                NavigationLink("Create An Account",
                               destination: RegisterView())
            }
            .padding()
            
            Spacer()
        }
    }
}

#Preview {
    LoginView()
}


