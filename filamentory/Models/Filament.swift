//
//  Filament.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 10/07/2026.
//
import Foundation
import SwiftUI
import SwiftData

enum StatusFilament: String, Codable {
    case open
    case close
    
    func localizedName(locale: Locale) -> String {
            switch self {
            case .open: return String(localized: "In use", locale: locale)
            case .close: return String(localized: "Sealed", locale: locale)
        }
    }
}

@Model
final class Filament {
    var id = UUID()
    var status: StatusFilament
    var brand: String
    var type: String
    
    // Almacenar componentes del color (compatible con SwiftData)
    var colorRed: Double
    var colorGreen: Double
    var colorBlue: Double
    var colorOpacity: Double
    
    var nameColor: String
    var weight: Int
    var remaining: Int
    var spoolsInReserve: Int
    var price: Double
    var isFavorite: Bool
    var createdAt: Date
    
    @Relationship(deleteRule: .nullify, inverse: \UsageEvent.filament)
    var usageEvents: [UsageEvent] = []
    
    // Propiedad computada para trabajar con Color de SwiftUI
    var color: Color {
        get {
            Color(red: colorRed, green: colorGreen, blue: colorBlue, opacity: colorOpacity)
        }
        set {
            let components = newValue.storedComponents
                colorRed = components.red
                colorGreen = components.green
                colorBlue = components.blue
                colorOpacity = components.opacity
        }
    }
    
    init(
        id: UUID? = nil,
        status: StatusFilament,
        brand: String,
        type: String,
        color: Color,
        nameColor: String,
        weight: Int,
        remaining: Int,
        spoolsInReserve: Int,
        price: Double,
        isFavorite: Bool = false,
        createdAt: Date = .now
    ) {
        self.id = id ?? UUID()
        self.status = status
        self.brand = brand
        self.type = type
        self.nameColor = nameColor
        self.weight = weight
        self.remaining = remaining
        self.spoolsInReserve = spoolsInReserve
        self.price = price
        self.isFavorite = isFavorite
        self.createdAt = createdAt
        
        // Inicializar componentes del color
        self.colorRed = 1.0
        self.colorGreen = 1.0
        self.colorBlue = 1.0
        self.colorOpacity = 1.0
        
        // Establecer el color usando la propiedad computada
        self.color = color
    }
}
