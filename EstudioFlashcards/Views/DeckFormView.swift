//
//  DeckFormMode.swift
//  EstudioFlashcards
//
//  Created by Juanjo on 07/06/2026.
//

import SwiftUI

struct DeckFormView: View {
    @Environment(DataStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    
    let mode: DeckFormMode
    
    init(mode: DeckFormMode) {
        self.mode = mode
        switch mode {
        case .create:
            _title = State(initialValue: "")
            _details = State(initialValue: "")
            _color = State(initialValue: .blue)
        case .edit(let deck):
            _title = State(initialValue: deck.title)
            _details = State(initialValue: deck.details)
            _color = State(initialValue: deck.color)
        }
    }
    
    @State private var title: String = ""
    @State private var details: String = ""
    @State private var color: DeckColor = .blue
    
    private var navTitle: String {
        switch mode {
        case .create: return "Nuevo mazo"
        case .edit: return "Editar mazo"
        }
    }
    
    
    var body: some View {
        Form {
            Section("Datos del mazo") {
                TextField("Título", text: $title)
                TextField("Descripción", text: $details)
            }
            Section("Color") {
                Picker("Color", selection: $color) {
                    ForEach(DeckColor.allCases) { c in
                        Text(c.displayName).tag(c)
                    }
                }
            }
        }.frame(minWidth: 400,minHeight: 300)
            .navigationTitle(navTitle)
        .toolbar {
            ToolbarItem(placement:.cancellationAction ) {
                Button("Cancelar") { dismiss()}
            }
            ToolbarItem(placement:.confirmationAction) {
                Button("Guardar") {
                    save()
                }.disabled(title.isEmpty)
            }
        }
    }
    
    private func save() {
        switch mode {
        case .create:
            store.addDeck(title: title, details: details, color: color)
        case .edit(let deck):
            var updated = deck
            updated.title = title
            updated.details = details
            updated.color = color
            store.updateDeck(updated)
        }
        dismiss()
    }
}

#Preview("Crear") {
    DeckFormView(mode: .create)
        .environment(DataStore())
}
#Preview("Editar") {
    let store = DataStore()
    return DeckFormView(mode: .edit(store.decks[0]))
        .environment(store)
}

