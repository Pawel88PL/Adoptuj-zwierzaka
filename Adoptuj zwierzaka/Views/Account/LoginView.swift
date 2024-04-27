//
//  LoginView.swift
//  Adoptuj zwierzaka
//
//  Created by Paweł Staniul on 23/04/2024.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var appState: AppState
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        entity: User.entity(),
        sortDescriptors: []
    ) var users: FetchedResults<User>
    
    @State private var email = ""
    @State private var password = ""
    @State private var loginFailed = false
    @State private var showAlert = false
    
    var body: some View {
        NavigationView {
            Form {
                TextField("Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .disableAutocorrection(true)
                    .fixedSize(horizontal: false, vertical: true)
                SecureField("Hasło", text: $password)
                if loginFailed {
                    Text("Niepoprawna nazwa użytkownika lub hasło")
                        .foregroundColor(.red)
                }
                Button("Zaloguj się") {
                    login()
                }
            }
            .navigationBarTitle("Logowanie")
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Sukces!"), message: Text(appState.alertMessage ?? ""), dismissButton: .default(Text("OK"), action: {
                    // Reset alert message after showing
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
    
    func login() {
        loginFailed = false  // Resetowanie stanu błędu
        let matchingUser = users.first { $0.email == email && $0.password == password }
        
        if matchingUser != nil {
            appState.logIn()  // Używanie metody logIn() z AppState
        } else {
            loginFailed = true
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AppState())
    }
}
