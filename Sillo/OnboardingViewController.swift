//
//  OnboardingViewController.swift
//  Sillo
//
//  Created by Eashan Mathur on 1/2/21.
//

import Foundation

import UIKit


class OnboardingViewController: UIViewController {
    
    let signUpLabel: UILabel = {
        let label = UILabel()
        label.font = Font.bold(40)
        return label
    }()
    
    let onboardingImage = UIImageView()
    
    let numberImage: UIImageView = {
        let numberImage = UIImageView()
        numberImage.contentMode = .scaleAspectFit
        return numberImage
    }()
    
    let descriptionLabel: UILabel = {
        let descriptionLabel = UILabel()
        descriptionLabel.font = Font.medium(28)
        descriptionLabel.textColor = .black
        descriptionLabel.numberOfLines = 0
        descriptionLabel.heightAnchor.constraint(equalToConstant: 45).isActive = true
        descriptionLabel.textAlignment = .center
        return descriptionLabel
    }()
    
    
    init(_bearImage: UIImage, _descriptionText: String) {
        onboardingImage.image = _bearImage
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
        stack.spacing = 65
        view.addSubview(stack)

        
        stack.addArrangedSubview(descriptionLabel)
        stack.addArrangedSubview(onboardingImage)
        
        onboardingImage.contentMode = .scaleAspectFit
        onboardingImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
//        bearImage.heightAnchor.constraint(equalToConstant: 500).isActive = true
        onboardingImage.widthAnchor.constraint(equalToConstant: 500).isActive = true
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150).isActive = true
        stack.leftAnchor.constraint(equalTo: view.layoutMarginsGuide.leftAnchor).isActive = true
        stack.rightAnchor.constraint(equalTo: view.layoutMarginsGuide.rightAnchor).isActive = true
    }

}
