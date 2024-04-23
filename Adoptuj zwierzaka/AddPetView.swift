//
//  AddPetView.swift
//  Adoptuj zwierzaka
//
//  Created by Paweł Staniul on 21/04/2024.
//

import SwiftUI

struct AddPetView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @State private var showAlert = false
    @State private var errorMessage = ""

    // Atrybuty zwierzaka
    @State private var name: String = ""
    @State private var breed: String = ""
    @State private var age: Int = 0
    @State private var descriptions: String = ""

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informacje o zwierzaku")) {
                    TextField("Imię", text: $name)
                    TextField("Rasa", text: $breed)
                    Stepper("Wiek: \(age)", value: $age, in: 0...30)
                    TextField("Opis", text: $descriptions)
                }
                Button("Dodaj") {
                    // walidacja danych wejściowych
                    guard !name.isEmpty, !breed.isEmpty else{
                        errorMessage = "Proszę usupełnić imię i rasę zwierzaka"
                        showAlert = true
                        return
                    }
                    
                    addPet()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .alert(isPresented: $showAlert){
                Alert(title: Text("Błąd"), message: Text(errorMessage), dismissButton: .default(Text("Ok")))
            }
            .navigationBarTitle("Dodaj zwierzaka", displayMode: .inline)
            .navigationBarItems(trailing: Button("Anuluj") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }

    private func addPet() {
        withAnimation {
            let newPet = Pet(context: viewContext)
            newPet.name = name
            newPet.breed = breed
            newPet.age = Int16(age)
            newPet.descriptions = descriptions
            do {
                try viewContext.save()
                // reset formularza
                name = ""
                breed = ""
                age = 0
                descriptions = ""
            } catch {
                errorMessage = "Nie udało się zapisać zwierzaka: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }
}
