//
//  DeckDetailView.swift
//  EstudioFlashcards
//
//  Created by Juanjo on 07/06/2026.
//

import SwiftUI

struct DeckDetailView: View {
    @Environment(DataStore.self) private var store
    @State private var showCardForm = false
    @State private var cardToEdit: Card? = nil
    let deck: Deck
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Circle()
                    .fill(deck.color.color)
                    .frame(width: 24, height: 24)
                Text(deck.title).font(.largeTitle).bold()
                
            }
            Text(deck.details).font(.subheadline).foregroundStyle(.secondary)
            let cardsForDeck = store.cards(for: deck)
            if cardsForDeck.isEmpty {
                ContentUnavailableView {
                    Label("Sin tarjetas",
                          systemImage: "rectangle.on.rectangle")
                }description: {
                    Text("Añade tu primera tarjeta a este mazo.")
                }actions: {
                    Button("Añadir tarjeta") {
                        showCardForm = true
                    }
                }
            } else {
                List(cardsForDeck) { card in
                    VStack {
                        Text(card.question).font(.headline)
                        Text(card.answer).foregroundStyle(.secondary)
                    }.contextMenu {
                        Button("Editar") { cardToEdit = card }
                        Button("Eliminar", role: .destructive) { store.deleteCard(card) }
                    }
                    
                }
            }
        }.toolbar {
            ToolbarItem(placement: .automatic) {
                Button {
                    // accion al pulsar el boton
                    showCardForm = true
                    
                }label: {
                    Label("Nueva tarjeta", systemImage: "rectangle.badge.plus")
                }
            }
        }.sheet(isPresented: $showCardForm) {
            CardFormView(mode: .create(deckId: deck.id))
        }.sheet(item: $cardToEdit) { card in
            CardFormView(mode: .edit(card))
        }
    }
}

#Preview {
    let store = DataStore()
    DeckDetailView(deck: store.decks[0]).environment(store)
}
