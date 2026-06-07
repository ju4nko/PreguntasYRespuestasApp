//
//  DataStore.swift
//  EstudioFlashcards
//
//  Created by Juanjo on 07/06/2026.
//

import Foundation
import Observation
import FirebaseFirestore
import FirebaseCore

@Observable
final class DataStore {
    var decks: [Deck] = []
    var cards: [Card] = []
    
    // Referencia al cliente Firestore
    private let db: Firestore
    
    // Listeners (los guardamos para poder cancelarlos al desinicializar)
    private var decksListener: ListenerRegistration?
    private var cardsListener: ListenerRegistration?
    
    init() {
        // Asegúrate de que FirebaseApp esté configurado antes de usar Firestore
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        self.db = Firestore.firestore()
        startListening()
    }
    
    deinit {
        decksListener?.remove()
        cardsListener?.remove()
    }
    
    private func startListening() {
        
        // Escuchar la colección "decks"
        decksListener = db.collection("decks")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("❌ Error escuchando decks: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    self.decks = []
                    return
                }
                
                // Convertir cada documento en Deck
                self.decks = documents.compactMap { doc in
                    try? doc.data(as: Deck.self)
                }
            }
        
        // Escuchar la colección "cards"
        cardsListener = db.collection("cards")
            .order(by: "createdAt", descending: true)
            .addSnapshotListener { [weak self] snapshot, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("❌ Error escuchando cards: \(error)")
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    self.cards = []
                    return
                }
                
                self.cards = documents.compactMap { doc in
                    try? doc.data(as: Card.self)
                }
            }
    }
    
    // Métodos CRUD para Deck
    
    func addDeck(title: String, details: String, color: DeckColor) {
        let deck = Deck(title: title, details: details, color: color)
        do {
            try db.collection("decks").document(deck.id).setData(from: deck)
        } catch {
            print("❌ Error añadiendo deck: \(error)")
        }
    }
    
    func updateDeck(_ deck: Deck) {
        do {
            try db.collection("decks").document(deck.id).setData(from: deck)
        } catch {
            print("❌ Error actualizando deck: \(error)")
        }
    }
    
    func deleteDeck(_ deck: Deck) {
        db.collection("decks").document(deck.id).delete()

        // Borrar también las cards de ese deck (cascada)
        db.collection("cards")
            .whereField("deckId", isEqualTo: deck.id)
            .getDocuments { snapshot, error in
                snapshot?.documents.forEach { doc in
                    doc.reference.delete()
                }
            }
        
    }
    
    // Métodos CRUD para Card
    
    func cards(for deck: Deck) -> [Card] {
        return cards.filter { $0.deckId == deck.id }
    }
    
    func addCard(deckId: String, question: String, answer: String ) {
        let card = Card(deckId: deckId, question: question, answer: answer)
        do {
            try db.collection("cards").document(card.id).setData(from: card)
        } catch {
            print("❌ Error añadiendo card: \(error)")
        }
    }
    
    func updateCard(_ card: Card) {
        do {
            try db.collection("cards").document(card.id).setData(from: card)
        } catch {
            print("❌ Error actualizando card: \(error)")
        }
    }
    
    func deleteCard(_ card: Card) {
        db.collection("cards").document(card.id).delete()
    
    }
    
}

