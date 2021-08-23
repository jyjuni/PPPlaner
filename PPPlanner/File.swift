//
//  File.swift
//  PPPlanner
//
//  Created by JIN YIJIA on 8/23/21.
//

import Foundation
import CoreData

public func clearAllCoreData() {
    let entities = self.persistentContainer.managedObjectModel.entities
    entities.flatMap({ $0.name }).forEach(clearDeepObjectEntity)
}

private func clearDeepObjectEntity(_ entity: String) {
    let context = self.persistentContainer.viewContext

    let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
    let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)

    do {
        try context.execute(deleteRequest)
        try context.save()
    } catch {
        print ("There was an error")
    }
}

