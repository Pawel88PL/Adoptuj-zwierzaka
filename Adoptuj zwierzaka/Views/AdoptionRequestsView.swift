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
        predicate: nil
    ) var adoptionRequests: FetchedResults<AdoptionRequest>
    
    var body: some View {
        List(adoptionRequests, id: \.self) { request in
            if let pet = request.pet {
                NavigationLink(destination: PetDetailView(pet: pet)) {
                    requestEntryView(request)
                }
            }
        }
        .listStyle(PlainListStyle())
        .navigationTitle("Wnioski Adopcyjne")
    }
    
    private func requestEntryView(_ request: AdoptionRequest) -> some View {
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
            
            HStack {
                Button("Zatwierdź") {
                    updateRequestStatus(request, newStatus: "Zatwierdzony")
                }
                .buttonStyle(BorderlessButtonStyle())
                .foregroundColor(.green)
                
                Button("Odrzuć") {
                    updateRequestStatus(request, newStatus: "Odrzucony")
                }
                .buttonStyle(BorderlessButtonStyle())
                .foregroundColor(.red)
                
                Button("Usuń") {
                    deleteRequest(request)
                }
                .buttonStyle(BorderlessButtonStyle())
                .foregroundColor(.red)
            }
            
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(10)
        .shadow(radius: 2)
    }
    
    private func updateRequestStatus(_ request: AdoptionRequest, newStatus: String) {
        viewContext.perform {
            request.status = newStatus
            saveContext()
        }
    }
    
    private func deleteRequest(_ request: AdoptionRequest) {
        viewContext.delete(request)
        saveContext()
    }
    
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
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
        let context = PersistenceController.shared.container.viewContext
        
        // Stworzenie przykładowego kontekstu i danych
        let request = AdoptionRequest(context: context)
        request.dateCreated = Date()
        request.status = "Oczekujący"
        
        let pet = Pet(context: context)
        pet.name = "Fifi"
        pet.breed = "Pudel"
        pet.age = 5
        request.pet = pet
        
        let user = User(context: context)
        user.firstName = "Jan"
        user.secondName = "Kowalski"
        user.email = "jan@example.com"
        user.phoneNumber = "123456789"
        request.user = user
        
        return AdoptionRequestsView()
            .environment(\.managedObjectContext, context)
    }
}
