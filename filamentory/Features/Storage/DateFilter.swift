//
//  DateFilter.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 19/07/2026.
//
import Foundation

enum DateFilter: String, CaseIterable, Identifiable {
    case all = "All"
    case lastWeek = "Last week"
    case lastMonth = "Last month"
    case lastYear = "Last year"
    
    var localizedName: String {
        switch self {
        case .all: return String(localized: "All")
        case .lastWeek: return String(localized: "Last week")
        case .lastMonth: return String(localized: "Last month")
        case .lastYear: return String(localized: "Last year")
        }
    }
    
    var id: Self { self }
    
    func matches(_ date: Date) -> Bool {
        switch self {
        case .all: return true
        case .lastWeek:
            let threshold =
    Calendar.current.date(byAdding: .day, value: -7, to: .now) ?? .distantPast
            return date >= threshold
        case .lastMonth:
            let threshold =
    Calendar.current.date(byAdding: .month, value: -1, to: .now) ?? .distantPast
            return date >= threshold
        case .lastYear:
            let threshold =
    Calendar.current.date(byAdding: .year, value: -1, to: .now) ?? .distantPast
            return date >= threshold
        }
    }
}
