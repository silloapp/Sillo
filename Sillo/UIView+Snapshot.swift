//
//  UIView+Snapshot.swift
//  Sillo
//
//  Created by Angelica Pan on 2/28/21.
//

import UIKit

extension UIView {

    // render the view within the view's bounds, then capture it as image
    func asImage() -> UIImage {
        if #available(iOS 10.0, *) {
            
            let renderer = UIGraphicsImageRenderer(bounds: bounds)
            return renderer.image { rendererContext in
                layer.render(in: rendererContext.cgContext)
            }
        } else {
            
            UIGraphicsBeginImageContext(self.frame.size)
            self.layer.render(in:UIGraphicsGetCurrentContext()!)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return UIImage(cgImage: image!.cgImage!)
        }
    }
}
