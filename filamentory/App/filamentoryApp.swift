//
//  filamentoryApp.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 10/07/2026.
//

import SwiftUI
import SwiftData

@main
struct filamentoryApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: Filament.self)
    }
}
