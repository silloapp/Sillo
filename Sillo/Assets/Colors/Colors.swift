//
//  Colors.swift
//  Sillo
//
//  Created by Eashan Mathur on 1/5/21.
//

import Foundation
import UIKit

struct Color {
    
    static var gray: UIColor {
        return UIColor(displayP3Red: 224/255, green: 224/255, blue: 224/255, alpha: 1.0)
    }
    
    static var buttonClickable: UIColor {
        return UIColor(displayP3Red: 64/255, green: 102/255, blue: 234/255, alpha: 1.0)
    }
    
    static var buttonClickableUnselected: UIColor {
        return UIColor(displayP3Red: 64/255, green: 102/255, blue: 234/255, alpha: 0.5)
    }
    
    static var textSemiBlack: UIColor {
        return UIColor(displayP3Red: 51/255, green: 51/255, blue: 51/255, alpha: 1.0)
    }
    
    static var progressBlue: UIColor {
        return UIColor(displayP3Red: 62/255, green: 139/255, blue: 255/255, alpha: 1.0)
    }
    
    static var textFieldBackground = UIColor(red: CGFloat(249/255), green: CGFloat(249/255), blue: CGFloat(249/255), alpha: CGFloat(0.05))
}
