//
//  RatatouilleApp.swift
//  Ratatouille
//
//  Created by Jack Xia on 13/11/2023.
//

import SwiftUI

@main
/**
 SwiftUI: class may conform to ObserableObject' protocol for creating complex objects i.e. generics - The usage of generics was arbitrary choice, could have explicit create an API function to conform to each Model.
 1. Create a class of protocol ObservableObject
 2. Provide it across app like a context
 3. Access it in Views using annotation  `@EnvironmentObject` Views does not need initialiser to access it.
 
 Note: SwiftUI vs React
 One-way binding -> Setter e.g. @State var input  ==  [input, setInput]useState
 Two-way binding -> Access e.g  input OR binding wrapper $input.wrappedValue == input
 
 Uplifting a state is always tricky, wished I knew this earlier in SwiftUI
 Case: Child uplift a state by using closure callback, using @escape to assert this callback outlives owner. Closures was initially used in extracted SheetView that uplifted some states back to SearchView.
 Issue: Too cumbersome and props drilling.
 Alternative: In a direct parent-child relation we can utilise `@Binding` to alter parent's `@State`
 E.g.:
 Parent: @State var myValue: String   -> Passing into Child constructor $myValue
 Child: @Binding var current: String    -> Bind to Parent init(_ current: Binding<String>)
 */
struct RatatouilleApp: App {
    // Owner of this object throughout the lifecycle - instantiate and provide as context to children
    @StateObject private var settings = AppSettings()
    @StateObject private var unifiedModelData = UnifiedModelData()
    // Controller for CRUD on main thread
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
                .font(.custom(CustomFont.ComicBoldItalic.name, size: 20))
                .environmentObject(settings)
                .environmentObject(unifiedModelData)
                .preferredColorScheme(settings.isDarkMode ? .dark : .light)
        }
    }
}
