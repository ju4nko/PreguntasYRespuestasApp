//
//  DataStore.swift
//  EstudioFlashcards
//
//  Created by Juanjo on 07/06/2026.
//

import Foundation
import Observation

@Observable
final class DataStore {
    var decks: [Deck] = []
    var cards: [Card] = []
    
    init() {
        loadSampleData()
    }
    
    private func loadSampleData() {
        // Creamos los decks de ejemplo
        let swift_basico: Deck = Deck(title: "Swift Básico", details: "Carta para aprender swift", color: .red)
        let capitales: Deck = Deck(title: "Capitales", details: "Lista de capitales del mundo", color: .blue)
        let historia: Deck = Deck(title: "Historia", details: "Historia de España", color: .yellow)
        
        
        // Creamos cartas de ejemplo
        let card1: Card = Card(deckId: swift_basico.id, question: "¿En que lenguaje se desarrolla iOS?", answer: "Swift")
        let card2: Card = Card(deckId: capitales.id, question: "¿Cuál es la capital de Francia?", answer: "París")
        let card3: Card = Card(deckId: capitales.id, question: "¿Cuál es la capital de España?", answer: "Madrid")
        let card4: Card = Card(deckId: historia.id, question: "¿En qué año España ganó la Copa del Mundo?", answer: "2018")
        
        self.decks = [swift_basico, capitales, historia]
        self.cards = [card1, card2, card3, card4]
        
    }
    
    // Métodos CRUD para Deck
    
    func addDeck(title: String, details: String, color: DeckColor) {
        decks.append(Deck(title: title, details: details, color: color))
    }
    
    func updateDeck(_ deck: Deck) {
        guard let index = decks.firstIndex(where:{$0.id == deck.id}) else { return }
        decks[index] = deck
    }
    
    func deleteDeck(_ deck: Deck) {
        decks.removeAll { $0.id == deck.id }
        // Borramos todas las cartas para que no se queden huerfanas
        cards.removeAll { $0.deckId == deck.id}
        
    }
    
    // Métodos CRUD para Card
    
    func cards(for deck: Deck) -> [Card] {
        return cards.filter { $0.deckId == deck.id }
    }
    
    func addCard(deckId: String, question: String, answer: String ) {
        cards.append(Card(deckId: deckId, question: question, answer: answer))
    }
    
    func updateCard(_ card: Card) {
        guard let index = cards.firstIndex(where:{$0.id == card.id}) else { return }
        cards[index] = card
    }
    
    func deleteCard(_ card: Card) {
        cards.removeAll { $0.id == card.id }
    
    }
    
}

