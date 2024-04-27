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
    
    @State private var showingAddPetView = false
    @State private var showAlert = false
    
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
            .listStyle(PlainListStyle())
            .navigationTitle("Zwierzaki")
            .navigationBarItems(
                leading: logoutButton(),
                trailing: addButton()
            )
            .sheet(isPresented: $showingAddPetView) {
                AddPetView().environment(\.managedObjectContext, viewContext)
            }
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Sukces"), message: Text(appState.alertMessage ?? "Zalogowano pomyślnie"), dismissButton: .default(Text("OK"), action: {
                    // Zresetowanie alertu po wyświetleniu
                    appState.alertMessage = nil
                }))
            }
            .onAppear {
                if let message = appState.alertMessage, !message.isEmpty {
                    showAlert = true
                }
            }
        }
    }
    
    private func logoutButton() -> some View {
        Button("Wyloguj") {
            appState.logOut()
        }
        .foregroundColor(.red)
        .font(.headline)
    }
    
    private func addButton() -> some View {
        Button(action: {
            showingAddPetView = true
        }) {
            Image(systemName: "plus")
                .imageScale(.large)
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
            if let imageData = pet.image, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 70, height: 70)
                    .cornerRadius(35)
                    .clipped()
            }
            VStack(alignment: .leading) {
                Text(pet.name ?? "Nieznany")
                    .font(.headline)
                Text("Rasa: \(pet.breed ?? "Nieznana")")
                    .font(.subheadline)
            }
            .padding(.leading, 8)
            Spacer()
        }
    }
}
