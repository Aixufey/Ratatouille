//
//  UnifiedModelData.swift
//  Ratatouille
//
//  Created by Jack Xia on 28/11/2023.
//

import Foundation
/**
 Publishing self as an observable object using a type struct of UnifiedModel
 When instantiated as singleton -> contains all the props.
 Any changes to the published variable is reactive.
 Usage is to instantiate self at entry of an app or using it judiciously
 Summarize: Wrapper for a struct conforming protocol
 */
class UnifiedModelData: ObservableObject {
    @Published var unifiedModel: UnifiedModel
    init(unifiedModel: UnifiedModel = UnifiedModel()) {
        self.unifiedModel = unifiedModel
    }
}
