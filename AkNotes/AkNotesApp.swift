//
//  AkNotesApp.swift
//  AkNotes
//
//  Created by 徐 on 2025/7/19.
//

import SwiftUI

@main
struct AkNotesApp: App {
    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }
}

struct MainView: View {
    @State private var isActive = false
    
    var body: some View {
        ZStack {
            if isActive {
                ContentView()
                    .transition(.asymmetric(
                        insertion: .move(edge: .trailing).combined(with: .opacity),
                        removal: .move(edge: .leading).combined(with: .opacity)
                    ))
            } else {
                SplashView(isActive: $isActive)
                    .transition(.scale.combined(with: .opacity))
            }
        }
    }
}
