//
//  AdoptionRequestsView.swift
//  Adoptuj zwierzaka
//
//  Created by Paweł Staniul on 05/05/2024.
//

import SwiftUI
import CoreData

struct AdoptionRequestsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        entity: AdoptionRequest.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \AdoptionRequest.dateCreated, ascending: false)],
        predicate: nil // Możesz dodać predykat, jeśli chcesz filtrować wyniki
    ) var adoptionRequests: FetchedResults<AdoptionRequest>
    
    var body: some View {
        List(adoptionRequests, id: \.self) { request in
            VStack(alignment: .leading, spacing: 10) {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Zwierzę: \(request.pet?.name ?? "Nieznane")")
                            .font(.headline)
                        Text("Rasa: \(request.pet?.breed ?? "Nieznana")")
                            .font(.subheadline)
                    }
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text("Data wniosku:")
                            .font(.caption)
                        Text(request.dateCreated ?? Date(), formatter: itemFormatter)
                            .font(.caption)
                    }
                }
                HStack {
                    Text("Osoba:")
                        .font(.headline)
                    Spacer()
                    Text("\(request.user?.firstName ?? "Imię") \(request.user?.secondName ?? "Nazwisko")")
                        .font(.subheadline)
                }
                Text("Email: \(request.user?.email ?? "Nieznany email")")
                Text("Tel: \(request.user?.phoneNumber ?? "Brak numeru")")
                Text("Status: \(request.status ?? "Nieznany")")
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
            .shadow(radius: 2)
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Wnioski Adopcyjne")
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct AdoptionRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        AdoptionRequestsView()
    }
}
