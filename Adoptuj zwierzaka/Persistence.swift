//
//  Persistence.swift
//  Adoptuj zwierzaka
//
//  Created by Paweł Staniul on 21/04/2024.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let petsData = [
            ("Krakers", "Golden Retriever", "Pies"),
            ("Marycha", "Kot brytyjski", "Kot")
        ]
        
        for (name, breed, type) in petsData {
            let newPet = Pet(context: viewContext)
            newPet.name = name
            newPet.breed = breed
            newPet.animalType = type
            newPet.isAvailable = true
            newPet.age = Int16.random(in: 1...10)
            newPet.descriptions = "Opis dla \(name)"
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()
    
    
    let container: NSPersistentCloudKitContainer
    
    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Adoptuj_zwierzaka")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
