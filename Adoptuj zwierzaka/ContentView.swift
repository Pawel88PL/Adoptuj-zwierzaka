//
//  ContentView.swift
//  Adoptuj zwierzaka
//
//  Created by Paweł Staniul on 21/04/2024.
//

import SwiftUI
import CoreData


struct PetRow: View {
    var pet: Pet
    
    var body: some View {
        HStack {
            Text(pet.name ?? "Nieznany")
            Spacer()
            Text("Rasa: \(pet.breed ?? "Nieznana")")
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
