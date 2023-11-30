//
//  RecipesListView.swift
//  Ratatouille
//
//  Created by Jack Xia on 21/11/2023.
//

import SwiftUI

struct RecipesListView: View {
    @Environment(\.managedObjectContext) var moc
    @EnvironmentObject private var db: SharedDBData
    @FetchRequest(sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)], animation: .default) private var items: FetchedResults<Item>
    
    @EnvironmentObject private var unifiedData: UnifiedModelData
    @State private var isShowing: Bool = false
    @State private var isRecipes: Bool = false
    var body: some View {
        VStack {
            
            
            VStack {
                Image(ImageAsset.Logo.rawValue)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250)
                    .padding()
                HStack {
                    Spacer()
                    Button {
                        withAnimation(.easeInOut(duration: 0.13)) {
                            isShowing.toggle()
                        }
                    } label: {
                        Text(isShowing ? "Mine oppskrifter" : "Historikk")
                        Image(systemName: isShowing ? "lightswitch.on":"lightswitch.off")
                    }
                }.padding()
            }
            Spacer()
            Divider().padding(.horizontal)
            ScrollView {
                if isShowing {
                    Text("Søk historikk")
                    LazyVStack {
                        SearchResultView(currentSearchResult: $unifiedData.unifiedModel)
                            .environmentObject(IsEmptyResult().self)
                            .environmentObject(AppSettings().self)
                            .environmentObject(UnifiedModelData().self)
                    }.padding(.top)
                } else {
                    VStack(alignment: .center) {
                        Image(systemName: "square.3.layers.3d.slash")
                            .imageScale(.large).font(.system(size: 65))
                        Text("Ingen matoppskrifter")
                    }
                }
            } // ScrollView
            List {
                ForEach(db.meals, id: \.self) { meal in
                    Text(meal.wrappedName)
                }
            }
            
            
        } // VStack
    }
}

struct RecipesListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesListView()
            .environmentObject(SharedDBData(context: PersistenceController.shared.container.viewContext))
            .environmentObject(IsEmptyResult().self)
            .environmentObject(AppSettings().self)
            .environmentObject(UnifiedModelData().self)
    }
}
