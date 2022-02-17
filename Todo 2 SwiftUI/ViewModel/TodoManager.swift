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
    @Published private var fetchedResultsController: NSFetchedResultsController<TodoItem>
    @Published var isError : Bool = false
    @Published var errorMessage : String = ""
    @Published var hideCompletedItems : Bool
    @Published var areAllItemsCompleted : Bool = false
    
    //Initialize
    init (context: NSManagedObjectContext) {
        self.context = context
        hideCompletedItems = UserDefaults.standard.bool(forKey: "hideCompletedItems")
        fetchedResultsController = NSFetchedResultsController(fetchRequest: TodoItem.all, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        super.init()
        fetchedResultsController.delegate = self
        
        
        
        do {
            try fetchedResultsController.performFetch()
            guard let todoItems = fetchedResultsController.fetchedObjects else {
                return
            }
            self.todoItems = todoItems
            if todoItems.filter({ (item) in item.isCompleted == false}).isEmpty {
                areAllItemsCompleted = true
            }
            
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
            todo.isCompleted = false
            try todo.save()
            clearFields()
            areAllItemsCompleted = false
        } catch {
            presentError(errorDesc: error.localizedDescription)
        }
    }
    
    func deleteItem(at offsets: IndexSet) {
        offsets.forEach { index in
            let item = self.todoItems[index]
            do {
                try item.delete()
            } catch {
                self.presentError(errorDesc: error.localizedDescription)
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
        if let _ = todo.name {
            do {
                try todo.save()
                checkIfAllItemsAreCompleted()
            } catch {
                self.presentError(errorDesc: error.localizedDescription)
            }
        }
        
    }
    
    func updateSettings(value: Bool) {
        UserDefaults.standard.set(value, forKey: "hideCompletedItems")
    }
    
    private func checkIfAllItemsAreCompleted() {
        if todoItems.filter({ (item) in item.isCompleted == false}).isEmpty {
            areAllItemsCompleted = true
        } else {
            areAllItemsCompleted = false
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
