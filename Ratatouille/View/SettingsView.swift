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
                // Miscellaneous
                Section {
                    Button {
                    } label: {
                        HStack {
                            Image(systemName: settings.isDarkMode ? "globe.central.south.asia" : "globe.central.south.asia.fill")
                                .frame(width:30, alignment: .center)
                            Text("Redigere landområder")
                        }
                    }
                    .background(
                        NavigationLink {
                            LandAreasView()
                        } label: {
                            EmptyView()
                            // Hack to hide indications ">" lol
                        }.opacity(0)
                    )
                    Button {
                    } label: {
                        HStack {
                            Image(systemName: settings.isDarkMode ? "doc.plaintext" : "doc.plaintext.fill")
                                .frame(width: 30, alignment: .center)
                            Text("Redigere kategorier")
                        }
                    }
                    .background(
                        NavigationLink {
                            CategoriesView()
                        } label: {
                            EmptyView()
                        }.opacity(0)
                    )
                    Button {
                    } label: {
                        HStack {
                            Image(systemName: settings.isDarkMode ? "carrot" : "carrot.fill")
                                .frame(width: 30, alignment: .center)
                            Text("Redigere ingredienser")
                        }
                    }
                    .background(
                        NavigationLink {
                            IngredientsView()
                        } label: {
                            EmptyView()
                        }.opacity(0)
                    )
                }
                // Dark mode
                Section {
                    HStack {
                        Image(systemName: settings.isDarkMode ? "moon.stars.fill" : "sun.max.fill")
                            .frame(width: 30, alignment: .center)
                        Toggle(isOn: $settings.isDarkMode) {
                            Text("Dark mode")
                        }
                    }
                }
                // Administration
                Section {
                    Button {
                    } label: {
                        HStack {
                            Image(systemName: settings.isDarkMode ? "archivebox" : "archivebox.fill")
                                .frame(width: 30, alignment: .center)
                            Text("Administrere arkiv")
                            
                        }
                    }
                    .background(
                        NavigationLink {
                            ArchiveView()
                        } label: {
                            EmptyView()
                        }.opacity(0)
                    )
                }
            } // List
            .navigationTitle("Innstillinger")
            .imageScale(.large)
        } // NavView
        .preferredColorScheme(settings.isDarkMode ? .dark : .light)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(AppSettings().self)
            .environmentObject(UnifiedModelData().self)
    }
}
