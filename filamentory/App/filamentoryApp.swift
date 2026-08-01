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
    @AppStorage("appTheme") private var appTheme: AppTheme = .system
    @AppStorage("appLanguage") private var appLanguage: AppLanguage =
        Locale.current.language.languageCode?.identifier == "es" ? .spanish : .english
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .preferredColorScheme(appTheme.colorScheme)
                .environment(\.locale, appLanguage.locale)
        }
        .modelContainer(for: [Filament.self, UsageEvent.self, ShoppingListItem.self])
    }
}
