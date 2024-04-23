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
        ScrollView {
            VStack(alignment: .leading) {
                if let imageData = pet.image, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(10)
                        .padding()
                }

                Text(pet.name ?? "Nieznany")
                    .font(.title)
                Text("Rasa: \(pet.breed ?? "Nieznana")")
                    .font(.subheadline)
                Text("Wiek: \(String(pet.age))")
                    .font(.subheadline)
                if let descriptions = pet.descriptions, !descriptions.isEmpty {
                    Text("Opis:")
                        .font(.headline)
                    Text(descriptions)
                }
                Spacer()
            }
        }
        .padding()
        .navigationBarTitle(Text(pet.name ?? "Szczegóły"), displayMode: .inline)
        .appBackground()
    }
}
