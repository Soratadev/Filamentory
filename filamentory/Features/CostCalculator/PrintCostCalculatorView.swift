//
//  PrintCostCalculatorView.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 03/08/2026.
//
import SwiftUI
import SwiftData

struct PrintCostCalculatorView: View {
    @Environment(\.dismiss) private var dismiss
    @Query private var filaments: [Filament]
    @AppStorage("preferredCurrencyCode") private var preferredCurrencyCode: String =
        Locale.current.currency?.identifier ?? "EUR"
    
    @State private var calculator = PrintCostCalculator()
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Filament")) {
                    Picker("Filament", selection: $calculator.selectedFilament) {
                        Text("Select a filament").tag(Filament?.none)
                        ForEach(filaments) { filament in
                            Text("\(filament.type) \(filament.nameColor) - \(filament.brand)")
                                .tag(Filament?.some(filament))
                        }
                    }
                    if let filament = calculator.selectedFilament {
                        LabeledContent("Spool price", value: filament.price.formatted(.currency(code: preferredCurrencyCode)))
                        LabeledContent("Spool weight", value: "\(filament.weight) g")
                    }
                    
                    HStack {
                        Text("Grams used")
                        Spacer()
                        TextField("", value: $calculator.gramUsed, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                        Text("g")
                    }
                }
                
                Section("Print time & electricity") {
                    HStack {
                        Text("Print hours")
                        Spacer()
                        TextField("", value: $calculator.printHours, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                        Text("h")
                    }
                    HStack {
                        Text("Wattage")
                        Spacer()
                        TextField("", value: $calculator.wattage, format: .number)
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                        Text("W")
                    }
                    HStack {
                        Text("Cost per kWh")
                        Spacer()
                        TextField("", value: $calculator.pricePerKWh, format: .currency(code: preferredCurrencyCode))
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                }
                
                Section("Total cost") {
                    LabeledContent("Filament cost", value: calculator.filamentCost.formatted(.currency(code: preferredCurrencyCode)))
                    LabeledContent("Electricity cost", value: calculator.electricityCost.formatted(.currency(code: preferredCurrencyCode)))
                    LabeledContent("Total cost") {
                        Text(calculator.totalCost.formatted(.currency(code: preferredCurrencyCode)))
                            .fontWeight(.semibold)
                    }
                }
                
                Section {
                    ShareLink(item: resultSummary) {
                        Label("Share result", systemImage: "square.and.arrow.up")
                    }
                }
            }
            .navigationTitle("Print cost calculator")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                    .accessibilityLabel("Done")
                }
            }
        }
    }
    
    private var resultSummary: String {
        var lines = ["Print Cost Calculator"]
        if let filament = calculator.selectedFilament {
            lines.append("Filament: \(filament.type) \(filament.nameColor) - \(filament.brand)")
        }
        lines.append("Grams used: \(calculator.gramUsed) g")
        lines.append("Print time: \(calculator.printHours) h")
        lines.append("Filament cost: \(calculator.filamentCost.formatted(.currency(code: preferredCurrencyCode)))")
        lines.append("Electricity cost: \(calculator.electricityCost.formatted(.currency(code: preferredCurrencyCode)))")
        lines.append("Total cost: \(calculator.totalCost.formatted(.currency(code: preferredCurrencyCode)))")
        return lines.joined(separator: "\n")
    }
}

#Preview {
    PrintCostCalculatorView()
        .modelContainer(for: Filament.self, inMemory: true)
}
