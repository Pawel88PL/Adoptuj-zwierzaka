//
//  RegistrationView.swift
//  Adoptuj zwierzaka
//
//  Created by Paweł Staniul on 23/04/2024.
//

import SwiftUI
import CoreData

struct RegistrationView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @EnvironmentObject var appState: AppState
    @State private var email = ""
    @State private var firstName = ""
    @State private var secondName = ""
    @State private var phoneNumber = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var registrationFailed = false
    @State private var errorMessage = ""
    @FocusState private var emailFieldFocused: Bool
    
    var body: some View {
        NavigationView {
            Form {
                VStack(spacing: 15) {
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.gray)
                        TextField("Email", text: $email)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disableAutocorrection(true)
                            .focused($emailFieldFocused)
                    }
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
                        Image(systemName: "phone.fill")
                            .foregroundColor(.gray)
                        TextField("Numer telefonu", text: $phoneNumber)
                            .keyboardType(.phonePad)
                            .disableAutocorrection(true)
                    }
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                        SecureField("Hasło", text: $password)
                    }
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                        SecureField("Potwierdź hasło", text: $confirmPassword)
                    }
                    
                    if registrationFailed {
                        Text(errorMessage)
                            .foregroundColor(.red)
                            .transition(.slide)
                    }
                }
                .padding(.vertical)
                
                Button("Zarejestruj się") {
                    registerUser()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(appButtonColor)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            .navigationBarTitle("Rejestracja", displayMode: .inline)
            .onAppear {
                self.emailFieldFocused = true
            }
        }
    }
    
    func registerUser() {
        registrationFailed = false
        guard password == confirmPassword, !email.isEmpty, !password.isEmpty, !firstName.isEmpty, !secondName.isEmpty, !phoneNumber.isEmpty else {
            registrationFailed = true
            errorMessage = "Wszystkie pola muszą być wypełnione i hasła muszą być takie same."
            return
        }
        
        UserManager.shared.registerUser(
            email: email,
            firstName: firstName,
            secondName: secondName,
            phoneNumber: phoneNumber,
            password: password,
            context: viewContext
        ) { result in
            switch result {
            case .success(_):
                appState.registerUser()
            case .failure(let error):
                errorMessage = "Nie udało się zapisać użytkownika: \(error.localizedDescription)"
                registrationFailed = true
            }
        }
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView().environmentObject(AppState())
    }
}
