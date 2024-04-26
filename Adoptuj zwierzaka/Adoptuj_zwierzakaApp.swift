//
//  Adoptuj_zwierzakaApp.swift
//  Adoptuj zwierzaka
//
//  Created by Paweł Staniul on 21/04/2024.
//

import SwiftUI

class AppState: ObservableObject {
    @Published var isAuthenticated = false
    @Published var selectedView: AnyView = AnyView(EmptyView())
    
    // Metoda do zmiany widoku
        func changeView(to view: AnyView) {
            DispatchQueue.main.async {
                self.selectedView = view
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
