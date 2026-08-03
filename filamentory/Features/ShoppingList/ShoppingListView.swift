//
//  ShoppingListView.swift
//  filamentory
//
//  Created by Alejandro Ortega García on 18/07/2026.
//
import SwiftUI
import SwiftData


struct ShoppingListView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \ShoppingListItem.name) private var items: [ShoppingListItem]
    @State private var showAddAlert: Bool = false
    @State private var newItemName: String = ""
    
    var body: some View {
        NavigationStack {
            Group {
                if items.isEmpty {
                    emptyStateView
                        .transition(.opacity)
                } else {
                    itemListView
                        .transition(.opacity)
                }
            }
            .animation(.default, value: items.count)
            .navigationTitle("Shopping List")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showAddAlert = true
                    } label: {
                        Image(systemName: "plus")
                    }
                    .accessibilityLabel("Add item")
                }
            }
            .alert("New Item", isPresented: $showAddAlert) {
                TextField("Name", text: $newItemName)
                Button("Cancel", role: .cancel) { newItemName = "" }
                Button("Add") { addItem()
                }
            }
        }
    }
    
    
    private func addItem() {
        let trimmedName = newItemName.trimmingCharacters(in: .whitespaces)
        guard !trimmedName.isEmpty else { return }
        
        let newItem = ShoppingListItem(name: trimmedName)
        modelContext.insert(newItem)
        
        do{
            try modelContext.save()
        } catch {
            print("❌ Error saving item: \(error)")
        }
        
        newItemName = ""
    }
    
    private func deleteItems(at offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(items[index])
        }
        do {
            try modelContext.save()
        } catch {
            print("❌ Error deleting item: \(error)")
        }
    }
    
    private var emptyStateView: some View {
        ContentUnavailableView(
            "Shopping list is empty",
            systemImage: "cart",
            description: Text("Tap the + button to add something you need to buy")
        )
    }
    
    private var itemListView: some View {
        List {
            ForEach(items) { item in
                HStack {
                    Button {
                        item.isChecked.toggle()
                    } label: {
                        Image(systemName: item.isChecked ? "checkmark.circle.fill" : "checkmark.circle")
                            .foregroundStyle(item.isChecked ? .green: .primary)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel(item.isChecked ? "Mark as not bought" : "Mark as bought")
                    
                    Text(item.name)
                        .strikethrough(item.isChecked)
                        .foregroundStyle(item.isChecked ? .secondary : .primary)
                }
            }
            .onDelete(perform: deleteItems)
        }
    }
}

#Preview {
    ShoppingListView()
        .modelContainer(for: ShoppingListItem.self, inMemory: true)
}

