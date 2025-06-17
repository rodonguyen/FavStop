//
//  FavStopApp.swift
//  FavStop
//
//  Created by Rodo Nguyen on 16/6/2025.
//

import SwiftUI

@main
struct FavStopApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(.none) // Respects system dark/light mode setting
                // Alternative options:
                // .preferredColorScheme(.dark)  // Force dark mode
                // .preferredColorScheme(.light) // Force light mode
        }
    }
}
