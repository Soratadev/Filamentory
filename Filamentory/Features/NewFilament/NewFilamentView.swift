//
//  NewFilamentView.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 14/07/2026.
//
import SwiftUI

struct NewFilamentView: View {
    @Environment(\.dismiss) private var dismiss
    let onAdd: (Filament) -> Void

    @State private var draftFilament = Filament (
        status: .close,
        brand: "",
        type: "PLA",
        color: .white,
        nameColor: "",
        weight: 1000,
        remaining: 1000,
        amount: 1,
        price: 19.99
    )
    
    var body: some View {
        NavigationStack {
            Form {
                FilamentFormFields(filament: draftFilament)
            }
            .navigationTitle(Text("New Filament"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        onAdd(draftFilament)
                        dismiss()
                    }
                    .disabled(draftFilament.brand.isEmpty)
                }
            }
        }
    }
}

#Preview {
    NewFilamentView {
        filament in print(filament)
    }
}
