//
//  RatatouilleApp.swift
//  Ratatouille
//
//  Created by Jack Xia on 13/11/2023.
//

import SwiftUI

@main
struct RatatouilleApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .font(.custom(CustomFont.ComicBoldItalic.name, size: 20))
        }
    }
}
