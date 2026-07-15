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
    @Bindable var filament: Filament
    
    let materials = ["PLA", "PETG", "ABS", "ASA", "TPU", "PVA", "PA", "PP", "PC", "Nylon", "Other"]
    let weights = [500, 750, 1000, 2000, 3000]
    
    var body: some View {
        NavigationStack {
            Form {
                Section ("Basic Information") {
                    HStack {
                        Text("Brand")
                        Spacer()
                        TextField("Bambu Lab", text: $filament.brand)
                            .multilineTextAlignment(.trailing)
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
                    }
                    ColorPicker("Color", selection: $filament.color)
                    HStack {
                        Text("Price")
                        Spacer()
                        TextField("", value: $filament.price, format: .currency(code: Locale.current.currency?.identifier ?? "EUR"))
                            .multilineTextAlignment(.trailing)
                            .keyboardType(.decimalPad)
                    }
                }
                
                Section ("Storage") {
                    Picker("Weight", selection: $filament.weight) {
                        ForEach(weights, id: \.self) { w in
                            Text("\(w) g").tag(w)
                        }
                    }
                    .onChange(of: filament.weight) { oldValue, newValue in
                        // Ajustar remaining si es mayor que el nuevo peso
                        if filament.remaining > newValue {
                            filament.remaining = newValue
                        }
                    }
                    
                    Stepper("Remaining weight: \(filament.remaining) g", value: $filament.remaining, in: 0...filament.weight, step: 10)
                    
                    Stepper("Amount: \(filament.amount)", value: $filament.amount, in: 1...100, step: 1)
                    
                    Picker("Status", selection: $filament.status) {
                        Text("Open").tag(StatusFilament.open)
                        Text("Sealed").tag(StatusFilament.close)
                    }.pickerStyle(.segmented)
                }
            }
            .navigationTitle("Edit Filament")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Filament.self, configurations: config)
    
    let filament = Filament(
        status: .open,
        brand: "Bambu Lab",
        type: "PLA",
        color: .white,
        nameColor: "White",
        weight: 1000,
        remaining: 850,
        amount: 3,
        price: 24.99
    )
    container.mainContext.insert(filament)
    
    return EditFilamentView(filament: filament)
        .modelContainer(container)
}
