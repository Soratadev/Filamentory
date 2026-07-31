//
//  AppTheme.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 30/07/2026.
//
import SwiftUI

enum AppTheme: String, CaseIterable, Identifiable {
    case system, light, dark
    
    var id: Self { self }
    
    var colorScheme: ColorScheme? {
        switch self {
        case .system: return nil
        case .light: return .light
        case .dark: return .dark
        }
    }
    
    func localizedName(locale: Locale) -> String {
        switch self {
            case .system: return String(localized: "System", locale: locale)
            case .light: return String(localized: "Light", locale: locale)
            case .dark: return String(localized: "Dark", locale: locale)
        }
    }
}
