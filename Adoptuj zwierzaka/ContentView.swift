//
//  ContentView.swift
//  Adoptuj zwierzaka
//
//  Created by Paweł Staniul on 21/04/2024.
//

import SwiftUI
import CoreData

// Ujednolicony kolor przycisków
public let appButtonColor = Color.black

struct ContentView: View {
    @EnvironmentObject var appState: AppState

    var body: some View {
        appState.selectedView
    }
}

extension View {
    func appBackground() -> some View {
        self
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(
                LinearGradient(gradient: Gradient(colors: [Color.white, Color.brown]), startPoint: .top, endPoint: .bottom)
                    .edgesIgnoringSafeArea(.all)
            )
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView().environmentObject(AppState())
    }
}
