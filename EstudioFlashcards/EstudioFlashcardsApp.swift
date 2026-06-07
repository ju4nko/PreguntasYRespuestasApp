//
//  EjemploDesktopApp.swift
//  EjemploDesktop
//
//  Created by Juanjo on 07/06/2026.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

@main
struct EstudioFlashcardsApp: App {
    
    @State private var store = DataStore()
    init() {
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
    }
    var body: some Scene {
        WindowGroup {
            ContentView().environment(store)
        }
    }
}
