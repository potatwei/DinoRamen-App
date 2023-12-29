//
//  RegisterView.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import SwiftUI


struct RegisterView: View {
    @Bindable private var register = RegisterViewViewModel()
    @FocusState private var focusField: Field?
    
    enum Field {
        case name, email, password
    }
    
    var body: some View {
        // Header
        HeaderView(title: "Register",
                   subTitle: "Start connecting",
                   angle: -15,
                   background: Color.indigo)
        
        // Register Error Message
        Text(register.errorMessage)
            .foregroundStyle(.red)
            .opacity(register.errorMessage.isEmpty ? 0 : 1)
            .offset(y: -40)

        // Textfields for register
        registerField
        
        // Create Account Button
        createAccountButton
        
        Spacer()
    }
    
    
    
    /// computed variable that contains three TextField for inputing  registeration information
    var registerField: some View {
        Group {
            TextField("Full Name", text: $register.name)
                .submitLabel(.next)
                .focused($focusField, equals: .name) // this field is bound to the .name case
                .onSubmit {
                    focusField = .email
                }
            TextField("Email Address", text: $register.email)
                .submitLabel(.next)
                .keyboardType(.emailAddress)
                .focused($focusField, equals: .email)
                .onSubmit {
                    focusField = .password
                }
            SecureField("Password", text: $register.password)
                .submitLabel(.done)
                .focused($focusField, equals: Field.password)
                .onSubmit {
                    focusField = nil // will dismiss the keyboard
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
        .offset(y: -40)
    }
    
    /// computed variable that contains styled button that will call ViewModel 'register' method register()
    var createAccountButton: some View {
        LDRButton(title: "Create Account", background: .green) {
            // Attempt registration
            register.register()
        }
        .frame(width: 190, height: 90)
        .offset(y: -40)
    }
}

#Preview {
    RegisterView()
}
