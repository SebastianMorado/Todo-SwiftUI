//
//  TodoItem+Extensions.swift
//  Todo 2 SwiftUI
//
//  Created by Sebastian Morado on 2/10/22.
//

import Foundation
import CoreData

extension TodoItem: BaseModel {
    
    static var all: NSFetchRequest<TodoItem> {
        let request = TodoItem.fetchRequest()
        let dateSort = NSSortDescriptor(key:"timestamp", ascending:true)
        request.sortDescriptors = [dateSort]
        return request
    }
}
