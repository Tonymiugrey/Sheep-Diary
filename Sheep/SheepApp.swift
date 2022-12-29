//
//  SheepApp.swift
//  Sheep
//
//  Created by miuGrey on 2022/12/29.
//

import SwiftUI

@main
struct SheepApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
