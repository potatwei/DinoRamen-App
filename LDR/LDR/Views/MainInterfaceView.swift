//
//  ContentView.swift
//  Application
//
//  Created by Shihang Wei on 12/25/23
//

import SwiftUI
import WidgetKit

struct MainInterfaceView: View {
    @ObservedObject var interface = MainInterfaceViewModel()
    @State var selection = 0
    
    @StateObject var currentUserInfo = UserEnvironment()
    @StateObject var status = UserStatusEnvironment()
    @StateObject var signInStatus = SignInEnvironment()
    
    @State var show = false
    
    var body: some View {
        if interface.isSignIn {
            ZStack {
                if signInStatus.ifUserDocumentExist == false {
                    SetUserNameView(tabSelection: $selection)
                        .transition(.slide)
                        .environmentObject(signInStatus)
                        .zIndex(1)
                }
                
                TabView(selection: $selection) {
                    UserEditView(tabSelection: $selection)
                        .tabItem { Label("Edit", systemImage: "figure") }
                        .tag(1)
                        .environmentObject(status)
                    
                    OthersDisplayView(tabSelection: $selection)
                        .tabItem { Label("Home", systemImage: "house") }
                        .tag(0)
                        .environmentObject(status)
                    
                    ProfileView(tabSelection: $selection)
                        .tabItem { Label("Profile", systemImage: "person.circle") }
                        .tag(2)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                .animation(.easeOut(duration: 0.1), value: selection)
                .environmentObject(currentUserInfo)
                .zIndex(0)
            }
        } else {
            NavigationStack {
                LoginView()
                    .environmentObject(signInStatus)
                
            }
            .transition(.slide)
        }
    }
}

#Preview {
    MainInterfaceView()
}
