//
//  Fonts.swift
//  Sillo
//
//  Created by Eashan Mathur on 1/2/21.
//

import Foundation
import UIKit

struct Font {
    static let regular = {
        (size: CGFloat) -> UIFont in
        return UIFont(name: "Apercu Regular", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static let bold = {
        (size: CGFloat) in
        UIFont(name: "Apercu Bold", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static let medium = {
        (size: CGFloat) in
        UIFont(name: "Apercu Medium", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static let mediumItalic = {
        (size: CGFloat) in
        return UIFont(name: "Apercu Medium Italic", size: size) ?? UIFont.systemFont(ofSize: size)
    }
    
    static let light = {
        (size: CGFloat) in
        UIFont(name: "Apercu Light", size: size) ?? UIFont.systemFont(ofSize: size)
    }
}
