//
//  PetManager.swift
//  Adoptuj zwierzaka
//
//  Created by Paweł Staniul on 05/05/2024.
//

import Foundation
import CoreData

struct PetManager {
    static func adoptPet(pet: Pet, currentUser: User?, context: NSManagedObjectContext, completion: @escaping (Bool, Error?) -> Void) {
        let adoptionRequest = AdoptionRequest(context: context)
        adoptionRequest.dateCreated = Date() // Ustawienie aktualnej daty wniosku
        adoptionRequest.status = "Wniosek wysłany"
        adoptionRequest.pet = pet
        
        if let user = currentUser {
            adoptionRequest.user = user
        } else {
            completion(false, NSError(domain: "AdoptionError", code: 1001, userInfo: [NSLocalizedDescriptionKey: "Brak zalogowanego użytkownika."]))
            return
        }
        
        pet.isAvailable = false
        
        do {
            try context.save()
            completion(true, nil)
        } catch let error {
            completion(false, error)
        }
    }
}
