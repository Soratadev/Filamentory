//
//  StatisticsView.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 30/07/2026.
//
import SwiftUI
import SwiftData
import Charts

struct StatisticsView: View {
    @Query private var filaments: [Filament]
    @Query private var usageEvents: [UsageEvent]
    
    @AppStorage("lowStockThreshold") private var lowStockThreshold: Double = 0.1
    @AppStorage("preferredCurrencyCode") private var preferredCurrencyCode: String =
    Locale.current.currency?.identifier ?? "EUR"
    
    var body: some View {
        NavigationStack {
            List {
                Section("Inventory Value") {
                    LabeledContent("Total Value") {
                        Text(totalInventoryValue, format: .currency(code: preferredCurrencyCode))
                    }
                }
                
                if !lowStockFilaments.isEmpty {
                    Section("Low Stock") {
                        ForEach(lowStockFilaments) { filament in
                            LabeledContent("\(filament.type) \(filament.nameColor) - \(filament.brand)") {
                                Text("\(filament.remaining) g")
                                    .foregroundStyle(.red)
                            }
                        }
                    }
                }
                
                if !materialBreakdown.isEmpty {
                    Section("Material Breakdown") {
                        Chart(materialBreakdown) { item in
                            SectorMark(
                                angle: .value("Weight", item.totalWeight),
                                innerRadius: .ratio(0.5),
                                angularInset: 1.5
                            )
                            .foregroundStyle(by: .value("Material", item.type))
                            .cornerRadius(4)
                        }
                        .frame(height: 200)
                    }
                }
                
                if !monthlyUsage.isEmpty {
                    Section("Monthly Usage") {
                        Chart(monthlyUsage) { item in
                            BarMark(
                                x: .value("Month", item.month, unit: .month),
                                y: .value("Used (g)", item.totalUsed)
                            )
                        }
                        .frame(height: 200)
                    }
                }

                if let mostUsedColor {
                    Section("Most Used Color") {
                        LabeledContent(mostUsedColor.colorName) {
                            HStack(spacing: 8) {
                                Text("\(mostUsedColor.totalUsed) g")
                                Circle()
                                    .fill(mostUsedColorSwatch)
                                    .frame(width: 20, height: 20)
                                    .overlay(Circle().stroke(Color.secondary.opacity(0.3), lineWidth: 1))
                            }
                        }
                    }
                }
            }
            .navigationTitle("Statistics")
        }
    }
    
    private var totalInventoryValue: Double {
        filaments.reduce(0) { total, filament in
            total + (filament.price * Double(filament.amount))
        }
    }
    
    private func stockRatio(_ filament: Filament) -> Double {
        Double(filament.remaining) / Double(filament.weight)
    }
    
    private var lowStockFilaments: [Filament] {
        filaments
            .filter { stockRatio($0) <= lowStockThreshold}
            .sorted { stockRatio($0) < stockRatio($1) }
    }
    
    private var materialBreakdown: [MaterialBreakdown] {
        let grouped = Dictionary(grouping: filaments, by: \.type)
        return grouped.map { type, filamentsOfType in
            MaterialBreakdown(
                type: type,
                totalWeight: filamentsOfType.reduce(0) { $0 + $1.remaining }
            )
        }
        .sorted { $0.totalWeight > $1.totalWeight }
    }
    
    private var monthlyUsage: [MonthlyUsage] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: usageEvents) { event in
            calendar.dateInterval(of: .month, for: event.date)?.start ?? event.date
        }
        return grouped
            .map { month, events in
                MonthlyUsage(month: month, totalUsed: events.reduce(0) { $0 + $1.amountUsed })
            }
            .sorted { $0.month < $1.month }
    }
    
    private var mostUsedColor: ColorUsage? {
        let grouped = Dictionary(grouping: usageEvents) { $0.filament?.nameColor }
        return grouped
            .compactMap { colorName, events -> ColorUsage? in
                guard let colorName else { return nil }
                let total = events.reduce(0) { $0 + $1.amountUsed }
                return ColorUsage(colorName: colorName, totalUsed: total)
            }
            .max { $0.totalUsed < $1.totalUsed }
    }
    
    private var mostUsedColorSwatch: Color {
        filaments.first { $0.nameColor == mostUsedColor?.colorName }?.color ?? .gray
    }
}

#Preview {
    StatisticsView()
        .modelContainer(for: [Filament.self, UsageEvent.self], inMemory: true)
}
