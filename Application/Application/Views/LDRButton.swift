//
//  SwiftUIView.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import SwiftUI

struct LDRButton: View {
    let title: String
    let background: Color
    let action: () -> Void
    
    var body: some View {
        Button {
            // Action
            action()
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(background)
                Text(title)
                    .foregroundStyle(.white)
                    .bold()
            }
        }
        .padding()
    }
}

#Preview {
    LDRButton(title: "Value",
              background: .accentColor) {
        // Action
    }
}
