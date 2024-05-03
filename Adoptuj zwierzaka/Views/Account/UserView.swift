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
            Section(header: Text("Informacje o użytkowniku").font(.headline)) {
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                    Text("Imię: \(appState.userFirstName)")
                }
                HStack {
                    Image(systemName: "person.fill")
                        .foregroundColor(.gray)
                    Text("Nazwisko: \(appState.userSecondName)")
                }
                HStack {
                    Image(systemName: "envelope")
                        .foregroundColor(.gray)
                    Text("Email: \(appState.userEmail)")
                }
                HStack {
                    Image(systemName: "phone.fill")
                        .foregroundColor(.gray)
                    Text("Tel: \(appState.userPhoneNumber)")
                }
                HStack {
                    Image(systemName: "person.crop.circle.badge.checkmark")
                        .foregroundColor(.gray)
                    Text("Rola: \(appState.userRole == "user" ? "Użytkownik" : "Administrator")")
                }
            }
            .font(.subheadline)
            
            Section {
                Button(action: {
                    appState.logOut()
                }) {
                    Text("Wyloguj")
                        .foregroundColor(.red)
                }
                Button("Edytuj") {
                    // Akcja edycji profilu
                    print("Edytuj profil")
                }
                .foregroundColor(.blue)
            }
        }
        .navigationBarTitle("Panel użytkownika", displayMode: .inline)
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView().environmentObject(AppState())
    }
}
