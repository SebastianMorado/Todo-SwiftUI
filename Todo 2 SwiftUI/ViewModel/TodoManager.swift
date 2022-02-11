//
//  TodoManager.swift
//  Todo 2 SwiftUI
//
//  Created by Sebastian Morado on 2/8/22.
//

import Foundation
import CoreData

class TodoManager: NSObject, ObservableObject {
    
    private (set) var context: NSManagedObjectContext
    //For storing and displaying
    @Published var todoItems : [TodoItem] = [TodoItem]()
    private let fetchedResultsController: NSFetchedResultsController<TodoItem>
    @Published var isError : Bool = false
    @Published var errorMessage : String = ""
    
    //Initialize
    init (context: NSManagedObjectContext) {
        self.context = context
        fetchedResultsController = NSFetchedResultsController(fetchRequest: TodoItem.all, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        fetchedResultsController.delegate = self
        
        do {
            try fetchedResultsController.performFetch()
            guard let todoItems = fetchedResultsController.fetchedObjects else {
                return
            }
            self.todoItems = todoItems
            
        } catch {
            presentError(errorDesc: error.localizedDescription)
        }
    }
    
    //For adding new items
    @Published var name: String = ""
    @Published var priority: String = "Normal"
    let priorities = ["Low", "Normal", "High"]
    
    func save() {
        do {
            let todo = TodoItem(context: context)
            todo.name = name
            todo.priority = priority
            todo.id = UUID()
            todo.timestamp = Date()
            try todo.save()
            clearFields()
        } catch {
            presentError(errorDesc: error.localizedDescription)
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        DispatchQueue.main.async {
            offsets.forEach { index in
                let item = self.todoItems[index]
                do {
                    try item.delete()
                } catch {
                    self.presentError(errorDesc: error.localizedDescription)
                }
            }
        }
        
    }
    
    func clearFields() {
        self.name = ""
        self.priority = priorities[1]
    }
    
    private func presentError(errorDesc: String) {
        errorMessage = errorDesc
        isError = true
        
    }
    
    func updateItem(todo: TodoItem) {
        print("UPDATING")
        do {
            try todo.save()
        } catch {
            presentError(errorDesc: error.localizedDescription)
        }
    }
    
}

extension TodoManager: NSFetchedResultsControllerDelegate {
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        DispatchQueue.main.async {
            guard let todoItems = controller.fetchedObjects as? [TodoItem] else {
                return
            }
            
            self.todoItems = todoItems
        }
    }

}
