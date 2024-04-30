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
            .padding(.top, 30)
            .navigationBarItems(
                leading: logoutButton(),
                trailing: HStack {
                    addNewAnimalButton()
                    userViewButton()
                }
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
    
    private func addNewAnimalButton() -> some View {
        Group {
            if appState.userRole == "admin" {
                Button(action: {
                    showingAddPetView = true
                }) {
                    Label("Dodaj zwierzaka", systemImage: "plus")
                        .foregroundColor(.white)
                }
                .padding(7)
                .frame(maxWidth: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [Color.blue, Color.purple]), startPoint: .leading, endPoint: .trailing))
                .cornerRadius(10)
                .shadow(radius: 10, x: 0, y: 0)
            }
        }
    }
    
    private func logoutButton() -> some View {
        Button("Wyloguj") {
            appState.logOut()
        }
        .padding(7)
        .frame(maxWidth: .infinity)
        .background(Color.red)
        .foregroundColor(.white)
        .cornerRadius(10)
        .shadow(radius: 10, x: 0, y: 0)
    }
    
    private func userViewButton() -> some View {
        Button("Witaj \(appState.userFirstName)"){
            appState.userView()
        }
        .shadow(radius: 10, x: 0, y: 0)
        .padding(7)
        .frame(maxWidth: .infinity)
        .background(Color.black)
        .foregroundColor(Color.white)
        .cornerRadius(10)
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

struct PetListView_Previews: PreviewProvider {
    static var previews: some View {
        PetListView().environmentObject(AppState())
    }
}
