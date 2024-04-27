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
    @FetchRequest(entity: User.entity(), sortDescriptors: []) var users: FetchedResults<User>
    
    @State private var email = ""
    @State private var password = ""
    @State private var loginFailed = false
    @State private var showAlert = false  // Kontrola wyświetlania alertu
    
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
                    }
                    HStack {
                        Image(systemName: "lock.fill")
                            .foregroundColor(.gray)
                        SecureField("Hasło", text: $password)
                    }

                    if loginFailed {
                        Text("Niepoprawna nazwa użytkownika lub hasło")
                            .foregroundColor(.red)
                            .transition(.slide)
                    }
                }
                .padding(.vertical)

                Button("Zaloguj się") {
                    login()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(10)
                .shadow(radius: 5)
            }
            .navigationBarTitle("Logowanie", displayMode: .inline)
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Sukces"), message: Text(appState.alertMessage ?? "Zarejestrowano pomyślnie"), dismissButton: .default(Text("OK"), action: {
                    // Zresetowanie alertu po wyświetleniu
                    appState.alertMessage = nil
                }))
            }
            .onAppear {
                // Sprawdzenie, czy jest ustawiona wiadomość alertu
                if let message = appState.alertMessage, !message.isEmpty {
                    showAlert = true
                }
            }
        }
    }
    
    func login() {
        loginFailed = false
        let matchingUser = users.first { $0.email == email && $0.password == password }
        
        if matchingUser != nil {
            appState.logIn()
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
