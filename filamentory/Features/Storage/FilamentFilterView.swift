//
//  FilamentFilterView.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 29/07/2026.
//
import SwiftUI

struct FilamentFilterView: View {
    @Binding var filter: FilamentFilter
    let allFilaments: [Filament]
    @Environment(\.dismiss) private var dismiss

    private var distinctTypes: [String] {
        Set(allFilaments.map(\.type)).sorted()
    }
    private var distinctBrands: [String] {
        Set(allFilaments.map(\.brand)).sorted()
    }
    private var distinctColors: [String] {
        Set(allFilaments.map(\.nameColor)).sorted()
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Material") {
                    Picker("Type", selection: $filter.selectedType) {
                        Text("All").tag(String?.none)
                        ForEach(distinctTypes, id: \.self) { type in
                            Text(type).tag(String?.some(type))
                        }
                    }
                }
                Section("Brand") {
                    Picker("Brand", selection: $filter.selectedBrand) {
                        Text("All").tag(String?.none)
                        ForEach(distinctBrands, id: \.self) { brand in
                            Text(brand).tag(String?.some(brand))
                        }
                    }
                }
                Section("Color") {
                    Picker("Color", selection: $filter.selectedColorName) {
                        Text("All").tag(String?.none)
                        ForEach(distinctColors, id: \.self) { color in
                            Text(color).tag(String?.some(color))
                        }
                    }
                }
                Section("Date Added") {
                    Picker("Date Added", selection: $filter.dateFilter) {
                        ForEach(DateFilter.allCases) { option in
                            Text(option.localizedName).tag(option)
                        }
                    }
                }
                if filter.isActive {
                    Section {
                        Button("Clear Filters", role: .destructive) {
                            filter.clearStructuredFilters()
                        }
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var filter = FilamentFilter()
    FilamentFilterView(
        filter: $filter,
        allFilaments: [
            Filament(status: .open, brand: "Bambu Lab", type: "PLA", color: .white, nameColor: "White", weight: 1000, remaining: 850, amount: 3, price: 24.99),
            Filament(status: .close, brand: "Prusament", type: "PETG", color: .black, nameColor: "Black", weight: 1000, remaining: 1000, amount: 1, price: 29.99)
        ]
    )
}
