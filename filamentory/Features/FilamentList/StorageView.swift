//
//  StorageView.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 10/07/2026.
//
import SwiftUI
import SwiftData

struct StorageView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Filament.type) private var filaments: [Filament]
    @State private var showNewFilament: Bool = false
    
    var body: some View {
        NavigationStack{
            Group {
                // LECCIÓN: Uso de condicionales en SwiftUI
                // Verificamos si hay filamentos en la base de datos
                if filaments.isEmpty {
                    // Si está vacío, mostramos un estado vacío amigable
                    emptyStateView
                } else {
                    // Si hay filamentos, mostramos la lista
                    filamentListView
                }
            }
            .navigationTitle("Storage")
            
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    EditButton()
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showNewFilament = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $showNewFilament) {
                NewFilamentView { newFilament in
                    print("📦 Guardando filamento: \(newFilament.brand) - \(newFilament.type)")
                    modelContext.insert(newFilament)
                    do {
                        try modelContext.save()
                        print("✅ Filamento guardado exitosamente")
                    } catch {
                        print("❌ Error saving filament: \(error)")
                    }
                }
            }
        }
    }
    
    private func deleteFilaments(offsets: IndexSet) {
        for index in offsets {
            let filament = filaments[index]
            print("🗑️ Eliminando filamento: \(filament.brand) - \(filament.type)")
            modelContext.delete(filament)
        }
        
        do {
            try modelContext.save()
            print("✅ Filamento eliminado exitosamente")
        } catch {
            print("❌ Error eliminando filament: \(error)")
        }
    }
}

#Preview {
    StorageView()
        .modelContainer(for: Filament.self, inMemory: true)
}

