//
//  RegisterView.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import SwiftUI

struct RegisterView: View {
    @Bindable private var register = RegisterViewViewModel()
    
    var body: some View {
        // Header
        HeaderView(title: "Register",
                   subTitle: "Start connecting",
                   angle: -15,
                   background: Color.indigo)
        
        // Register Form
        Form {
            TextField("Full Name", text: $register.name)
                .autocorrectionDisabled()
            TextField("Email Address", text: $register.email)
                .autocorrectionDisabled()
                .autocapitalization(.none)
            SecureField("Password", text: $register.password)
            
            LDRButton(title: "Create Account",
                      background: .green) {
                // Attempt registration
                register.register()
            }
                      
        }
        .offset(y: -50)
        
        
        Spacer()
    }
}

#Preview {
    RegisterView()
}
