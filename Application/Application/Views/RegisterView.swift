//
//  RegisterView.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import SwiftUI

struct RegisterView: View {
    
    @State var name = ""
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        // Header
        HeaderView(title: "Register",
                   subTitle: "Start connecting",
                   angle: -15,
                   background: Color.indigo)
        
        // Register Form
        Form {
            TextField("Full Name", text: $name)
                .autocorrectionDisabled()
            TextField("Email Address", text: $email)
                .autocorrectionDisabled()
                .autocapitalization(.none)
            SecureField("Password", text: $password)
            
            LDRButton(title: "Create Account",
                      background: .green) {
                // Attempt registration
            }
                      
        }
        .offset(y: -50)
        
        
        Spacer()
    }
}

#Preview {
    RegisterView()
}
