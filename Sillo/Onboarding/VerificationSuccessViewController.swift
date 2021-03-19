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
        let image = UIImage(named: "wait_success")
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .white
        //MARK: success image
        view.addSubview(successImage)
        successImage.widthAnchor.constraint(equalToConstant: 270).isActive = true
        successImage.heightAnchor.constraint(equalToConstant: 119).isActive = true
        successImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        successImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70).isActive = true
        
        //MARK: success label
        view.addSubview(successLabel)
        successLabel.widthAnchor.constraint(equalToConstant: 140).isActive = true
        successLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
        successLabel.topAnchor.constraint(equalTo: successImage.bottomAnchor, constant: 30).isActive = true
        successLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //log successful passcode verification
        analytics.log_passcode_verification_success()
        
        localUser.coldStart()
        DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
            localUser.createNewUser()
        }
        DispatchQueue.main.asyncAfter(deadline: .now()  + 1.0) {
            if (Constants.USERNAME == nil) {
                let nextVC = SetNameViewController()
                nextVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            else {
                let nextVC = NotificationRequestViewController()
                nextVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
        }
    }
}
