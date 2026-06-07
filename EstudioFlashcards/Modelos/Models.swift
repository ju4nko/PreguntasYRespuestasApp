//
//  Models.swift
//  EstudioFlashcards
//
//  Created by Juanjo on 07/06/2026.
//

import Foundation
import SwiftUI

enum DeckColor: String, CaseIterable, Identifiable, Hashable {
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

struct Deck: Identifiable, Hashable {
    let id: String = UUID().uuidString
    var title: String
    var details : String
    var color: DeckColor
    let createdAt: Date = Date()
}

struct Card : Identifiable, Hashable {
    let id: String = UUID().uuidString
    let deckId: String
    var question: String
    var answer: String
    let createdAt: Date = Date()
}
