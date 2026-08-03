//
//  PrintCostCalculator.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 03/08/2026.
//
import Foundation

struct PrintCostCalculator {
    var selectedFilament: Filament?
    var gramUsed: Double = 0
    var printHours: Double = 0
    var wattage: Double = 0
    var pricePerKWh: Double = 0
    
    var filamentCost: Double {
        guard let filament = selectedFilament, filament.weight > 0 else { return 0 }
        
        return gramUsed * (filament.price / Double (filament.weight))
    }
    
    var electricityCost: Double {
        guard wattage > 0, printHours > 0, pricePerKWh > 0 else { return 0 }
        
        return (wattage / 1000) * printHours * pricePerKWh
    }
    
    var totalCost: Double {
        filamentCost + electricityCost
    }
}
