//
//  StudyView.swift
//  EstudioFlashcards
//
//  Created by Juanjo on 07/06/2026.
//

import SwiftUI

struct StudyView: View {
    @Environment(\.dismiss) private var dismiss
    let deck: Deck
    let cards: [Card]   // ← pasamos las tarjetas ya barajadas
    
    @State private var currentIndex: Int = 0
    @State private var isFlipped: Bool = false
    @State private var knownCount: Int = 0
    @State private var unknownCount: Int = 0
    
    private var isFinished: Bool { currentIndex >= cards.count }
    private var currentCard: Card { cards[currentIndex] }
    
    var body: some View {
        Group {
            if isFinished {
                summaryView
            } else {
                studyCardView
            }
        }
        .padding()
        .frame(minWidth: 500, minHeight: 400)
    }
    
    private var studyCardView: some View {
        VStack(spacing: 20) {
            // 1. Progreso (ej: "Tarjeta 1 de 5")
            Text("Tarjeta \(currentIndex + 1) de \(cards.count)")
                .font(.headline)
                .foregroundStyle(.secondary)
            
            // 2. La tarjeta con flip
            flipCard
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            
            // 3. Botones según estado
            if isFlipped {
                HStack(spacing: 20) {
                    Button("No sabía") {
                        advanceCard(known: false)
                    }
                    .keyboardShortcut("x")
                    
                    Button("Sabía") {
                        advanceCard(known: true)
                    }
                    .keyboardShortcut(.return)
                }
            } else {
                Text("Click para ver la respuesta")
                    .foregroundStyle(.secondary)
            }
        }
    }
    private var flipCard: some View {
        ZStack {
            // Cara frontal (pregunta)
            cardFace(text: currentCard.question, color: deck.color.color)
                .opacity(isFlipped ? 0 : 1)
            
            // Cara trasera (respuesta) — pre-rotada
            cardFace(text: currentCard.answer, color: .green)
                .opacity(isFlipped ? 1 : 0)
                .rotation3DEffect(.degrees(180), axis: (x: 0, y: 1, z: 0))
        }
        .rotation3DEffect(
            .degrees(isFlipped ? 180 : 0),
            axis: (x: 0, y: 1, z: 0)
        )
        .animation(.easeInOut(duration: 0.5), value: isFlipped)
        .onTapGesture {
            isFlipped.toggle()
        }
    }

    private func cardFace(text: String, color: Color) -> some View {
        RoundedRectangle(cornerRadius: 16)
            .fill(color.opacity(0.2))
            .overlay(
                Text(text)
                    .font(.title)
                    .multilineTextAlignment(.center)
                    .padding()
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(color, lineWidth: 2)
            )
    }
    
    private func advanceCard(known: Bool) {
        if known {
            knownCount += 1
        } else {
            unknownCount += 1
        }
        isFlipped = false
        currentIndex += 1
    }
    
    private var summaryView: some View {
        VStack(spacing: 20) {
            Image(systemName: "checkmark.seal.fill")
                .font(.system(size: 80))
                .foregroundStyle(.green)
            
            Text("¡Has terminado!")
                .font(.largeTitle)
                .bold()
            
            VStack(spacing: 8) {
                Text("Sabía: \(knownCount)")
                    .foregroundStyle(.green)
                Text("No sabía: \(unknownCount)")
                    .foregroundStyle(.red)
                Text("Total: \(cards.count)")
                    .foregroundStyle(.secondary)
            }
            .font(.title2)
            
            Button("Terminar") { dismiss() }
                .buttonStyle(.borderedProminent)
        }
    }
    
}

#Preview {
    let store = DataStore()
    return StudyView(
        deck: store.decks[1],
        cards: store.cards(for: store.decks[1])
    )
    .environment(store)
}
