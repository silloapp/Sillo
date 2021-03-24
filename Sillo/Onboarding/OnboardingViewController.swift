//
//  OnboardingViewController.swift
//  Sillo
//
//  Created by Eashan Mathur on 1/2/21.

import Foundation

import UIKit


class OnboardingViewController: UIViewController {
    
    //MARK: Initialization of UI Elements
    
    let signUpLabel: UILabel = {
        let label = UILabel()
        label.font = Font.bold(40)
        return label
    }()
    
    let onboardingImage = UIImageView()
    
    
    let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = Font.regular(22)
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        descriptionLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        descriptionLabel.textAlignment = .center
        descriptionLabel.adjustsFontSizeToFitWidth = true
        return descriptionLabel
    }()
    
    
    //MARK: initialization and UI Setup
    
    init(_image: UIImage, _descriptionText: String) {
        onboardingImage.image = _image
        descriptionLabel.text = _descriptionText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCard()
    }
    
    func setupCard(){
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 15
        view.addSubview(stack)
        
        stack.addArrangedSubview(onboardingImage)
        stack.addArrangedSubview(descriptionLabel)
        
        onboardingImage.contentMode = .scaleAspectFit
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.widthAnchor.constraint(equalToConstant: 280).isActive = true
        stack.topAnchor.constraint(equalTo: view.topAnchor, constant: 200).isActive = true
        stack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 400/812).isActive = true
        
        
        onboardingImage.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
    }
}
