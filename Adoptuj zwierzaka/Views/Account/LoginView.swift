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
    @State private var showAlert = false
    @FocusState private var emailFieldFocused: Bool
    
    var body: some View {
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
                UserManager.shared.logIn(email: email, password: password, context: viewContext, appState: appState) { success in
                    if !success {
                        loginFailed = true
                    }
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(appButtonColor)
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
            self.emailFieldFocused = true
            // Sprawdzenie, czy jest ustawiona wiadomość alertu
            if let message = appState.alertMessage, !message.isEmpty {
                showAlert = true
            }
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView().environmentObject(AppState())
    }
}
