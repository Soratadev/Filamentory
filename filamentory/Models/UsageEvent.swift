//
//  UsageEvent.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 18/07/2026.
//
import Foundation
import SwiftData

@Model
final class UsageEvent {
    var id = UUID()
    var date: Date
    var amountUsed: Int // gramos consumidos cada vez
    var filament: Filament? // el filamento del que provino
    
    init (date: Date, amountUsed: Int, filament: Filament?) {
        self.date = date
        self.amountUsed = amountUsed
        self.filament = filament
    }
}

