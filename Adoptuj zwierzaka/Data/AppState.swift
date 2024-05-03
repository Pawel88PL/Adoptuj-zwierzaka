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
    // Deklaracja pól użytkownika
    @Published var currentUser: User?
    @Published  var userFirstName: String = ""
    @Published  var userSecondName: String = ""
    @Published  var userPhoneNumber: String = ""
    @Published  var userEmail: String = ""
    @Published var userRole: String = ""
    
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
            self.userFirstName = user.firstName ?? "firstName"
            self.userSecondName = user.secondName ?? "secondName"
            self.userPhoneNumber = user.phoneNumber ?? "phoneNumber"
            self.userEmail = user.email ?? "e-mail"
            self.userRole = user.role ?? "user"
            self.isAuthenticated = true
            self.selectedView = AnyView(PetListView())
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
    
    /// Aktualizacja wyświetlanych danych użytkownika
    func updateUserDetails(user: User) {
        DispatchQueue.main.async {
            self.userFirstName = user.firstName ?? "Brak imienia"
            self.userSecondName = user.secondName ?? "Brak nazwiska"
            self.userPhoneNumber = user.phoneNumber ?? "Brak numeru"
            self.userEmail = user.email ?? "Brak email"
            self.userRole = user.role ?? "user"
        }
    }
    
}
