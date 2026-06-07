//
//  CardFormView.swift
//  EstudioFlashcards
//
//  Created by Juanjo on 07/06/2026.
//

import SwiftUI

struct CardFormView: View {
    @Environment(DataStore.self) private var store
    @Environment(\.dismiss) private var dismiss
    
    @State private var question: String = ""
    @State private var answer: String = ""
    
    let mode: CardFormMode
    
    init(mode: CardFormMode) {
        self.mode = mode
        switch mode {
        case .create:
            _question = State(initialValue: "")
            _answer = State(initialValue: "")
        case .edit(let card):
            _question = State(initialValue: card.question)
            _answer = State(initialValue: card.answer)
        }
    }
    
    private func save() {
        switch mode {
        case .create(let deckId):
            store.addCard(deckId:deckId, question: question, answer: answer )
        case .edit(let card):
            var updated = card
            updated.question = question
            updated.answer = answer
            store.updateCard(updated)
            
        }
        dismiss()
    }
    
    private var navTitle: String {
        switch mode {
        case .create: return "Nueva tarjeta"
        case .edit: return "Editar tarjeta"
        }
    }
    
    var body: some View {
        Form {
            Section("Tarjeta") {
                TextField("Pregunta", text: $question, axis: .vertical).lineLimit(3 ... 6)
                TextField("Respuesta", text: $answer, axis: .vertical).lineLimit(3 ... 6)
            }
        }.toolbar {
            ToolbarItem(placement:.cancellationAction ) {
                Button("Cancelar") { dismiss()}
            }
            ToolbarItem(placement:.confirmationAction) {
                Button("Guardar") {
                    save()
                }.disabled(question.isEmpty || answer.isEmpty)
            }
        }.navigationTitle(navTitle)
    }
}

#Preview("Crear") {
    let store = DataStore()
    return CardFormView(mode: .create(deckId: store.decks[0].id))
        .environment(store)
}

#Preview("Editar") {
    let store = DataStore()
    return CardFormView(mode: .edit(store.cards[0]))
        .environment(store)
}
