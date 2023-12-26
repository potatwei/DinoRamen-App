//
//  LoginView.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import SwiftUI

struct LoginView: View {
    
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            // Header
            HeaderView()
            
            // Login Form
            Form {
                TextField("Email Address", text: $email)
                SecureField("Password", text: $password)
                
                Button {
                    // Attempt log in
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.tint)
                        Text("Log In")
                            .foregroundStyle(.white)
                            .bold()
                    }
                }
            }
            
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

struct HeaderView: View {
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .foregroundStyle(.mint)
                .rotationEffect(Angle(degrees: 15))
            VStack {
                Text("LDR APP")
                    .foregroundStyle(.white)
                    .bold()
                    .font(.system(size: 50))
                Text("Stay Connected")
                    .foregroundStyle(.white)
                    .font(.system(size: 25))
            }
            .padding(.top, 50)
        }
        .frame(width: 1000, height: 300)
        .offset(y: -95)
    }
}
