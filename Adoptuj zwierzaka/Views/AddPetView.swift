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
    @State private var showingImagePicker = false
    @State private var image: UIImage?
    
    // Atrybuty zwierzaka
    @State private var name: String = ""
    @State private var breed: String = ""
    @State private var age: Int = 0
    @State private var animalType: String = "Pies"
    @State private var descriptions: String = ""
    
    let animalTypes = ["Pies", "Kot"]
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Informacje o zwierzaku")) {
                    TextField("Imię", text: $name)
                    TextField("Rasa", text: $breed)
                    Stepper("Wiek: \(age)", value: $age, in: 0...30)
                    Picker("Typ zwierzęcia", selection: $animalType) {
                        ForEach(animalTypes, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    TextField("Opis", text: $descriptions)
                    if image != nil {
                        Image(uiImage: image!)
                            .resizable()
                            .scaledToFit()
                    }
                    Button("Wybierz zdjęcie"){
                        showingImagePicker = true
                    }
                }
                Button("Dodaj") {
                    // walidacja danych wejściowych
                    guard !name.isEmpty, !breed.isEmpty, !animalType.isEmpty, !descriptions.isEmpty else{
                        errorMessage = "Proszę usupełnić wszystkie dane zwierzaka"
                        showAlert = true
                        return
                    }
                    
                    addPet()
                    presentationMode.wrappedValue.dismiss()
                }
            }
            .navigationBarTitle("Dodaj zwierzaka", displayMode: .inline)
            .navigationBarItems(trailing: Button("Anuluj") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showAlert){
                Alert(title: Text("Błąd"), message: Text(errorMessage), dismissButton: .default(Text("Ok")))
            }
            .sheet(isPresented: $showingImagePicker){
                ImagePicker(selectedImage: $image)
            }
        }
    }
    
    private func addPet() {
        withAnimation {
            let newPet = Pet(context: viewContext)
            newPet.name = name
            newPet.breed = breed
            newPet.age = Int16(age)
            newPet.animalType = animalType
            newPet.descriptions = descriptions
            
            if let imageData = image?.jpegData(compressionQuality: 1.0) {
                newPet.image = imageData
            }
            
            
            do {
                try viewContext.save()
                // reset formularza
                name = ""
                breed = ""
                age = 0
                animalType = "Pies"
                descriptions = ""
                image = nil
            } catch {
                errorMessage = "Nie udało się zapisać zwierzaka: \(error.localizedDescription)"
                showAlert = true
            }
        }
    }
}

struct AddPetView_Previews: PreviewProvider {
    static var previews: some View {
        AddPetView().environmentObject(AppState())
    }
}
