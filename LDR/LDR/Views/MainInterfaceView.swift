//
//  ContentView.swift
//  Application
//
//  Created by Shihang Wei on 12/25/23.
//

import SwiftUI

struct MainInterfaceView: View {
    //var interface: MainInterfaceViewModel
    @State private var interface = MainInterfaceViewModel()
    
    var body: some View {
        if interface.isSignIn, !interface.currentUserId.isEmpty{
            OthersDisplayView()
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
