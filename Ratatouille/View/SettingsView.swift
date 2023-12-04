//
//  SettingsView.swift
//  Ratatouille
//
//  Created by Jack Xia on 20/11/2023.
//

import SwiftUI


struct SettingsView: View {
    // Accessing instance of StateObject
    @Environment(\.managedObjectContext) private var moc
    @EnvironmentObject private var db: SharedDBData
    @EnvironmentObject private var settings: AppSettings
    @EnvironmentObject private var searchObj: SearchObject
    @State private var isSheet: Bool = false
    @State private var title = ""
    var body: some View {
        
        NavigationStack {
            List {
                // Miscellaneous
                Section {
                    NavigationLink(destination:
                                    SettingDetailView(for: $isSheet, title: "Landområder")
                        .onDisappear {
                            searchObj.resetResult()
                        }
                        .onAppear { self.title = "Landområder" }
                        .environmentObject(db)
                        .environmentObject(searchObj)) {
                            HStack {
                                Image(systemName: settings.isDarkMode ? "globe.central.south.asia" : "globe.central.south.asia.fill")
                                    .frame(width: 30, alignment: .center)
                                Text("Redigere landområder")
                            }
                        }.foregroundColor(.blue)
                        
                    
                    NavigationLink(destination:
                                    SettingDetailView(for: $isSheet, title: "Kategorier")
                        .onDisappear {
                            searchObj.resetResult()
                        }
                        .onAppear { self.title = "Kategorier" }
                        .environmentObject(db)
                        .environmentObject(searchObj)) {
                            HStack {
                                Image(systemName: settings.isDarkMode ? "doc.plaintext" : "doc.plaintext.fill")
                                    .frame(width: 30, alignment: .center)
                                Text("Redigere kategorier")
                            }
                        }.foregroundColor(.blue)
                        .onDisappear {searchObj.resetResult()}
                    
                    NavigationLink(destination:
                                    SettingDetailView(for: $isSheet, title: "Ingredienser")
                        .onDisappear {
                            searchObj.resetResult()
                        }
                        .onAppear { self.title = "Ingredienser" }
                        .environmentObject(db)
                        .environmentObject(searchObj)) {
                            HStack {
                                Image(systemName: settings.isDarkMode ? "carrot" : "carrot.fill")
                                    .frame(width: 30, alignment: .center)
                                Text("Redigere ingredienser")
                            }
                        }.foregroundColor(.blue)
                        .onDisappear {searchObj.resetResult()}
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
        .sheet(isPresented: $isSheet) {
            ExtractedView(isSheet: $isSheet, title: $title)
                .environmentObject(searchObj)
                .environmentObject(settings)
        }
        .preferredColorScheme(settings.isDarkMode ? .dark : .light)
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(SharedDBData(context: PersistenceController.shared.container.viewContext))
            .environmentObject(SearchObject())
            .environmentObject(AppSettings())
            .environmentObject(UnifiedModelData())
    }
}

struct ExtractedView: View {
    @EnvironmentObject private var searchObj: SearchObject
    @EnvironmentObject private var settings: AppSettings
    @Binding private var isSheet: Bool
    @Binding private var title: String
    init(isSheet: Binding<Bool> = .constant(false), title: Binding<String> = .constant("Not set")) {
        self._isSheet = isSheet
        self._title = title
    }
    var body: some View {
        VStack(alignment: .center) {
            HStack {
                Text("Avbryt")
                    .onTapGesture {
                        isSheet.toggle()
                    }
                    .foregroundColor(Color(.systemBlue))
                Spacer()
                Text(title)
                Spacer()
                Image(systemName: "magnifyingglass.circle.fill")
                    .font(.system(size: 35))
                    .onTapGesture {
                        
                    }
                    .foregroundColor(Color(.systemBlue))
            }
            .padding()
            Spacer()
            ZStack(alignment: .leading) {
                Text("Se alle \(title.lowercased())")
                    .onTapGesture {
                        Task {
                            isSheet.toggle()
                            do {
                                if title == "Landområder" {
                                    let result: AreaDTO = try await APIService.shared.fetchList(endpoint: .allAreas)
                                    searchObj.currentResult.area = result
                                    //print(searchObj.currentResult.area)
                                } else if title == "Kategorier" {
                                    let result: CategoryDTO = try await APIService.shared.fetchList(endpoint: .allCategories)
                                    searchObj.currentResult.category = result
                                    //print(searchObj.currentResult.category)
                                } else if title == "Ingredienser" {
                                    let result: IngredientDTO = try await APIService.shared.fetchList(endpoint: .allIngredients)
                                    searchObj.currentResult.ingredient = result
                                    //print(searchObj.currentResult.ingredient)
                                }
                            }
                        }
                    }
            }
            .frame(width: 300 , height: 60)
            .background(Rectangle().foregroundColor(Color(.systemGray5)))
            .cornerRadius(10)
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.gray, lineWidth: 2)
            )
            .padding(.bottom, 35)
        }
        .presentationDetents([.fraction(0.3)])
    }
}
