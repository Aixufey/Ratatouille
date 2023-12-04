//
//  Images.swift
//  Ratatouille
//
//  Created by Jack Xia on 20/11/2023.
//

import Foundation
import SwiftUI

enum ImageAsset: String {
    case Remy = "remy"
    case Logo = "logo"
    case Moustache = "moustache"
    case Hat = "hat"
    case Chef = "chef"
    case ChefHat = "chef-hat"
    
    var name: Image{
        return Image(self.rawValue)
    }
}
