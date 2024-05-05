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
    
    @State private var selectedAnimalType: String = "All"
    @State private var pets: [Pet] = []
    @State private var showingAddPetView = false
    @State private var showAlert = false
    @State private var errorMessage: String = ""
    
    var body: some View {
        NavigationView {
            List {
                Picker("Typ zwierzęcia", selection: $selectedAnimalType) {
                    Text("Wszystkie").tag("All")
                    Text("Koty").tag("Kot")
                    Text("Psy").tag("Pies")
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .onChange(of: selectedAnimalType) { newValue in
                    loadPets()
                }
                if pets.isEmpty {
                    emptySection
                } else {
                    ForEach(pets, id: \.self) { pet in
                        NavigationLink(destination: PetDetailView(pet: pet)) {
                            PetRow(pet: pet)
                        }
                    }
                    .onDelete(perform: appState.userRole == "admin" ? deleteItems : nil)
                }
            }
            .listStyle(PlainListStyle())
            .padding(.top, 30)
            .navigationBarItems(
                leading: userViewButton(),
                trailing: addNewAnimalButton()
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
                loadPets()
            }
        }
    }
    
    private func loadPets() {
        let request: NSFetchRequest<Pet> = Pet.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Pet.name, ascending: true)]
        var predicates: [NSPredicate] = [NSPredicate(format: "isAvailable == YES")]
        if selectedAnimalType != "All" {
            predicates.append(NSPredicate(format: "animalType == %@", selectedAnimalType))
        }
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        do {
            pets = try viewContext.fetch(request)
        } catch {
            print("Failed to fetch pets: \(error)")
        }
    }
    
    
    private var emptySection: some View {
        VStack(alignment: .center) {
            Image("EmptyList")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()
                .cornerRadius(20)
                .padding(.horizontal, 5.0)
            
            Divider()
            
            Text("Aktualnie brak dostępnych zwierząt do adopcji.")
                .foregroundColor(.secondary)
                .padding(50)
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
    
    private func userViewButton() -> some View {
        NavigationLink(destination: UserView().environmentObject(appState)) {
            Text("Witaj \(appState.userFirstName)")
                .foregroundColor(.white)
                .padding(7)
                .frame(maxWidth: .infinity)
                .background(Color.black)
                .cornerRadius(10)
                .shadow(radius: 10, x: 0, y: 0)
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        if appState.userRole != "admin" {
            showAlert = true
            errorMessage = "Brak uprawnień do usunięcia zwierzęcia."
            return
        }
        
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
        let context = PersistenceController.preview.container.viewContext
        return PetListView()
            .environment(\.managedObjectContext, context)
            .environmentObject(AppState())
    }
}
