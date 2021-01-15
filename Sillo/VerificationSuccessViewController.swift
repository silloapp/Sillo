//
//  VerificationSuccessViewController.swift
//  Sillo
//
//  Created by William Loo on 1/7/21.
//

import UIKit
//MARK: figma screen 168
class VerificationSuccessViewController: UIViewController {
    
    //MARK: init success image
    let successImage: UIImageView = {
        let image = UIImage(named: "onboardingSillo")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: init success label
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
        successImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        successImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70).isActive = true
        
        //MARK: success label
        view.addSubview(successLabel)
        successLabel.widthAnchor.constraint(equalToConstant: 140).isActive = true
        successLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
        successLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        successLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
