//
//  DetailView.swift
//  Ratatouille
//
//  Created by Jack Xia on 26/11/2023.
//

import SwiftUI
import Kingfisher
/**
 Observe id and transform accordingly on appear
 */
struct DetailView: View {
    @ObservedObject var usingModel: DetailViewModel
    @Binding private var currentResult: UnifiedModel
    @State private var isInstruction: Bool = false
    @State private var isIngredient: Bool = false
    private var forId: String
    init(forId: String, usingModel: DetailViewModel, with: Binding<UnifiedModel>) {
        self.forId = forId
        self.usingModel = usingModel
        self._currentResult = with
    }
    
    var body: some View {
        LazyVStack {
            // Fetch for full details using current id
            if let details = usingModel.itemDetails[forId]?.meals?.first {
                KFImage(URL(string: details.strMealThumb))
                    .resizable()
                    .scaledToFit()
                    .clipShape(Circle())
                    .frame(width: 250, height: 250)
                    .overlay(Circle().stroke(Color.customPrimary, lineWidth: 4))
                    .padding()
                    .padding(.top)
                
                Text(details.strMeal)
                    .font(.custom(CustomFont.ComicRegular.name, size: 30))
                Divider().padding()
                Text("Meal ID \(details.idMeal) - \(details.strArea)")
                    .padding()
                Divider().padding()
                LazyVStack {
                    Section(header: LazyHStack {
                        Text("Instructions")
                        Image(systemName: "\(isInstruction ? "arrow.down.forward.and.arrow.up.backward":"arrow.up.backward.and.arrow.down.forward")")
                    }.onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            self.isInstruction.toggle()
                        }
                    }) {
                        if isInstruction {
                            Text(details.strInstructions)
                                .padding()
                                .padding(.horizontal)
                        }
                    } // sect 1
                    .padding()
                    Divider().padding()
                    Section(header: LazyHStack {
                        Text("Ingredients")
                        Image(systemName: "\(isIngredient ? "arrow.down.forward.and.arrow.up.backward":"arrow.up.backward.and.arrow.down.forward")")
                    }.onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            self.isIngredient.toggle()
                        }
                    }) {
                        if isIngredient {
                            ForEach(details.ingredients, id: \.self) {
                                Text($0 ?? "")
                                    .padding(.top)
                            }
                        }
                    } // sect 2
                    .padding()
                    .padding(.bottom)
                }
            } else {
                ProgressView()
            }
        } // lazy Vstack
        .padding(.horizontal)
        .background(Color(.systemGray6))
        .cornerRadius(25)
        .onAppear {
            Task {
                //print("ID inside DV: \(forId)")
                await usingModel.getDetails(for: forId, using: APIService.shared)
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    struct Wrapper: View {
        @State private var unified = UnifiedModel(
            meal: Meal(meals: [
                MealItems(
                    idMeal: "52834",
                    strMeal: "Beef stroganoff",
                    strCategory: "Beef",
                    strArea: "Russian",
                    strInstructions: "Heat the olive oil in a non-stick frying pan then add the sliced onion and cook on a medium heat until completely softened, so around 15 mins, adding a little splash of water if they start to stick at all. Crush in the garlic and cook for a 2-3 mins further, then add the butter. Once the butter is foaming a little, add the mushrooms and cook for around 5 mins until completely softened. Season everything well, then tip onto a plate.\r\nTip the flour into a bowl with a big pinch of salt and pepper, then toss the steak in the seasoned flour. Add the steak pieces to the pan, splashing in a little oil if the pan looks particularly dry, and fry for 3-4 mins, until well coloured.",
                    strMealThumb: "https://www.themealdb.com/images/media/meals/svprys1511176755.jpg",
                    strYoutube: "https://www.youtube.com/watch?v=PQHgQX1Ss74",
                    ingredients: ["Olive Oil", "Onions"]
                )
            ])
        )
        var body: some View {
            DetailView(forId: unified.meal?.meals?.first?.idMeal ?? "", usingModel: DetailViewModel(), with: $unified)
        }
        
    }
    static var previews: some View {
        Wrapper()
    }
}
