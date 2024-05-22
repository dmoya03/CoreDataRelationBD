//
//  CoreDataTwoApp.swift
//  CoreDataTwo
//
//  Created by Daniel Moya on 9/5/24.
//

import SwiftUI

@main
struct CoreDataTwoApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
