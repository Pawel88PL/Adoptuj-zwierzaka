//
//  MainView.swift
//  Adoptuj zwierzaka
//
//  Created by Paweł Staniul on 21/04/2024.
//

import SwiftUI

struct MainView: View {
    @State private var fadeInOnAppear = false
    @State private var animateBackground = false

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

                Text("Znajdź swojego nowego przyjaciela.")
                    .font(.title2)
                    .foregroundColor(.white)
                    .opacity(fadeInOnAppear ? 1 : 0)
                    .animation(Animation.easeIn.delay(1.5), value: fadeInOnAppear)
                    .padding(.vertical)

                NavigationLink(destination: PetListView()) {
                    Text("Przeglądaj zwierzaki")
                        .font(.headline)
                        .padding()
                        .background(Color.green.opacity(0.85))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .opacity(fadeInOnAppear ? 1 : 0)
                        .animation(Animation.easeIn.delay(2), value: fadeInOnAppear)
                }

                Spacer()
            }
            .padding(.horizontal, 20.0)
            .appBackground()
            .navigationBarHidden(true)
            .onAppear {
                fadeInOnAppear = true
                animateBackground = true
            }
        }
    }
}
