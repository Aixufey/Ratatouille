//
//  SettingsRowView.swift
//  Ratatouille
//
//  Created by Jack Xia on 21/11/2023.
//

import SwiftUI

// Protocol to get Model's field name - Conforming to safe generic
protocol NameProvider {
    var getField: String { get }
}
struct SettingsRowView<T: NameProvider>: View {
    let data: T
    init(for data: T) {
        self.data = data
    }
    var body: some View {
        HStack {
            ZStack {
                Circle()
                    .frame(width: 80)
                    .foregroundColor(Color.clear)
                    .background(
                        LinearGradient(gradient: Gradient(colors: [.blue, .black]), startPoint: .topLeading, endPoint: .bottomTrailing)
                    )
                    .clipShape(Circle())
                
                Text(Help.findFirstCharacter(of: data.getField))
                    .foregroundColor(.white)
                    .font(.system(size: 35))
            }
            Text(data.getField)
        }
    }
}

struct SettingsRowView_Previews: PreviewProvider {
    static var previews: some View {
        let dummy = AllCategories(idCategory: "1", strCategory: "example")
        SettingsRowView(for: dummy).environmentObject(AppSettings().self)
    }
}
