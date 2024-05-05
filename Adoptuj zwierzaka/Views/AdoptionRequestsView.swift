//
//  AdoptionRequestsView.swift
//  Adoptuj zwierzaka
//
//  Created by Paweł Staniul on 05/05/2024.
//

import SwiftUI

/*
struct AdoptionRequestsView: View {
    @FetchRequest(
        entity: Pet.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \Pet.name, ascending: true)],
        predicate: NSPredicate(format: "adopter != nil")
    ) var adoptedPets: FetchedResults<Pet>
    
    var body: some View {
        NavigationView {
            List(adoptedPets, id: \.self) { pet in
                HStack {
                    VStack(alignment: .leading) {
                        Text(pet.name ?? "Nieznany")
                        Text("Adoptowany przez: \(pet.adopter?.fullName ?? "Brak danych")").font(.subheadline).foregroundColor(.secondary)
                    }
                    Spacer()
                    Text(pet.isAdoptionConfirmed ? "Zaakceptowano" : "Oczekuje").foregroundColor(pet.isAdoptionConfirmed ? .green : .orange)
                }
            }
            .navigationTitle("Wnioski Adopcyjne")
        }
    }
}


struct AdoptionRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        AdoptionRequestsView()
    }
}
*/
