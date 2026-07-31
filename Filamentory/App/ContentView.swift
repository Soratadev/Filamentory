//
//  ContentView.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 10/07/2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    var body: some View {
        TabView {
            StorageView()
                .tabItem {
                    Label("Storage", systemImage: "shippingbox")
                }
            ShoppingListView()
                .tabItem {
                    Label("Shopping List", systemImage: "cart")
                }
            StatisticsView()
                .tabItem {
                    Label("Statistics", systemImage: "chart.bar.fill")
                }
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: [Filament.self, UsageEvent.self, ShoppingListItem.self], inMemory: true)
}
