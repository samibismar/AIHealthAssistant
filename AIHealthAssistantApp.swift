//
//  AIHealthAssistantApp.swift
//  AIHealthAssistant
//
//  Created by Sami Bismar on 5/28/25.
//

import SwiftUI

@main
struct AIHealthAssistantApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(LocationManager())
        }
    }
}
