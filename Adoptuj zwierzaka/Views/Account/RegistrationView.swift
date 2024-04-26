//
//  RegistrationView.swift
//  Adoptuj zwierzaka
//
//  Created by Paweł Staniul on 23/04/2024.
//

import SwiftUI

struct RegistrationView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var registrationFailed = false
    @State private var errorMessage = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                SecureField("Hasło", text: $password)
                SecureField("Potwierdź hasło", text: $confirmPassword)
                if registrationFailed {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                Button("Zarejestruj się") {
                    registerUser()
                }
            }
            .navigationBarTitle("Rejestracja")
        }
    }
    
    func registerUser() {
        if !isValidEmail(email) {
            errorMessage = "Nieprawidłowy format adresu e-mail."
            registrationFailed = true
        } else if password != confirmPassword {
            errorMessage = "Hasła nie pasują do siebie."
            registrationFailed = true
        } else if email.isEmpty || password.isEmpty {
            errorMessage = "Wszystkie pola muszą być wypełnione."
            registrationFailed = true
        } else {
            let newUser = User(context: viewContext)
            newUser.email = email
            newUser.password = password

            do {
                try viewContext.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                errorMessage = "Nie udało się zapisać użytkownika: \(error.localizedDescription)"
                registrationFailed = true
            }
        }
    }
    
    
    func isValidEmail(_ email: String) -> Bool {
        let emailPattern = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailPattern)
        return emailPred.evaluate(with: email)
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
