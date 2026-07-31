//
//  MaterialBreakdown.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 30/07/2026.
//
import Foundation

struct MaterialBreakdown: Identifiable {
    let type: String
    let totalWeight: Int
    
    var id: String { type }
}
