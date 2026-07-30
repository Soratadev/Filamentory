//
//  FilamentFilter.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 29/07/2026.
//
import Foundation

struct FilamentFilter {
    var searchText: String = ""
    var selectedType: String? = nil
    var selectedBrand: String? = nil
    var selectedColorName: String? = nil
    var dateFilter: DateFilter = .all
    
    func matches (_ filament: Filament) -> Bool {
        matchesSearch(filament) &&
        matchesType(filament) &&
        matchesBrand(filament) &&
        matchesColor(filament) &&
        dateFilter.matches(filament.createdAt)
    }
    
    var isActive: Bool {
        !searchText.isEmpty ||
        selectedType != nil ||
        selectedBrand != nil ||
        selectedColorName != nil ||
        dateFilter != .all
    }
    
    private func matchesSearch(_ filament: Filament) -> Bool {
        guard !searchText.isEmpty else { return true }
        return  filament.brand.localizedCaseInsensitiveContains(searchText) ||
                filament.type.localizedCaseInsensitiveContains(searchText) ||
        filament.nameColor.localizedCaseInsensitiveContains(searchText)
    }
    
    private func matchesType(_ filament: Filament) -> Bool {
        guard let selectedType else { return true }
        return filament.type == selectedType
    }
    
    private func matchesBrand(_ filament: Filament) -> Bool {
        guard let selectedBrand else { return true }
        return filament.brand == selectedBrand
    }
    
    private func matchesColor(_ filament: Filament) -> Bool {
        guard let selectedColorName else { return true }
        return filament.nameColor == selectedColorName
    }
    
    mutating func clearStructuredFilters() {
        selectedType = nil
        selectedBrand = nil
        selectedColorName = nil
        dateFilter = .all
    }
}

