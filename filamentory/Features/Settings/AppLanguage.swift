//
//  AppLanguage.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 30/07/2026.
//
import Foundation

enum AppLanguage: String, CaseIterable, Identifiable {
    case english = "en"
    case spanish = "es"
    
    var id: Self { self }
    
    var locale: Locale {
        Locale(identifier: rawValue)
    }
    
    func localizedName(locale: Locale) -> String {
        switch self {
        case .english: return String(localized: "English", locale: locale)
        case .spanish: return String(localized: "Spanish", locale: locale)
        }
    }
}

extension AppLanguage {
    static var systemDefault: AppLanguage {
        Locale.current.language.languageCode?.identifier == "es" ? .spanish : .english
    }
}
