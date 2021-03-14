//
//  DesignableView.swift
//  VisitMacedoniaToday
//
//  Created by CP-02 on 27/07/18.
//  Copyright © 2018 CP-02. All rights reserved.
//

import UIKit

@IBDesignable
class DesignableView: UIView {
}

@IBDesignable
class DesignableButton: UIButton {
}

@IBDesignable
class DesignableLabel: UILabel {
}

@IBDesignable
class DesignableImage: UIImageView {
}

extension UIView {
    
    @IBInspectable
    var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }
    
    @IBInspectable
    var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
    
    @IBInspectable
    var shadowRadius: CGFloat {
        get {
            return layer.shadowRadius
        }
        set {
            layer.shadowRadius = newValue
        }
    }
    
    @IBInspectable
    var shadowOpacity: Float {
        get {
            return layer.shadowOpacity
        }
        set {
            layer.shadowOpacity = newValue
        }
    }
    
    @IBInspectable
    var shadowOffset: CGSize {
        get {
            return layer.shadowOffset
        }
        set {
            layer.shadowOffset = newValue
        }
    }
    
    @IBInspectable
    var shadowColor: UIColor? {
        get {
            if let color = layer.shadowColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.shadowColor = color.cgColor
            } else {
                layer.shadowColor = nil
            }
        }
    }
}
/*extension UIView {

    /* Constraint creation conveniences. See NSLayoutAnchor.h for details.
     */
    open var leadingAnchor: NSLayoutXAxisAnchor { get }

    open var trailingAnchor: NSLayoutXAxisAnchor { get }

    open var leftAnchor: NSLayoutXAxisAnchor { get }

    open var rightAnchor: NSLayoutXAxisAnchor { get }

    open var topAnchor: NSLayoutYAxisAnchor { get }

    open var bottomAnchor: NSLayoutYAxisAnchor { get }

    open var widthAnchor: NSLayoutDimension { get }

    open var heightAnchor: NSLayoutDimension { get }

    open var centerXAnchor: NSLayoutXAxisAnchor { get }

    open var centerYAnchor: NSLayoutYAxisAnchor { get }

    open var firstBaselineAnchor: NSLayoutYAxisAnchor { get }

    open var lastBaselineAnchor: NSLayoutYAxisAnchor { get }
}*/

class ScaledHeightImageView: UIImageView {
    
    override var intrinsicContentSize: CGSize {
        
        if let myImage = self.image {
            let myImageWidth = myImage.size.width
            let myImageHeight = myImage.size.height
            let myViewWidth = self.frame.size.width
            
            let ratio = myViewWidth/myImageWidth
            let scaledHeight = myImageHeight * ratio
            
            return CGSize(width: myViewWidth, height: scaledHeight)
        }
        
        return CGSize(width: -1.0, height: -1.0)
    }
    
}
