//
//  RatatouilleApp.swift
//  Ratatouille
//
//  Created by Jack Xia on 13/11/2023.
//

import SwiftUI

@main
struct RatatouilleApp: App {
    // Owner of this object throughout the lifecycle - instantiate and provide as context to children
    @StateObject private var settings = AppSettings()
    
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .font(.custom(CustomFont.ComicBoldItalic.name, size: 20))
                .environmentObject(settings)
                .preferredColorScheme(settings.isDarkMode ? .dark : .light)
        }
    }
}
