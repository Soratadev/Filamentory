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
    
    var localizedName: String {
            switch self {
            case .open: return String(localized: "In use")
            case .close: return String(localized: "Sealed")
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
    var amount: Int
    var price: Double
    
    // Propiedad computada para trabajar con Color de SwiftUI
    var color: Color {
        get {
            Color(red: colorRed, green: colorGreen, blue: colorBlue, opacity: colorOpacity)
        }
        set {
            #if canImport(UIKit)
            let uiColor = UIColor(newValue)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            
            uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            
            colorRed = Double(red)
            colorGreen = Double(green)
            colorBlue = Double(blue)
            colorOpacity = Double(alpha)
            #elseif canImport(AppKit)
            let nsColor = NSColor(newValue)
            var red: CGFloat = 0
            var green: CGFloat = 0
            var blue: CGFloat = 0
            var alpha: CGFloat = 0
            
            nsColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
            
            colorRed = Double(red)
            colorGreen = Double(green)
            colorBlue = Double(blue)
            colorOpacity = Double(alpha)
            #endif
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
        amount: Int,
        price: Double
    ) {
        self.id = id ?? UUID()
        self.status = status
        self.brand = brand
        self.type = type
        self.nameColor = nameColor
        self.weight = weight
        self.remaining = remaining
        self.amount = amount
        self.price = price
        
        // Inicializar componentes del color
        self.colorRed = 1.0
        self.colorGreen = 1.0
        self.colorBlue = 1.0
        self.colorOpacity = 1.0
        
        // Establecer el color usando la propiedad computada
        self.color = color
    }
}
