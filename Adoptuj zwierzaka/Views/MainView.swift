//
//  MainView.swift
//  Adoptuj zwierzaka
//
//  Created by Paweł Staniul on 21/04/2024.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appState: AppState
    @State private var fadeInOnAppear = false
    
    var body: some View {
        NavigationView {
            VStack(alignment: .center) {
                Text("Adoptuj Zwierzaka!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .opacity(fadeInOnAppear ? 1 : 0)
                    .animation(Animation.easeIn.delay(0.5), value: fadeInOnAppear)
                    .padding()
                
                Image("Logo")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 400)
                    .clipped()
                    .cornerRadius(20)
                    .padding(.horizontal, 5.0)
                    .opacity(fadeInOnAppear ? 1 : 0)
                    .animation(Animation.easeIn.delay(1), value: fadeInOnAppear)
                
                HStack {
                    Spacer() // Dodaje elastyczną przestrzeń przed tekstem
                    Text("Znajdź swojego nowego przyjaciela. Podaruj nowy dom potrzebującym zwierzakom.")
                        .font(.title2)
                        .foregroundColor(.white)
                        .opacity(fadeInOnAppear ? 1 : 0)
                        .animation(Animation.easeIn.delay(1.5), value: fadeInOnAppear)
                        .padding(.vertical)
                    Spacer() // Dodaje elastyczną przestrzeń po tekście
                }
                .frame(maxWidth: .infinity) // Rozciąga HStack na całą dostępną szerokość
                
                
                
                
                Spacer()
                
                // Ujednolicone przyciski
                Group {
                    NavigationLink(destination: LoginView()) {
                        Text("Zaloguj się")
                    }
                    NavigationLink(destination: RegistrationView()) {
                        Text("Zarejestruj się")
                    }
                }
                .font(.headline)
                .padding()
                .frame(maxWidth: .infinity)  // Zapewnia, że przyciski są tej samej szerokości
                .background(appButtonColor)
                .foregroundColor(.white)
                .cornerRadius(10)
                .opacity(fadeInOnAppear ? 1 : 0)
                .animation(Animation.easeIn.delay(2), value: fadeInOnAppear)
                
                Spacer()
            }
            .padding(.horizontal, 20.0)
            .appBackground()
            .onAppear {
                fadeInOnAppear = true
            }
        }
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(AppState())
    }
}

