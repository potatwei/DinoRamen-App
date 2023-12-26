//
//  ContentView.swift
//  Application
//
//  Created by Shihang Wei on 12/25/23.
//

import SwiftUI

struct MainInterfaceView: View {
    
    var interface: MainInterfaceViewModel
    
    var body: some View {
        VStack {
            ZStack {
                Circle()
                    .frame(maxWidth: 275)
                    .foregroundStyle(.mint)
                AsyncImage(url: interface.emojiDisplaying) { emoji in
                    emoji
                } placeholder: {}
            }.padding()
            
            ZStack {
                RoundedRectangle(cornerRadius: 5)
                    .frame(maxWidth: 280,maxHeight: 60)
                    .foregroundStyle(.bar)
                HStack {
                    Button{
                        interface.reacted("")
                    } label: {
                        /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
                    }
                }
            }
            
            

        }
    }
}

#Preview {
    MainInterfaceView(interface: MainInterfaceViewModel())
}
