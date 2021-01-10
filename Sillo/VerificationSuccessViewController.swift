//
//  VerificationSuccessViewController.swift
//  Sillo
//
//  Created by William Loo on 1/7/21.
//

import UIKit

class VerificationSuccessViewController: UIViewController {
    
    //MARK: instantiate success image
    let successImage: UIImageView = {
        let image = UIImage(named: "onboardingSillo")
        let imageView = UIImageView(image: image)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: instantiate success label
    let successLabel: UILabel = {
        let label = UILabel()
        label.font = Font.medium(28)
        label.text = "Success ✔"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .white
        //MARK: success image
        view.addSubview(successImage)
        successImage.widthAnchor.constraint(equalToConstant: 136).isActive = true
        successImage.heightAnchor.constraint(equalToConstant: 114).isActive = true
        successImage.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 111).isActive = true
        successImage.topAnchor.constraint(equalTo: view.topAnchor, constant: 292).isActive = true
        
        //MARK: success label
        view.addSubview(successLabel)
        successLabel.widthAnchor.constraint(equalToConstant: 140).isActive = true
        successLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
        successLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 122).isActive = true
        successLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 426).isActive = true
        
        
        
    }
}
