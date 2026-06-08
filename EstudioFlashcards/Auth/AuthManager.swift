//
//  AuthManager.swift
//  EstudioFlashcards
//
//  Created by Juanjo on 08/06/2026.
//

import Foundation
import FirebaseAuth
import Observation
import Firebase

@Observable
final class AuthManager {
    var user: User? = nil
    var errorMessage: String? = nil
    var isAuthenticated: Bool { user != nil }
    var userId: String? { user?.uid }
    
    private func startListening() {
        handle = Auth.auth().addStateDidChangeListener { [weak self] _, user in
            self?.user = user
        }
    }
    
    func signUp(email: String, password: String) async {
        do {
            _ = try await Auth.auth().createUser(withEmail: email, password: password)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    func signIn(email: String, password: String) async {
        do {
            _ = try await Auth.auth().signIn(withEmail: email, password: password)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    func signOut() {
        do {
            try Auth.auth().signOut()
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
    
    private var handle: AuthStateDidChangeListenerHandle?
    
    init() {
        // Asegúrate de que FirebaseApp esté configurado antes de usar Firestore
        if FirebaseApp.app() == nil {
            FirebaseApp.configure()
        }
        startListening()
    }
    
    deinit {
        if let handle = handle {
            Auth.auth().removeStateDidChangeListener(handle)
        }
    }
}

