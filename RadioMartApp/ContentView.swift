//
//  ContentView.swift
//  RadioMartApp
//
//  Created by XMaster on 09.09.2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        ZStack {
            LaunchScreenView()
            GeneralTabView()
                .zIndex(0.9)
        }
    }
}

#Preview {
    ContentView()
}
