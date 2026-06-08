//
//  Models.swift
//  EstudioFlashcards
//
//  Created by Juanjo on 07/06/2026.
//

import Foundation
import SwiftUI

enum DeckColor: String, CaseIterable, Identifiable, Hashable, Codable {
    case red
    case blue
    case green
    case yellow
    case orange
    case purple
    case pink
    case gray
    
    var id: String {self.rawValue}
    
    var color: Color {
        switch self {
        case .red: return .red
        case .blue: return .blue
        case .green: return .green
        case .yellow: return .yellow
        case .orange: return .orange
        case .purple: return .purple
        case .pink: return .pink
        case .gray: return .gray
            
        }
    }
    var displayName: String {
        switch self{
        case .red: return "Rojo"
        case .blue: return "Azul"
        case .green: return "Verde"
        case .yellow: return "Amarillo"
        case .orange: return "Naranja"
        case .purple: return "Morado"
        case .pink: return "Rosa"
        case .gray: return "Gris"
        }
    }
}

enum DeckFormMode {
    case create
    case edit(Deck)
}

enum CardFormMode {
    case create(deckId: String) // necesitamos saber a que mazo
    case edit(Card)
}

struct Deck: Identifiable, Hashable, Codable {
    let id: String
    let userId: String
    var title: String
    var details : String
    var color: DeckColor
    let createdAt: Date
    
    init(userId: String, title: String, details: String, color: DeckColor) {
        self.id = UUID().uuidString
        self.userId = userId
        self.title = title
        self.details = details
        self.color = color
        self.createdAt = Date()
    }
}

struct Card : Identifiable, Hashable, Codable {
    let id: String
    let userId: String
    let deckId: String
    var question: String
    var answer: String
    let createdAt: Date
    
    init(userId: String, deckId: String, question: String, answer: String) {
        self.id = UUID().uuidString
        self.userId = userId
        self.deckId = deckId
        self.question = question
        self.answer = answer
        self.createdAt = Date()
    }
}
