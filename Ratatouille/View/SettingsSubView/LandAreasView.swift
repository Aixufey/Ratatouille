//
//  LandAreasView.swift
//  Ratatouille
//
//  Created by Jack Xia on 21/11/2023.
//

import SwiftUI

struct LandAreasView: View {
    @EnvironmentObject private var settings: AppSettings
    var body: some View {
        List {
            ForEach(Area.dummy, id: \.hashValue) {area in
                NavigationLink(destination: CategoryDetailView()) {
                    SettingsRowView(for: area)
                }
            }
        }
        .imageScale(.large)
        .navigationTitle("Landområder")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Image(systemName: settings.isDarkMode ? "plus.circle" : "plus.circle.fill")
                        .frame(width: 60, alignment: .center)
                }
                
            }
        }
    }
}

struct LandAreasView_Previews: PreviewProvider {
    static var previews: some View {
        LandAreasView().environmentObject(AppSettings().self)
    }
}
