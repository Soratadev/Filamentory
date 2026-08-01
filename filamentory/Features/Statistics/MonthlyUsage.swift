//
//  MonthlyUsage.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 30/07/2026.
//
import Foundation

struct MonthlyUsage: Identifiable {
    let month: Date
    let totalUsed: Int
    
    var id: Date { month }
}
