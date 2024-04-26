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
            VStack {
                // Obraz zwierzaka
                if let imageData = pet.image, let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFit()
                        .cornerRadius(12)
                        .padding(.horizontal)
                        .padding(.top)
                }
                
                // Karta z informacjami
                VStack(alignment: .leading, spacing: 10) {
                    Text(pet.name ?? "Nieznany")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Divider()
                    
                    HStack {
                        Text("Rasa:")
                            .fontWeight(.semibold)
                        Text(pet.breed ?? "Nieznana")
                            .font(.subheadline)
                    }
                    
                    HStack {
                        Text("Wiek:")
                            .fontWeight(.semibold)
                        Text("\(pet.age)")
                            .font(.subheadline)
                    }
                    
                    if let descriptions = pet.descriptions, !descriptions.isEmpty {
                        VStack(alignment: .leading) {
                            Text("Opis:")
                                .fontWeight(.semibold)
                                .padding(.bottom, 20)
                            
                            Text(descriptions)
                                .font(.subheadline)
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(12)
                .shadow(radius: 5)
                .padding(.horizontal)
                .padding(.bottom)
            }
        }
        .navigationBarTitle(Text(pet.name ?? "Szczegóły"), displayMode: .inline)
        .appBackground()
        .edgesIgnoringSafeArea(.bottom)
    }
}
