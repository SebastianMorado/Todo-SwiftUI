//
//  Todo_2_SwiftUIApp.swift
//  Todo 2 SwiftUI
//
//  Created by Sebastian Morado on 2/8/22.
//

import SwiftUI

@main
struct Todo_2_SwiftUIApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            let settingsManager = SettingsManager()
            MainView()
                .environmentObject(settingsManager)
                .environmentObject(TodoManager(context: persistenceController.container.viewContext))
        }
    }
}
