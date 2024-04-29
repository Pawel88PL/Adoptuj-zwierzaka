//
//  Adoptuj_zwierzakaApp.swift
//  Adoptuj zwierzaka
//
//  Created by Paweł Staniul on 21/04/2024.
//

import SwiftUI

@main
struct Adoptuj_zwierzakaApp: App {
    // Stan aplikacji przechowujący zarówno dane użytkownika, jak i bieżący widok.
    @StateObject var appState = AppState()
    // Kontroler persystencji zarządzający bazą danych CoreData.
    let persistenceController = PersistenceController.shared
    
    // Główny punkt wejścia aplikacji określający zawartość głównego okna.
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
