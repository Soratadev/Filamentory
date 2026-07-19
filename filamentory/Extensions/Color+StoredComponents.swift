//
//  Color+RGBAComponents.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 16/07/2026.
//
import SwiftUI

extension Color {
    var storedComponents: (red: Double, green: Double, blue: Double, opacity: Double) {
        let resolved = resolve(in: EnvironmentValues())
        return (
            Double(resolved.red),
            Double(resolved.green),
            Double(resolved.blue),
            Double(resolved.opacity))
    }
}
