//
//  DetailsFilamentView.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 10/07/2026.
//
import SwiftUI

struct DetailsFilamentView: View {
    @Environment(\.locale) private var locale
    let filament: Filament
    @State private var showEditSheet = false
    @AppStorage("preferredCurrencyCode") private var preferredCurrencyCode: String =
        Locale.current.currency?.identifier ?? "EUR"
    
    var body: some View {
        Form {
            Section("Basic Information") {
                LabeledContent("Brand", value: filament.brand)
                LabeledContent("Type", value: filament.type)
                LabeledContent {
                    HStack(spacing: 8) {
                        Text(filament.nameColor)
                        Circle()
                            .fill(filament.color)
                            .frame(width: 25, height: 25)
                            .overlay(
                                Circle().stroke(Color.secondary.opacity(0.3), lineWidth: 1)
                            )
                    }
                } label: {
                    Text("Color")
                }
                LabeledContent("Weight", value: "\(filament.weight) g")
                LabeledContent("Price", value: filament.price.formatted(.currency(code: preferredCurrencyCode)))
            }
            
            Section("Storage") {
                LabeledContent("Stock", value: "\(filament.amount)")
                
                LabeledContent("Remaining weight", value: "\(filament.remaining) g")
                LabeledContent("Status", value: "\(filament.status.localizedName(locale: locale))")
                LabeledContent("Added at", value: filament.createdAt.formatted(.dateTime.day().month().year()))
            }
        }
        .navigationTitle(filament.type)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    showEditSheet = true
                } label: {
                    Text("Edit")
                }
            }
        }
        .sheet(isPresented: $showEditSheet) {
            EditFilamentView(filament: filament)
        }
    }
}

#Preview {
    DetailsFilamentView(
        filament: Filament(
            status: .open,
            brand: "Bambu Lab",
            type: "PLA",
            color: .white,
            nameColor: "Blanco",
            weight: 1000,
            remaining: 850,
            amount: 3,
            price: 24.99
        )
    )
}
