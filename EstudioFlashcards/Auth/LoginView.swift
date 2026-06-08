//
//  LoginView.swift
//  EstudioFlashcards
//
//  Created by Juanjo on 08/06/2026.
//

import SwiftUI

struct LoginView: View {
    @Environment(AuthManager.self) private var auth
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var isSignUp: Bool = false
    @State private var isLoading: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            VStack(spacing: 8) {
                Image(systemName: "rectangle.on.rectangle.angled")
                    .font(.system(size: 60))
                    .foregroundStyle(.blue)
                Text("EstudioFlashcards")
                    .font(.largeTitle).bold()
                Picker("", selection: $isSignUp) {
                    Text("Iniciar sesión").tag(false)
                    Text("Registrarse").tag(true)
                }
                .pickerStyle(.segmented)
                TextField("Email", text: $email)
                    .textContentType(.emailAddress)
                    .textFieldStyle(.roundedBorder)
                    .autocorrectionDisabled()

                SecureField("Contraseña", text: $password)
                    .textContentType(isSignUp ? .newPassword : .password)
                    .textFieldStyle(.roundedBorder)
                Button {
                    Task {
                        await submit()
                    }
                } label: {
                    if isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity)
                    } else {
                        Text(isSignUp ? "Registrarse" : "Iniciar sesión")
                            .frame(maxWidth: .infinity)
                    }
                }
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .disabled(email.isEmpty || password.isEmpty || isLoading)
            }
            if let errorMessage = auth.errorMessage {
                Text(errorMessage)
                    .font(.caption)
                    .foregroundStyle(.red)
                    .multilineTextAlignment(.center)
            }
        }.padding(40)
            .frame(width: 400, height: 450)
    }
    
    private func submit() async {
        isLoading = true
        if isSignUp {
            await auth.signUp(email: email, password: password)
        } else {
            await auth.signIn(email: email, password: password)
        }
        isLoading = false
    }
}

#Preview {
    LoginView()
        .environment(AuthManager())
}
