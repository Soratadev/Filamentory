//
//  WelcomePage.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 31/07/2026.
//
import SwiftUI

struct WelcomePage: Identifiable {
    let id = UUID()
    let symbolName: String
    let title: LocalizedStringKey
    let description: LocalizedStringKey
}
