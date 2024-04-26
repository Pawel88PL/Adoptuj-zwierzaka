//
//  PetListView.swift
//  Adoptuj zwierzaka
//
//  Created by Paweł Staniul on 21/04/2024.
//

import SwiftUI
import CoreData

struct PetListView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pet.name, ascending: true)],
        animation: .default)
    private var pets: FetchedResults<Pet>
    
    @State private var showingAddPetView = false  // Kontroluje pokazanie widoku dodawania
    
    var body: some View {
        NavigationView {
            List {
                ForEach(pets) { pet in
                    NavigationLink(destination: PetDetailView(pet: pet)) {
                        PetRow(pet: pet)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .navigationTitle("Zwierzaki")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) { Button("Wyloguj") {
                    appState.logOut()
                }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingAddPetView = true
                    }) {
                        Label("Dodaj zwierzaka", systemImage: "plus")
                    }
                }
            }
            .sheet(isPresented: $showingAddPetView) {
                AddPetView().environment(\.managedObjectContext, viewContext)
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { pets[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

struct PetRow: View {
    var pet: Pet
    
    var body: some View {
        HStack {
            // Miniaturka obrazu, jeśli dostępna
            if let imageData = pet.image, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()  // Pozwala na zmianę rozmiaru obrazu
                    .scaledToFill()  // Utrzymuje proporcje obrazu
                    .frame(width: 50, height: 50)  // Określa rozmiar miniatury
                    .cornerRadius(25)  // Tworzy okrągłą miniaturkę
                    .clipped()  // Przycina obraz do ramki
            }
            
            VStack(alignment: .leading) {
                Text(pet.name ?? "Nieznany")
                    .font(.headline)
                Text("Rasa: \(pet.breed ?? "Nieznana")")
                    .font(.subheadline)
            }
            .padding(.leading, 8)  // Dodaje odstęp między obrazem a tekstem
            
            Spacer()
        }
    }
}
