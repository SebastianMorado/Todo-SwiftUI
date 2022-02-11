//
//  BaseModel.swift
//  Todo 2 SwiftUI
//
//  Created by Sebastian Morado on 2/10/22.
//

import Foundation
import CoreData

protocol BaseModel {
    static var viewContext: NSManagedObjectContext { get }
    func save() throws
    func delete() throws
}

extension BaseModel where Self: NSManagedObject {
    static var viewContext: NSManagedObjectContext {
        PersistenceController.shared.container.viewContext
    }
    
    func save() throws {
        try Self.viewContext.save()
    }
    
    func delete() throws {
        Self.viewContext.delete(self)
        try save()
    }
}
