//
//  LoadingViewController.swift
//  Sillo
//
//  Created by William Loo on 3/6/21.
//


import Foundation
import UIKit

//https://www.advancedswift.com/loading-overlay-view-fade-in-swift/
class LoadingViewController: UIViewController {
    
    
    //MARK: loading indicator
    var loadingActivityIndicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        
        indicator.style = .large
        indicator.color = Color.buttonClickable
            
        // The indicator should be animating when
        // the view appears.
        indicator.startAnimating()
            
        // Setting the autoresizing mask to flexible for all
        // directions will keep the indicator in the center
        // of the view and properly handle rotation.
        indicator.autoresizingMask = [
            .flexibleLeftMargin, .flexibleRightMargin,
            .flexibleTopMargin, .flexibleBottomMargin
        ]
            
        return indicator
    }()
    
    //MARK: bllur effect
    var blurEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .light)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.alpha = 0.1
        
        // Setting the autoresizing mask to flexible for
        // width and height will ensure the blurEffectView
        // is the same size as its parent view.
        blurEffectView.autoresizingMask = [
            .flexibleWidth, .flexibleHeight
        ]
        
        return blurEffectView
    }()
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        // View Configuration
        super.viewDidLoad()
        view.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        
        //FUTURE: change to systemwide bg color
        //view.backgroundColor = UIColor.systemBackground.withAlphaComponent(0.1)
        
        // Add the blurEffectView with the same
        // size as view
        blurEffectView.frame = self.view.bounds
        view.insertSubview(blurEffectView, at: 0)
        
        // Add the loadingActivityIndicator in the
        // center of view
        loadingActivityIndicator.center = CGPoint(
            x: view.bounds.midX,
            y: view.bounds.midY
        )
        view.addSubview(loadingActivityIndicator)
    }
    
}
