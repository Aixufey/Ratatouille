//
//  CustomFonts.swift
//  Ratatouille
//
//  Created by Jack Xia on 20/11/2023.
//

import Foundation
import UIKit
enum CustomFont: String {
    case ComicBold = "ComicNeue-Bold"
    case ComicBoldItalic = "ComicNeue-BoldItalic"
    case ComicRegular = "ComicNeue-Regular"
    case ComicItalic = "ComicNeue-Italic"
    case ComicLight = "ComicNeue-Light"
    case ComicLightItalic = "ComicNeue-LightItalic"

    var name: String {
        return self.rawValue
    }
}


extension UIFont {
    static func customFont(_ font: CustomFont, size: CGFloat) -> UIFont {
        if let customFont = UIFont(name: font.name, size: size) {
            return customFont
        } else {
            return UIFont.systemFont(ofSize: size)
        }
    }
}
