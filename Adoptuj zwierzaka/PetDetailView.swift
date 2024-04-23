//
//  PetDetailView.swift
//  Adoptuj zwierzaka
//
//  Created by Paweł Staniul on 21/04/2024.
//

import SwiftUI

struct PetDetailView: View {
    var pet: Pet

    var body: some View {
        VStack(alignment: .leading) {
            Text(pet.name ?? "Nieznany")
                .font(.title)
            Text("Rasa: \(pet.breed ?? "Nieznana")")
                .font(.subheadline)
            Text("Wiek: \(pet.age)")
                .font(.subheadline)
            if let descriptions = pet.descriptions, !descriptions.isEmpty {
                Text("Opis:")
                    .font(.headline)
                Text(descriptions)
            }
            Spacer()
        }
        .padding()
        .appBackground()
        .navigationBarTitle(Text(pet.name ?? "Szczegóły"), displayMode: .inline)
    }
}
