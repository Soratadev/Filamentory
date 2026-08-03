//
//  WelcomeView.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 31/07/2026.
//
import SwiftUI

struct WelcomeView: View {
    @Environment(\.dismiss) private var dismiss
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome: Bool = false

    private let pages: [WelcomePage] = [
        WelcomePage(
            symbolName: "shippingbox.fill",
            title: "Track your filament",
            description: "Keep a full inventory of every spool: brand, color, material and how much is left."
        ),
        WelcomePage(
            symbolName: "cart.fill",
            title: "Never run out",
            description: "Add filaments to your shopping list and get notified when a spool runs empty."
        ),
        WelcomePage(
            symbolName: "chart.bar.fill",
            title: "Understand your usage",
            description: "See monthly consumption, your most-used color, and the value of your inventory at a glance. Check out the cost calculator for your projects."
        )
    ]

    var body: some View {
        VStack(spacing: 24) {
            TabView {
                ForEach(pages) { page in
                    VStack(spacing: 20) {
                        Image(systemName: page.symbolName)
                            .font(.system(size: 80))
                            .foregroundStyle(.tint)
                        Text(page.title)
                            .font(.title2.bold())
                        Text(page.description)
                            .font(.body)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 32)
                    }
                }
            }
            .tabViewStyle(.page)
            .indexViewStyle(.page(backgroundDisplayMode: .always))

            Button("Get Started") {
                hasSeenWelcome = true
                dismiss()
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            .padding(.horizontal, 40)
            .padding(.bottom, 32)
        }
    }
}

#Preview {
    WelcomeView()
}
