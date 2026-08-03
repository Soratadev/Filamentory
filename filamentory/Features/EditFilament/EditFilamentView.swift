//
//  EditFilamentView.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 15/07/2026.
//
import SwiftUI
import SwiftData

struct EditFilamentView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.modelContext) private var modelContext
    @Bindable var filament: Filament
    @State private var initialRemaining: Int = 0
    @State private var showEmptyAlert: Bool = false
    @State private var showNewSpoolAlert: Bool = false
    
    var body: some View {
        NavigationStack {
            Form {
                FilamentFormFields(filament: filament)
            }
            .navigationTitle("Edit Filament")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        logUsageIfNeeded()
                        if initialRemaining > 0 && filament.remaining == 0 {
                            if filament.spoolsInReserve > 0 {
                                openNextSpool()
                            } else {
                                showEmptyAlert = true
                            }
                        } else {
                            dismiss()
                        }
                    }
                }
            }
        }
        .onAppear {
            initialRemaining = filament.remaining
        }
        .alert("New Spool Opened", isPresented: $showNewSpoolAlert) {
            Button("OK") { dismiss() }
        } message: {
            Text("This spool ran out. We opened a new one from your reserve. \(filament.spoolsInReserve) left in reserve")
        }
        .alert("Filament Empty", isPresented: $showEmptyAlert) {
            Button("Add to Shopping List") {
                addToShoppingList()
                dismiss()
            }
            Button("Not now", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("This filament is out. Add it to your shopping list?")
        }
    }
    
    private func logUsageIfNeeded() {
        let amountUsed = initialRemaining - filament.remaining
        guard amountUsed > 0 else { return }
        
        let event = UsageEvent(date: .now, amountUsed: amountUsed, filament: filament)
        modelContext.insert(event)
        
        do {
            try modelContext.save()
        } catch {
            print("❌ Error saving usage event: \(error)")
        }
    }
    
    private func addToShoppingList() {
        let name = "\(filament.type) \(filament.nameColor) - \(filament.brand)"
        let item = ShoppingListItem(name: name)
        modelContext.insert(item)
        
        do {
            try modelContext.save()
        } catch {
            print("❌ Error saving shopping list item: \(error)")
        }
    }
    
    private func openNextSpool() {
        filament.spoolsInReserve -= 1
        filament.remaining = filament.weight
        do {
            try modelContext.save()
        } catch {
            print("❌ Error opening next spool: \(error)")
        }
        showNewSpoolAlert = true
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Filament.self, UsageEvent.self, configurations: config)
    
    let filament = Filament(
        status: .open,
        brand: "Bambu Lab",
        type: "PLA",
        color: .white,
        nameColor: "White",
        weight: 1000,
        remaining: 850,
        spoolsInReserve: 3,
        price: 24.99
    )
    container.mainContext.insert(filament)
    
    return EditFilamentView(filament: filament)
        .modelContainer(container)
}
