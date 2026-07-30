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
    @State private var filter = FilamentFilter()
    @State private var showFilters: Bool = false
    
    private var filteredFilaments: [Filament] {
        filaments.filter(filter.matches) }
    
    var body: some View {
        NavigationStack{
            Group {
                // Verificamos si hay filamentos en la base de datos
                if filaments.isEmpty {
                    // Si está vacío, mostramos un estado vacío amigable
                    emptyStateView
                } else if filteredFilaments.isEmpty {
                    // si hay filamentos pero ninguno coincide con la búsqueda
                    noResultsView
                } else {
                    // Si hay filamentos, mostramos la lista
                    filamentListView
                }
            }
            .navigationTitle("Storage")
            .searchable(text: $filter.searchText, prompt: "Search filaments")
            .toolbar {
                if !filaments.isEmpty {
                    ToolbarItem(placement: .topBarLeading) {
                        EditButton()
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showNewFilament = true
                    } label: {
                        Image(systemName: "plus")
                    }
                }
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        showFilters = true
                    } label: {
                        Text("Filter")
                        Image(systemName: filter.isActive ? "line.3.horizontal.decrease.circle.fill" : "line.3.horizontal.decrease.circle")
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
            .sheet(isPresented: $showFilters) {
                FilamentFilterView(filter: $filter, allFilaments: filaments)
            }
        }
    }
    private func favoriteToggle(_ filament: Filament) {
        withAnimation(.spring()) {
            filament.isFavorite.toggle()
        }
        do {
            try modelContext.save()
        } catch {
            print("❌ Error updating favorite: \(error)")
        }
    }
    
    private var emptyStateView: some View {
        ContentUnavailableView(
            "No filaments yet",
            systemImage: "shippingbox.fill",
            description: Text("Tap the + button to add your first filament")
        )
    }
    
    private var noResultsView: some View {
        ContentUnavailableView(
            "No Matches",
            systemImage: "magnifyingglass",
            description: Text("Try using different search criteria")
        )
    }
    
    private var filamentListView: some View {
        List {
            ForEach(filteredFilaments) { filament in
                NavigationLink {
                    DetailsFilamentView(filament: filament)
                } label: {
                    FilamentRow(filament: filament)
                }
                .swipeActions(edge: .leading, allowsFullSwipe: true) {
                    Button {
                        favoriteToggle(filament)
                    } label: {
                        Label(
                            filament.isFavorite ? "Unfavorite" : "Favorite",
                            systemImage: filament.isFavorite ? "star.slash.fill" : "star.fill"
                        )
                    }
                    .tint(.yellow)
                }
                .listRowBackground( filament.remaining <= 0 ? Color.red.opacity(0.08) : nil)
            }
            .onDelete(perform: deleteFilaments)
        }
    }
    
    private func deleteFilaments(offsets: IndexSet) {
        for index in offsets {
            let filament = filteredFilaments[index]
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

