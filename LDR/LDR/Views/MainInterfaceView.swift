//
//  ContentView.swift
//  Application
//
//  Created by Shihang Wei on 12/25/23.
//

import SwiftUI

struct MainInterfaceView: View {
    //var interface: MainInterfaceViewModel
    @StateObject var interface = MainInterfaceViewModel()
    
    var body: some View {
        //Text("\(interface.currentUserId)")
        if interface.isSignIn && !(interface.currentUserId.isEmpty){
            TabView {
                OthersDisplayView(userId: interface.currentUserId)
                    .tabItem { Label("Home", systemImage: "house") }
                
                ProfileView()
                    .tabItem { Label("Profile", systemImage: "person.circle") }
                    .navigationTitle("Profile")
            }
        } else {
            NavigationStack {
                LoginView()
            }
        }
    }
}

#Preview {
    MainInterfaceView()
}
