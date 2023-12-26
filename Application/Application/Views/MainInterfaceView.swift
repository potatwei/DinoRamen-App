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
            NavigationStack {
                LoginView()
            }
        }
    }
}

#Preview {
    MainInterfaceView(interface: MainInterfaceViewModel())
}
