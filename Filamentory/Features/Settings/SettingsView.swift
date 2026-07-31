//
//  SettingsView.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 30/07/2026.
//
import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.locale) private var locale
    @Query private var filaments: [Filament]
    
    @AppStorage("appTheme") private var appTheme: AppTheme = .system
    @AppStorage("appLanguage") private var appLanguage: AppLanguage = .english
    @AppStorage("lowStockThreshold") private var lowStockThreshold: Double = 0.1
    @AppStorage("preferredCurrencyCode") private var preferredCurrencyCode: String =
    Locale.current.currency?.identifier ?? "EUR"
    
    @State private var showDeleteConfirmation = false
    
    private let currencyOptions = ["EUR", "USD", "GBP"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Appearance") {
                    Picker("Theme", selection: $appTheme) {
                        ForEach(AppTheme.allCases) { theme in
                            Text(theme.localizedName(locale: locale)).tag(theme)
                        }
                    }
                }
                
                Section("Language") {
                    Picker("Language", selection: $appLanguage) {
                        ForEach(AppLanguage.allCases) { language in
                            Text(language.localizedName(locale: locale)).tag(language)
                        }
                    }
                }
                
                Section("Inventory") {
                    VStack(alignment: .leading) {
                        Text("Low Stock Alert: \(Int(lowStockThreshold * 100))%")
                        Slider(value: $lowStockThreshold, in: 0.05...0.5, step: 0.05)
                    }
                    
                    Picker("Currency", selection: $preferredCurrencyCode) {
                        ForEach(currencyOptions, id: \.self) { code in
                            Text(code).tag(code)
                        }
                    }
                }
                
                Section("About") {
                    LabeledContent("Version", value: appVersion)
                }
                
                Section {
                    Button("Delete All Inventory", role: .destructive) {
                        showDeleteConfirmation = true
                    }
                }
            }
            .navigationTitle("Settings")
            .alert("Delete All Inventory?", isPresented: $showDeleteConfirmation) {
                Button("Delete", role: .destructive) {
                    deleteAllFilaments()
                }
                Button("Cancel", role: .cancel) {}
            } message: {
                Text("This will permanently delete all \(filaments.count) filaments. This cannot be undone.")
            }
        }
    }
    
    private var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "—"
    }
    
    private func deleteAllFilaments() {
        for filament in filaments {
            modelContext.delete(filament)
        }
        do {
            try modelContext.save()
        } catch {
            print("❌ Error deleting all filaments: \(error)")
        }
    }
}

#Preview {
    SettingsView()
        .modelContainer(for: Filament.self, inMemory: true)
}

