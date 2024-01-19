//
//  ContentView.swift
//  Application
//
//  Created by Shihang Wei on 12/25/23.
//

import SwiftUI
import WidgetKit

struct MainInterfaceView: View {
    //var interface: MainInterfaceViewModel
    @ObservedObject var interface = MainInterfaceViewModel()
    @State var selection = 0
    
    @StateObject var currentUserInfo = UserEnvironment()
    @StateObject var status = UserStatusEnvironment()
    
    var body: some View {
        //Text("\(interface.currentUserId)")
        if interface.isSignIn {
            Group {
                if interface.ifExist {
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
                    .transition(.slide)
                    .environmentObject(currentUserInfo)
                } else {
                    // Let user input their user name
                    SetUserNameView(ifUserExist: $interface.ifExist)
                }
            }
            .transition(.slide)
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
