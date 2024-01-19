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
    @FocusState private var focusField: Field?
    
    enum Field {
        case email, password
    }
    
    var body: some View {
        VStack {
            // Header
            HeaderView(title: "LDR App",
                       subTitle: "Stay Connected",
                       angle: 15,
                       background: .mint)
            
            // Login Error Message
            Text(login.errorMessage)
                .foregroundStyle(.red)
                .opacity(login.errorMessage.isEmpty ? 0 : 1)
                .offset(y: -20)
            
            // Login Textfields
            loginFields
            
            // Log In Button
            loginButton
            
            Spacer()
            
            // Create Account
            VStack {
                Text("New around here?")
                NavigationLink("Create An Account",
                               destination: RegisterView())
            }
            .padding()
        }
    }
    
    
    
    /// computed variable that contains two TextField for inputing login information
    var loginFields: some View {
        Group {
            TextField("Email Address", text: $login.email)
                .submitLabel(.next)
                .keyboardType(.emailAddress)
                .focused($focusField, equals: .email) // this field is bound to the .email case
                .onSubmit {
                    focusField = .password
                }
            SecureField("Password", text: $login.password)
                .submitLabel(.done)
                .focused($focusField, equals: .password)
                .onSubmit {
                    focusField = nil
                }
        }
        .autocorrectionDisabled()
        .autocapitalization(.none)
        .textFieldStyle(.roundedBorder)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray.opacity(0.5), lineWidth: 2)
        }
        .padding(.horizontal, 40)
        .offset(y: -20)
    }
    
    /// computed variable that contains styled button that will call ViewModel 'login' method login()
    @ViewBuilder
    var loginButton: some View {
        SignInWithAppleButton { request in
            login.appleLoginRequest(request)
        } onCompletion: { result in
            login.appleLoginCompletion(result)
        }
        .signInWithAppleButtonStyle(.black)
        .clipShape(RoundedRectangle(cornerRadius: 25.0))
        .frame(maxHeight: 50)
        .padding(.horizontal, 25)
        .padding(.vertical, 8)
        
        
        GoogleSignInButton {
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
        }
        
        LDRButton(title: "Log In", background: .accentColor) {
            // Attempt to Login
            login.login()
            
        }
        .frame(width: 190, height: 90)
        .offset(y: -20)
    }
}

#Preview {
    LoginView()
}


