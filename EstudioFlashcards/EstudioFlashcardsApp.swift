//
//  EjemploDesktopApp.swift
//  EjemploDesktop
//
//  Created by Juanjo on 07/06/2026.
//

import SwiftUI

@main
struct EstudioFlashcardsApp: App {
    @State private var store = DataStore()
    var body: some Scene {
        WindowGroup {
            ContentView().environment(store)
        }
    }
}
