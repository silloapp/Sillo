//
//  WelcomeToSilloViewController.swift
//  Sillo
//
//  Created by Eashan Mathur on 1/10/21.
//

import Foundation
import UIKit

class NoInvitesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavBar()
        setupView()
    }
    
    func configureNavBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    func setupView() {
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .leading
        stack.distribution = .fillProportionally
        stack.spacing = 25
        view.addSubview(stack)
            
        let welcomeHeader = UILabel()
        welcomeHeader.text = "Welcome to Sillo"
        welcomeHeader.font = Font.medium(dynamicFontSize(30))
        welcomeHeader.minimumScaleFactor = 0.5
        welcomeHeader.adjustsFontSizeToFitWidth = true
        welcomeHeader.textColor = Color.buttonClickable
        stack.addArrangedSubview(welcomeHeader)
        
        let image = UIImageView()
        image.image = UIImage(named: "no-associated-spaces")
        stack.addArrangedSubview(image)
        
        let descriptionText = UILabel()
        descriptionText.numberOfLines = 0
        descriptionText.text = "We don’t see any Sillo spaces associated with berkeley@gmail.com.\n\nYou can ask your team administrator for an invitation or try another email address."
        descriptionText.font = Font.regular(dynamicFontSize(18))
        descriptionText.minimumScaleFactor = 0.5
        descriptionText.adjustsFontSizeToFitWidth = true
        descriptionText.textColor = Color.textSemiBlack
        stack.addArrangedSubview(descriptionText)
        
        let button = UIButton()
        button.setTitle("Create a Sillo space", for: .normal)
        button.backgroundColor = Color.buttonClickableUnselected
        button.titleLabel?.font = Font.bold(dynamicFontSize(17))
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(createSilloSpaceClicked), for: .touchUpInside)
        stack.addArrangedSubview(button)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        stack.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        stack.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        stack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8).isActive = true
        
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        descriptionText.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        descriptionText.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        button.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        button.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07).isActive = true
        button.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    @objc private func createSilloSpaceClicked() {
        print("maybe we should disable creating new space for beta..")
        //navigationController?.pushViewController(SetupOrganizationViewController(), animated: true)
    }

}

extension UIViewController {
    func dynamicFontSize(_ FontSize: CGFloat) -> CGFloat {
        let screenWidth = UIScreen.main.bounds.size.width
        let calculatedFontSize = screenWidth / 375 * FontSize
        return calculatedFontSize
    }
}