//
//  PetDetailView.swift
//  Adoptuj zwierzaka
//
//  Created by Paweł Staniul on 21/04/2024.
//


import SwiftUI
import CoreData

struct PetDetailView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.managedObjectContext) var viewContext
    @Environment(\.presentationMode) var presentationMode
    var pet: Pet
    @State private var showAdoptionAlert = false
    
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
                    HStack{
                        Text(pet.name ?? "Nieznany")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Spacer()
                        
                        if pet.isAvailable == true {
                            Button("Adoptuj") {
                                self.showAdoptionAlert = true
                            }
                            .padding()
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .shadow(radius: 5)
                            .alert(isPresented: $showAdoptionAlert) {
                                Alert(
                                    title: Text("Potwierdzenie adopcji"),
                                    message: Text("Czy na pewno chcesz adoptować \(pet.name ?? "to zwierzę")?"),
                                    primaryButton: .default(Text("Tak"), action: {
                                        PetManager.adoptPet(pet: pet, currentUser: appState.currentUser, context: viewContext) { success, error in
                                            if success {
                                                presentationMode.wrappedValue.dismiss()
                                            } else {
                                                // Obsługa błędu
                                                print(error?.localizedDescription ?? "Nieznany błąd")
                                            }
                                        }
                                    }),
                                    secondaryButton: .cancel()
                                )
                            }
                        }
                    }
                    .padding(.horizontal)
                    
                    
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
    
    private func adoptPet() {
        // Utworzenie nowego wniosku adopcyjnego
        let adoptionRequest = AdoptionRequest(context: viewContext)
        adoptionRequest.dateCreated = Date() // Ustawienie aktualnej daty wniosku
        
        // Przypisanie zwierzęcia do wniosku
        adoptionRequest.pet = pet
        
        // Przypisanie użytkownika do wniosku
        if let currentUser = appState.currentUser {
            adoptionRequest.user = currentUser
        } else {
            print("Błąd: Brak zalogowanego użytkownika.")
            return // Zatrzymanie funkcji, jeśli nie ma zalogowanego użytkownika
        }
        
        // Ustawienie zwierzęcia jako niedostępnego
        pet.isAvailable = false
        
        do {
            // Zapisanie zmian w kontekście
            try viewContext.save()
            print("Wniosek adopcyjny został wysłany i zapisany.")
            self.presentationMode.wrappedValue.dismiss() // Powrót do poprzedniego widoku
        } catch {
            print("Nie udało się zapisać adopcji: \(error.localizedDescription)")
        }
    }
}

struct PetDetailView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let newPet = Pet(context: context)
        newPet.name = "Rex"
        newPet.breed = "Labrador"
        newPet.age = 3
        newPet.descriptions = "Przyjazny i energiczny pies"
        newPet.isAvailable = false
        
        // Załadowanie zdjęcia z assetów
        if let uiImage = UIImage(named: "EmptyList") {
            newPet.image = uiImage.jpegData(compressionQuality: 1.0)
        }
        
        return PetDetailView(pet: newPet)
            .environment(\.managedObjectContext, context)
            .environmentObject(AppState())
    }
}
