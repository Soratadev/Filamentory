//
//  ShoppingListItem.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 18/07/2026.
//
import Foundation
import SwiftData

@Model
final class ShoppingListItem {
    var id = UUID()
    var name: String
    var isChecked: Bool
    
    init(name: String, isChecked: Bool = false) {
        self.name = name
        self.isChecked = isChecked
    }
}
