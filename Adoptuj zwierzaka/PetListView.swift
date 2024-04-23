//
//  PetListView.swift
//  Adoptuj zwierzaka
//
//  Created by Paweł Staniul on 21/04/2024.
//

import SwiftUI
import CoreData

struct PetListView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Pet.name, ascending: true)],
        animation: .default)
    private var pets: FetchedResults<Pet>
    
    @State private var showingAddPetView = false  // Kontroluje pokazanie widoku dodawania

    var body: some View {
        List {
            ForEach(pets) { pet in
                NavigationLink(destination: PetDetailView(pet: pet)) {
                    PetRow(pet: pet)
                }
            }
            .onDelete(perform: deleteItems)
        }
        .navigationTitle("Zwierzaki")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    showingAddPetView = true
                }) {
                    Label("Dodaj zwierzaka", systemImage: "plus")
                }
            }
        }
        .sheet(isPresented: $showingAddPetView) {
            AddPetView().environment(\.managedObjectContext, viewContext)
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { pets[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}
