//
//  FilamentFormFields.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 15/07/2026.
//
import SwiftUI
import SwiftData

struct FilamentFormFields: View {
    @Bindable var filament: Filament
    @Query private var allFilaments: [Filament]
    @AppStorage("preferredCurrencyCode") private var preferredCurrencyCode: String =
    Locale.current.currency?.identifier ?? "EUR"
    
    private enum Field: Hashable {
        case brand
        case nameColor
    }
    @FocusState private var focusedField: Field?
    
    private let materials = ["PLA", "PETG", "ABS", "ASA", "TPU", "PVA", "PA", "PP", "PC", "Nylon", "Other"]
    private let weights = [500, 750, 1000, 2000]
    
    var body: some View {
        Section ("Basic Information") {
            HStack {
                Text("Brand")
                Spacer()
                TextField("", text: $filament.brand)
                    .multilineTextAlignment(.trailing)
                    .focused($focusedField, equals: .brand)
            }
            if focusedField == .brand, !brandSuggestions.isEmpty {
                suggestionRow(brandSuggestions) { filament.brand = $0 }
            }
            
            Picker("Type", selection: $filament.type) {
                ForEach(materials, id: \.self) { type in
                    Text(type)
                }
            }
            
            HStack {
                Text("Color name")
                Spacer()
                TextField("", text: $filament.nameColor)
                    .multilineTextAlignment(.trailing)
                    .focused($focusedField, equals: .nameColor)
            }
            if focusedField == .nameColor, !colorSuggestions.isEmpty {
                suggestionRow(colorSuggestions) { filament.nameColor = $0 }
            }
            
            ColorPicker("Color", selection: $filament.color)
            HStack {
                Text("Price")
                Spacer()
                TextField("", value: $filament.price, format: .currency(code: preferredCurrencyCode))
                    .multilineTextAlignment(.trailing)
                    .keyboardType(.decimalPad)
            }
            Picker("Weight", selection: $filament.weight) {
                ForEach(weights, id: \.self) { w in
                    Text("\(w) g").tag(w)
                }
            }
            .onChange(of: filament.weight) { oldValue, newValue in
                if filament.remaining > newValue {
                    filament.remaining = newValue
                }
            }
        }
        
        Section ("Storage") {
            Stepper("Remaining weight: \(filament.remaining) g", value: $filament.remaining, in: 0...filament.weight, step: 10)
            
            Stepper("Spools in reserve: \(filament.spoolsInReserve)", value: $filament.spoolsInReserve, in: 0...100, step: 1)
            
            Picker("Status", selection: $filament.status) {
                Text("Open").tag(StatusFilament.open)
                Text("Sealed").tag(StatusFilament.close)
            }.pickerStyle(.segmented)
            
        }
    }
    
    private func suggestionRow(_ suggestions: [String], onSelect: @escaping (String) -> Void) -> some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(suggestions, id: \.self) { suggestion in
                    Button(suggestion) {
                        onSelect(suggestion)
                        focusedField = nil
                    }
                        .buttonStyle(.borderedProminent)
                        .padding(.vertical, 5)
                        .padding(.horizontal, 10)
                }
            }
        }
    }
    
    private var brandSuggestions: [String] {
        guard !filament.brand.isEmpty else { return [] }
        return Set(allFilaments.map(\.brand))
            .filter { $0.localizedCaseInsensitiveContains(filament.brand) && $0 != filament.brand }
            .sorted()
            .prefix(3)
            .map { $0 }
    }
    
    private var colorSuggestions: [String] {
        guard !filament.nameColor.isEmpty else { return [] }
        return Set(allFilaments.map(\.nameColor))
            .filter { $0.localizedCaseInsensitiveContains(filament.nameColor) && $0 != filament.nameColor }
            .sorted()
            .prefix(3)
            .map { $0 }
    }
}

#Preview {
    Form {
        FilamentFormFields(
            filament: Filament(
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
        )
    }
    .modelContainer(for: Filament.self, inMemory: true)
}
