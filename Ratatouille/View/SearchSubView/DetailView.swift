//
//  DetailView.swift
//  Ratatouille
//
//  Created by Jack Xia on 26/11/2023.
//

import SwiftUI

/**
 Observe id and transform accordingly
 */
struct DetailView: View {
    var forId: String
    @ObservedObject var usingModel: DetailViewModel
    @State private var isInstruction: Bool = false
    @State private var isIngredient: Bool = false

    var body: some View {
        VStack {
            if let details = usingModel.itemDetails[forId]?.meals?.first {
                List {
                    LazyHStack {
                        Text("Meal ID \(details.idMeal) - \(details.strArea)")
                    }
                    Section(header: HStack {
                        Text("Instructions")
                        Image(systemName: "\(isInstruction ? "arrow.down.forward.and.arrow.up.backward":"arrow.up.backward.and.arrow.down.forward")")
                    }.onTapGesture {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            self.isInstruction.toggle()
                        }
                    }) {
                        if isInstruction {
                            Text(details.strInstructions)
                        }
                    }
                    Section(header: HStack {
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
                            }
                        }
                    }
                }
            } else {
                ProgressView()
            }
        }
        .onAppear {
            Task {
                print("ID inside DV: \(forId)")
                await usingModel.getDetails(for: forId, using: APIService.shared)
            }
        }
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        // Create a Meal instance containing the sample MealItems
        let dummyMealItem = MealItems(
                    idMeal: "52834",
                    strMeal: "Beef stroganoff",
                    strCategory: "Beef",
                    strArea: "Russian",
                    strInstructions: "Heat the olive oil in a non-stick frying pan then add the sliced onion and cook on a medium heat until completely softened, so around 15 mins, adding a little splash of water if they start to stick at all. Crush in the garlic and cook for a 2-3 mins further, then add the butter. Once the butter is foaming a little, add the mushrooms and cook for around 5 mins until completely softened. Season everything well, then tip onto a plate.\r\nTip the flour into a bowl with a big pinch of salt and pepper, then toss the steak in the seasoned flour. Add the steak pieces to the pan, splashing in a little oil if the pan looks particularly dry, and fry for 3-4 mins, until well coloured.",
                    strMealThumb: "https://www.themealdb.com/images/media/meals/svprys1511176755.jpg",
                    strYoutube: "https://www.youtube.com/watch?v=PQHgQX1Ss74",
                    ingredients: ["Olive Oil", "Onions"]
                )
        let dummy = Meal(meals: [dummyMealItem])
        DetailView(forId: dummyMealItem.idMeal, usingModel: DetailViewModel())
    }
}
