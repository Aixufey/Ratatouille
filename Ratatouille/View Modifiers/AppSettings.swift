//
//  AppSettings.swift
//  Ratatouille
//
//  Created by Jack Xia on 20/11/2023.
//

import Foundation

class AppSettings: ObservableObject {
    @Published var isSplashView = true
    private let storedMode: String = "isDarkMode"
    // Two-way binding object - that need to be instantiated for ownership of this object, typically at root level for dark mode.
    // Published has to conform ObservableObject protocol to "observe" this object's state  -> Then instantiate with @StateObject to provide -> Finally, children may listen with @EnvironmentObject
    @Published var isDarkMode: Bool {
        didSet {
            UserDefaults.standard.set(isDarkMode, forKey: storedMode)
        }
    }
    
    init() {
        // initialise self from the cache
        self.isDarkMode = UserDefaults.standard.bool(forKey: storedMode)
    }
}
