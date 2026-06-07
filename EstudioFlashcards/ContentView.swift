//
//  ContentView.swift
//  EjemploDesktop
//
//  Created by Juanjo on 07/06/2026.
//

import SwiftUI

struct ContentView: View {
    @Environment(DataStore.self) private var store
    @State private var selectedDeckId: Deck.ID?
    @State private var showDeckForm = false
    
    var body: some View {
        NavigationSplitView {
            DeckListView(selectedDeckId: $selectedDeckId)
        }detail: {
            if let id = selectedDeckId,
               let deck = store.decks.first(where: { $0.id == id }) {
                DeckDetailView(deck: deck)
            } else {
                ContentUnavailableView(
                    "Selecciona un mazo",
                    systemImage: "rectangle.on.rectangle"
                )
            }
        }.toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    showDeckForm = true
                } label: {
                    Label("Nuevo mazo", systemImage: "folder.badge.plus")
                }
            }
        }
        .sheet(isPresented: $showDeckForm) {
            DeckFormView(mode: .create)
        }
    }
}

#Preview {
    ContentView()
        .environment(DataStore())
}
