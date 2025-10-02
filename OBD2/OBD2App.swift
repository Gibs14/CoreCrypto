//
//  OBD2App.swift
//  OBD2
//
//  Created by Gibran Shevaldo on 24/09/25.
//

import SwiftUI

@main
struct OBD2App: App {
    // Ensure the Core Data context is ready when the app launches
    let persistenceController = CoreDataStack.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.persistentContainer.viewContext)
        }
    }
}
