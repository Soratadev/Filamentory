//
//  FilamentRow.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 15/07/2026.
//
import SwiftUI

struct FilamentRow: View {
    @Environment(\.locale) private var locale
    @Bindable var filament: Filament
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text("\(filament.type) - \(filament.nameColor)")
                    .font(.headline)
            }
            
            HStack {
                Text(filament.brand)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                Spacer()
                Circle()
                    .fill(filament.color)
                    .frame(width: 25, height: 25)
                    .overlay(
                        Circle()
                            .stroke(Color.secondary.opacity(0.3),
                                    lineWidth: 1)
                    )
            }
            
            HStack {
                Text("Remaining: \(filament.remaining) g")
                Spacer()
                Text(filament.status.localizedName(locale: locale))
                    .font(.caption)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(filament.status == .open
                                ? Color.orange.opacity(0.2)
                                : Color.green.opacity(0.2))
                    .clipShape(Capsule())
            }
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 12)
        .overlay(alignment: .topTrailing) {
            if filament.isFavorite {
                Image(systemName: "star.fill")
                    .foregroundStyle(.yellow)
                    .padding(6)
                    .accessibilityLabel("Favorite")
            }
        }
        .animation(.spring(), value: filament.isFavorite)
    }
}

#Preview {
    FilamentRow(
        filament: Filament(
            status: .open,
            brand: "Bambu Lab",
            type: "PLA",
            color: .white,
            nameColor: "Blanco",
            weight: 1000,
            remaining: 0,
            spoolsInReserve: 3,
            price: 24.99,
            isFavorite: true
        )
    )
}
