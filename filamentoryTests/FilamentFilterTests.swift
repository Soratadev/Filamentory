//
//  FilamentFilterTests.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 01/08/2026.
//
import Testing
import SwiftUI
@testable import filamentory

struct FilamentFilterTests {

    @Test func matchesWhenNoFiltersActive() {
        let filter = FilamentFilter()
        let filament = Filament(
            status: .open, brand: "Bambu Lab", type: "PLA",
            color: .white, nameColor: "White",
            weight: 1000, remaining: 800, amount: 1, price: 20
        )
        #expect(filter.matches(filament))
    }

    @Test func doesNotMatchWrongType() {
        var filter = FilamentFilter()
        filter.selectedType = "PETG"
        let plaFilament = Filament(
            status: .open, brand: "Bambu Lab", type: "PLA",
            color: .white, nameColor: "White",
            weight: 1000, remaining: 800, amount: 1, price: 20
        )
        #expect(!filter.matches(plaFilament))
    }

    @Test func searchIsCaseInsensitive() {
        var filter = FilamentFilter()
        filter.searchText = "bambu"
        let filament = Filament(
            status: .open, brand: "Bambu Lab", type: "PLA",
            color: .white, nameColor: "White",
            weight: 1000, remaining: 800, amount: 1, price: 20
        )
        #expect(filter.matches(filament))
    }
}
