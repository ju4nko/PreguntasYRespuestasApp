//
//  RootView.swift
//  EstudioFlashcards
//
//  Created by Juanjo on 08/06/2026.
//

import SwiftUI

struct RootView: View {
    @Environment(AuthManager.self) private var auth
    
    var body: some View {
        if auth.isAuthenticated {
            ContentView()
        } else {
            LoginView()
        }
    }
}

#Preview("Sin login") {
    RootView().environment(AuthManager())
        .environment(DataStore())
}
