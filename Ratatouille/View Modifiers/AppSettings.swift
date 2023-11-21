//
//  AppSettings.swift
//  Ratatouille
//
//  Created by Jack Xia on 20/11/2023.
//

import Foundation

class AppSettings: ObservableObject {
    // Two-way binding object - that need to be instantiated for ownership of this object, typically at root level for dark mode.
    @Published var isDarkMode: Bool = false
}
