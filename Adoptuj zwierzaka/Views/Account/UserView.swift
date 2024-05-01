//
//  UserView.swift
//  Adoptuj zwierzaka
//
//  Created by Paweł Staniul on 30/04/2024.
//

import SwiftUI

struct UserView: View {
    @EnvironmentObject var appState: AppState
    var body: some View {
        Form {
            Section(header: Text("Informacje o użytkowniku")) {
                Text("Imię: \(appState.userFirstName)")
                Text("Nazwisko: \(appState.userSecondName)")
                Text("Email: \(appState.userEmail)")
                Text("Tel: \(appState.userPhoneNumber)")
                if appState.userRole == "user" {
                    Text("Rola: Użytkownik")
                } else {
                    Text("Rola: \(appState.userRole)")
                }
                
            }
            
            Section {
                Button(action: {
                    appState.logOut()
                }) {
                    Text("Wyloguj")
                        .foregroundColor(.red)
                }
            }
        }
        .navigationBarTitle("Panel użytkownika")
        .navigationBarItems(trailing: Button("Edytuj") {
            // Akcja edycji profilu
            print("Edytuj profil")
        })
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView().environmentObject(AppState())
    }
}
