//
//  HeaderView.swift
//  Application
//
//  Created by Shihang Wei on 12/26/23.
//

import SwiftUI

struct HeaderView: View {
    let title: String
    let subTitle: String
    let angle: Double
    let background: Color
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 0)
                .foregroundStyle(background)
                .rotationEffect(Angle(degrees: angle))
            VStack {
                Text(title)
                    .foregroundStyle(.white)
                    .bold()
                    .font(.system(size: 50))
                Text(subTitle)
                    .foregroundStyle(.white)
                    .font(.system(size: 25))
            }
            .padding(.top, 90)
        }
        .frame(width: 1000, height: 350)
        .offset(y: -150)
    }
}

#Preview {
    HeaderView(title: "Title", subTitle: "Subtitle", angle: 15, background: .mint)
}
