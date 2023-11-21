//
//  SettingsView.swift
//  Ratatouille
//
//  Created by Jack Xia on 20/11/2023.
//

import SwiftUI


struct SettingsView: View {
    // Accessing instance of StateObject
    @EnvironmentObject private var settings: AppSettings
    
    var body: some View {
        
        NavigationView {
            List {
                Section {
                    HStack {
                        Image(systemName: settings.isDarkMode ? "globe.central.south.asia" : "globe.central.south.asia.fill")
                        Button {
                            
                        } label: {
                            Text("Redigere landområder")
                        }
                    }
                    HStack {
                        Image(systemName: settings.isDarkMode ? "doc.plaintext" : "doc.plaintext.fill")
                        Button {
                            
                        } label: {
                            Text("Redigere kategorier")
                        }
                    }
                    HStack {
                        Image(systemName: settings.isDarkMode ? "carrot" : "carrot.fill")
                        Button {
                            
                        } label: {
                            Text("Redigere ingredienser")
                        }
                    }
                }
                .imageScale(.large)
                Section {
                    HStack {
                        Image(systemName: settings.isDarkMode ? "moon.stars.fill" : "sun.max.fill")
                        Toggle(isOn: $settings.isDarkMode) {
                            Text("Dark mode")
                        }
                    }
                }
                Section {
                    HStack {
                        Image(systemName: settings.isDarkMode ? "archivebox" : "archivebox.fill")
                        Button {
                            
                        } label: {
                            Text("Administrere arkiv")
                        }

                    }
                }
            } // List
            .navigationTitle("Innstillinger")
        } // NavView
        .preferredColorScheme(settings.isDarkMode ? .dark : .light)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        let settings = AppSettings()
        SettingsView()
            .environmentObject(settings)
    }
}
