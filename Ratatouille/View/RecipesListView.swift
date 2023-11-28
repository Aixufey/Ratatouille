//
//  RecipesListView.swift
//  Ratatouille
//
//  Created by Jack Xia on 21/11/2023.
//

import SwiftUI

struct RecipesListView: View {
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
                        Text("Historikk")
                        Image(systemName: isShowing ? "arrow.down.and.line.horizontal.and.arrow.up":"arrow.up.and.line.horizontal.and.arrow.down")
                    }
                }.padding()
            }
            if isShowing {
                Divider().padding(.horizontal)
                Text("Søk historikk")
                LazyVStack {
                    SearchResultView(currentSearchResult: $unifiedData.unifiedModel)
                        .environmentObject(IsEmptyResult().self)
                        .environmentObject(AppSettings().self)
                        .environmentObject(UnifiedModelData().self)
                }.padding(.top)
            }
            Spacer()
            VStack {
                Image(systemName: "square.3.layers.3d.slash")
                    .imageScale(.large).font(.system(size: 65))
                Text("Ingen matoppskrifter")
            }
        }
    }
}

struct RecipesListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipesListView()
            .environmentObject(IsEmptyResult().self)
            .environmentObject(AppSettings().self)
            .environmentObject(UnifiedModelData().self)
    }
}
