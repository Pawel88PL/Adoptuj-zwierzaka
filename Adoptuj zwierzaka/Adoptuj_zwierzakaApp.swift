//
//  Adoptuj_zwierzakaApp.swift
//  Adoptuj zwierzaka
//
//  Created by Paweł Staniul on 21/04/2024.
//

import SwiftUI

@main
struct Adoptuj_zwierzakaApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
