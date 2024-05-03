//
//  UserEditView.swift
//  Adoptuj zwierzaka
//
//  Created by Paweł Staniul on 03/05/2024.
//

import SwiftUI

struct UserEditView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var appState: AppState
    @ObservedObject var user: User
    
    @State private var firstName: String
    @State private var secondName: String
    @State private var email: String
    @State private var phoneNumber: String
    
    @State private var showAlert = false
    @State private var errorMessage = ""
    
    init(user: User) {
        self.user = user
        _firstName = State(initialValue: user.firstName ?? "")
        _secondName = State(initialValue: user.secondName ?? "")
        _email = State(initialValue: user.email ?? "")
        _phoneNumber = State(initialValue: user.phoneNumber ?? "")
    }
    
    var body: some View {
        Form {
            Section(header: Text("Edytuj informacje").font(.headline)) {
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                    TextField("Imię", text: $firstName)
                }
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                    TextField("Nazwisko", text: $secondName)
                }
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.gray)
                    TextField("Email", text: $email)
                }
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.gray)
                    TextField("Numer telefonu", text: $phoneNumber)
                }
                
                Button("Zapisz zmiany") {
                    UserManager.shared.editUser(
                        user: user,
                        email: email,
                        firstName: firstName,
                        secondName: secondName,
                        phoneNumber: phoneNumber,
                        context: viewContext
                    ) { result in
                        switch result {
                        case .success():
                            presentationMode.wrappedValue.dismiss()
                        case .failure(let error):
                            errorMessage = "Błąd zapisu: \(error.localizedDescription)"
                            showAlert = true
                        }
                    }
                }
                .foregroundColor(.blue)
            }
        }
        .navigationBarTitle("Edycja danych", displayMode: .inline)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Błąd"), message: Text(errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}

struct UserEditView_Previews: PreviewProvider {
    static var previews: some View {
        let context = PersistenceController.shared.container.viewContext
        let user = User(context: context)  // Przykładowy użytkownik do celów podglądu
        user.firstName = "Jan"
        user.secondName = "Kowalski"
        user.email = "jan@example.com"
        user.phoneNumber = "123456789"
        return UserEditView(user: user).environment(\.managedObjectContext, context)
    }
}
