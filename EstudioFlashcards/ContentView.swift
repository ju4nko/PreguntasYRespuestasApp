//
//  ContentView.swift
//  EjemploDesktop
//
//  Created by Juanjo on 07/06/2026.
//

import SwiftUI
import FirebaseAuth

struct ContentView: View {
    @Environment(DataStore.self) private var store
    @Environment(AuthManager.self) private var auth
    
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
            ToolbarItem(placement: .primaryAction) {
                Button {
                    auth.signOut()
                } label: {
                    Label("Cerrar sesión", systemImage: "rectangle.portrait.and.arrow.right")
                }
            }
            ToolbarItem(placement: .automatic) {
                if let email = auth.user?.email {
                    Text(email)
                        .font(.caption)
                        .foregroundStyle(.secondary)
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
