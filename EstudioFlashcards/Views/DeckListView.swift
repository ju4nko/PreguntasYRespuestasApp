//
//  DeckListView.swift
//  EstudioFlashcards
//
//  Created by Juanjo on 07/06/2026.
//

import SwiftUI

struct DeckListView: View {
    @Environment(DataStore.self) private var store
    @Binding var selectedDeckId: Deck.ID?
    @State private var deckToEdit: Deck? = nil
    var body: some View {
        List(store.decks, selection: $selectedDeckId) { deck in
            // contenido de cada fila
            HStack {
                Circle().fill(deck.color.color).frame(width: 12, height: 12)
                VStack(alignment: .leading) {
                    Text(deck.title).bold()
                    Text("\(store.cards(for: deck).count) tarjetas")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }.contextMenu {
                Button("Editar") { deckToEdit = deck }
                Button("Eliminar", role: .destructive) {
                    if selectedDeckId == deck.id {
                        selectedDeckId = nil
                    }
                    store.deleteDeck(deck)
                }
            }
            
        }.sheet(item: $deckToEdit) { deck in
            DeckFormView(mode:.edit(deck))
        }
    }
}

#Preview {
    @Previewable @State var selected: Deck.ID? = nil
    DeckListView(selectedDeckId: $selected)
        .environment(DataStore())
}
