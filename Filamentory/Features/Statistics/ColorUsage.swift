//
//  ColorUsage.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 30/07/2026.
//
import Foundation

struct ColorUsage: Identifiable {
    let colorName: String
    let totalUsed: Int
    
    var id: String { colorName }
}
