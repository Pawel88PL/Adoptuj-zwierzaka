//
//  AppState.swift
//  Adoptuj zwierzaka
//
//  Created by Paweł Staniul on 27/04/2024.
//

import Foundation
import SwiftUI

// Klasa AppState zarządza stanem uwierzytelnienia i nawigacją w aplikacji.
class AppState: ObservableObject {
    // Instancja Singleton
    static let shared = AppState()
    // Zmienna śledząca, czy użytkownik jest zalogowany.
    @Published var isAuthenticated = false
    // Aktualnie wyświetlany widok w aplikacji.
    @Published var selectedView: AnyView = AnyView(MainView())
    // Wiadomość alertu do wyświetlenia po wykonaniu określonych akcji.
    @Published var alertMessage: String? = nil
    // Deklaracja nazwy użytkownika
    @Published  var userFirstName: String = "name"
    // Domyślnie każdy użytkownik jest user
    @Published var userRole: String = "user"
    
    /// Zmienia bieżący widok na inny.
    /// - Parameter view: Widok, na który aplikacja powinna przejść.
    func changeView(to view: AnyView) {
        DispatchQueue.main.async {
            self.selectedView = view
        }
    }
    
    /// Loguje użytkownika, zmieniając stan uwierzytelnienia na true i aktualizując widok na listę zwierząt.
    func logIn(user: User) {
        DispatchQueue.main.async {
            self.userFirstName = user.firstName ?? "firsName"
            self.userRole = user.role ?? "user"
            self.isAuthenticated = true
            self.selectedView = AnyView(PetListView())
            print("Wywołanie z klasy AppState. Rola użytkownika: ", self.userRole)
            if self.userRole == "admin" {
                self.alertMessage = "Witamy w palenu administratora."
            } else {
                self.alertMessage = "Możesz teraz przeglądać listę dostępnych zwierząt."
            }
        }
    }
    
    /// Wylogowuje użytkownika, zmieniając stan uwierzytelnienia na false i pokazując główny widok aplikacji.
    func logOut() {
        DispatchQueue.main.async {
            self.isAuthenticated = false
            self.selectedView = AnyView(MainView())
        }
    }
    
    /// Obsługuje proces rejestracji użytkownika, przechodząc do widoku logowania z wiadomością potwierdzającą rejestrację.
    func registerUser() {
        DispatchQueue.main.async {
            self.selectedView = AnyView(LoginView())
            self.alertMessage = "Rejestracja zakończona sukcesem! Dziękujemy za założenie konta."
        }
    }
    
    func userView() {
        DispatchQueue.main.async {
            self.selectedView = AnyView(UserView())
        }
    }
}
