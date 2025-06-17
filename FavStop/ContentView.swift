//
//  ContentView.swift
//  FavStop
//
//  Created by Rodo Nguyen on 16/6/2025.
//

import SwiftUI

struct ContentView: View {
    @State private var currentScreen: Screen = .landing
    
    enum Screen {
        case landing
        case login
        case dashboard
    }
    
    var body: some View {
        Group {
            switch currentScreen {
            case .landing:
                LandingView(onGetStarted: {
                    await navigateToDashboard()
                })
            case .login:
                LoginView()
            case .dashboard:
                DashboardView()
            }
        }
    }
    
    private func navigateToDashboard() async {
        // Here you could add any async setup needed before navigation
        // For example, checking authentication state, loading initial data, etc.
        currentScreen = .dashboard
    }
}

#Preview {
    ContentView()
}
