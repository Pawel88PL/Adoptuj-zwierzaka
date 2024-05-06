//
//  UserAdoptionRequestsView.swift
//  Adoptuj zwierzaka
//
//  Created by Paweł Staniul on 06/05/2024.
//

import SwiftUI
import CoreData

struct UserAdoptionRequestsView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var appState: AppState
    
    @FetchRequest(
        entity: AdoptionRequest.entity(),
        sortDescriptors: [NSSortDescriptor(keyPath: \AdoptionRequest.dateCreated, ascending: false)]
    ) var adoptionRequests: FetchedResults<AdoptionRequest>
    
    var body: some View {
        List(adoptionRequests, id: \.self) { request in
            VStack(alignment: .leading, spacing: 10) {
                Text("Zwierzę: \(request.pet?.name ?? "Nieznane")")
                    .font(.headline)
                Text("Rasa: \(request.pet?.breed ?? "Nieznana")")
                    .font(.subheadline)
                Text("Data wniosku: \(request.dateCreated ?? Date(), formatter: itemFormatter)")
                    .font(.caption)
                Text("Status: \(request.status ?? "Nieznany")")
                    .foregroundColor(colorForStatus(request.status))
            }
            .padding()
            .background(Color.secondary.opacity(0.1))
            .cornerRadius(10)
            .shadow(radius: 2)
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Moje wnioski adopcyjne")
        .onAppear {
            setFetchRequestPredicate()
        }
    }
    
    private func setFetchRequestPredicate() {
        if let currentUser = appState.currentUser {
            let predicate = NSPredicate(format: "user == %@", currentUser)
            adoptionRequests.nsPredicate = predicate
        }
    }
    
    private func colorForStatus(_ status: String?) -> Color {
        guard let status = status else { return .gray }
        switch status {
        case "Zatwierdzony":
            return .green
        case "Odrzucony":
            return .red
        case "Wniosek wysłany":
            return .blue
        default:
            return .gray
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()




struct UserAdoptionRequestsView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.preview.container.viewContext
        
        // Przykładowy użytkownik
        let user = User(context: context)
        user.firstName = "Jan"
        user.secondName = "Kowalski"
        user.email = "jan@example.com"
        user.phoneNumber = "123456789"
        
        // Dodanie wniosków adopcyjnych
        let request1 = AdoptionRequest(context: context)
        request1.dateCreated = Date()
        request1.status = "Zatwierdzony"
        request1.user = user
        let pet1 = Pet(context: context)
        pet1.name = "Burek"
        pet1.breed = "Labrador"
        request1.pet = pet1
        
        let request2 = AdoptionRequest(context: context)
        request2.dateCreated = Date().addingTimeInterval(-86400) // Wczoraj
        request2.status = "Odrzucony"
        request2.user = user
        let pet2 = Pet(context: context)
        pet2.name = "Misia"
        pet2.breed = "Perski"
        request2.pet = pet2
        
        return UserAdoptionRequestsView().environment(\.managedObjectContext, context).environmentObject(AppState())
    }
}
