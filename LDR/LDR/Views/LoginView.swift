//
//  LoginView.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import SwiftUI
import GoogleSignIn
import GoogleSignInSwift
import FirebaseCore
import FirebaseAuth
import _AuthenticationServices_SwiftUI

struct LoginView: View {
    @Bindable private var login = LoginViewViewModel()
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var signInStatus: SignInEnvironment
    
    var body: some View {
        VStack {
            // Log In Button
            loginButton
        }
    }
    
    /// computed variable that contains styled button that will call ViewModel 'login' method login()
    @ViewBuilder
    var loginButton: some View {
        SignInWithAppleButton { request in
            login.appleLoginRequest(request)
        } onCompletion: { result in
            login.appleLoginCompletion(result)
        }
        .signInWithAppleButtonStyle(.whiteOutline)
        .frame(maxHeight: 40)
        .padding(.horizontal, 60)
        .padding(.vertical, 10)
        
        HStack {
            VStack{ Divider() }
            Text("or").padding(.horizontal)
            VStack{ Divider()}
        }
        .frame(width: 320)
        
        ZStack {
            Image("googleSignin")
                .frame(maxHeight: 40)
                .border(.white)
                .clipped()
                .padding(.horizontal, 45)
                .background(.white)
                .overlay(content: {
                    RoundedRectangle(cornerRadius: 6)
                        .stroke(lineWidth: 1.2)
                })
                .clipShape(RoundedRectangle(cornerRadius: 6))
                .padding(.vertical, 10)
                .foregroundStyle(.black)
            
            Button {
                guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                
                // Create Google Sign In configuration object.
                let config = GIDConfiguration(clientID: clientID)
                GIDSignIn.sharedInstance.configuration = config
                
                // Start the sign in flow!
                GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { result, error in
                    guard error == nil else {
                        print(error ?? "Error when sign in")
                        return
                    }
                    
                    guard let user = result?.user,
                          let idToken = user.idToken?.tokenString
                    else {
                        return
                    }
                    
                    let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                                   accessToken: user.accessToken.tokenString)
                    
                    Auth.auth().signIn(with: credential) {_,error in
                        
                    }
                    
                    let emailAddress = user.profile?.email
                    
                    Task {
                        await login.updateUserEmail(to: emailAddress)
                    }
                }
            } label: {
                RoundedRectangle(cornerRadius: 6)
                    .frame(width: 276, height: 40)
                    .foregroundStyle(.clear)
            }
        }
    }
}

#Preview {
    LoginView()
}


