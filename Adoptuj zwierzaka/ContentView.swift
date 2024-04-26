//
//  ContentView.swift
//  Adoptuj zwierzaka
//
//  Created by Paweł Staniul on 21/04/2024.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        // Decyzja, który widok wyświetlić w zależności od stanu uwierzytelnienia
        Group {
            if appState.isAuthenticated {
                // Jeśli użytkownik jest uwierzytelniony, pokaż listę zwierząt
                PetListView()
            } else {
                // Jeśli użytkownik nie jest uwierzytelniony, pokaż ekran logowania
                MainView()
            }
        }
    }
}

extension View {
    func appBackground() -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.white, Color.blue]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            )
    }
}
