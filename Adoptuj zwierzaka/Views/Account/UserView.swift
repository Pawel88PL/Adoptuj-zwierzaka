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
            userInfoSection
            actionsSection
        }
        .navigationBarTitle("Panel użytkownika", displayMode: .inline)
    }
    
    private var userInfoSection: some View {
        Section(header: Text("Informacje o użytkowniku").font(.headline)) {
            userDetailRow(label: "Imię", value: appState.userFirstName)
            userDetailRow(label: "Nazwisko", value: appState.userSecondName)
            userDetailRow(label: "Email", value: appState.userEmail)
            userDetailRow(label: "Tel", value: appState.userPhoneNumber)
            userDetailRow(label: "Rola", value: appState.userRole == "user" ? "Użytkownik" : "Administrator")
        }
    }
    
    private var actionsSection: some View {
        Section {
            if appState.userRole == "admin" {
                NavigationLink("Przejrzyj wnioski adopcyjne", destination: AdoptionRequestsView())
            }
            Button("Wyloguj") {
                appState.logOut()
            }
            .foregroundColor(.red)
            
            if let user = appState.currentUser {
                NavigationLink("Edytuj", destination: UserEditView(user: user).environmentObject(appState))
            }
        }
    }
    
    private func userDetailRow(label: String, value: String) -> some View {
        HStack {
            Image(systemName: "person.fill")
                .foregroundColor(.gray)
            Text("\(label): \(value)")
        }
    }
}

struct UserView_Previews: PreviewProvider {
    static var previews: some View {
        UserView().environmentObject(AppState())
    }
}
