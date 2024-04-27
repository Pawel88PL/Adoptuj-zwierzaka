//
//  Adoptuj_zwierzakaApp.swift
//  Adoptuj zwierzaka
//
//  Created by Paweł Staniul on 21/04/2024.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var isAuthenticated = false
    @Published var selectedView: AnyView = AnyView(MainView())
    @Published var alertMessage: String? = nil
    
    // Metoda do zmiany widoku
    func changeView(to view: AnyView) {
        DispatchQueue.main.async {
            self.selectedView = view
        }
    }
    
    // Metoda do logowania użytkownika
    func logIn() {
        DispatchQueue.main.async {
            self.isAuthenticated = true
            self.selectedView = AnyView(PetListView())
        }
    }
    
    // Metoda do wylogowania użytkownika
    func logOut() {
        DispatchQueue.main.async {
            self.isAuthenticated = false
            self.selectedView = AnyView(MainView())
        }
    }
    
    // Metoda do obsługi rejestracji użytkownika
    func registerUser() {
        DispatchQueue.main.async {
            self.selectedView = AnyView(LoginView())
            self.alertMessage = "Rejestracja zakończona sukcesem! Dziękujemy za założenie konta."
        }
    }
}


@main
struct Adoptuj_zwierzakaApp: App {
    @StateObject var appState = AppState()
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
