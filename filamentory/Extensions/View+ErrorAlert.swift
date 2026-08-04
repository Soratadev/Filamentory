//
//  ViewErrorAlert.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 01/08/2026.
//
import SwiftUI

extension View {
    func errorAlert(_ error: Binding<String?>) -> some View {
        alert(
            "Something went wrong",
            isPresented: Binding(
                get: { error.wrappedValue != nil },
                set: { isPresented in
                    if !isPresented { error.wrappedValue = nil }
                }
            )
        ) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(error.wrappedValue ?? "")
        }
    }
}
