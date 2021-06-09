//
//  NotificationRequestViewController.swift
//  Sillo
//
//  Created by William Loo on 1/11/21.
//

import Foundation
import UIKit
import FirebaseInstanceID

class NotificationRequestViewController: UIViewController {
 
    let logo: UIImageView = {
        let i = UIImageView()
        i.image = #imageLiteral(resourceName: "sillo-logo")
        i.contentMode = .scaleAspectFit
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()
    
    //MARK: init Stay Connected label
    let stayConnectedLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apercu Medium", size: 28)
        label.textColor = .black
        label.text = "Stay connected"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: init body label
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apercu Regular", size: 20)
        label.text = "Now let's turn on notifications so we can let you know when members want to connect with you."
        label.textAlignment = .left
//        label.contentMode = .scaleToFill
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: init enable button
    let enableButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.setTitle("Enable Notifications", for: .normal)
        button.titleLabel?.font = UIFont(name: "Apercu Bold", size: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Color.buttonClickable
        button.addTarget(self, action: #selector(enableTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let stack: UIStackView = {
        let s = UIStackView()
        s.axis = .vertical
        s.spacing = 15
        s.distribution = .fillProportionally
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()
    
    let img: UIImageView = {
        let i = UIImageView()
        i.image = UIImage(named: "notifications")
        i.contentMode = .scaleAspectFit
        i.translatesAutoresizingMaskIntoConstraints = false
        return i
    }()
    
    //MARK: init skip button
    let skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Skip this step", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(skipTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .white
        
        view.addSubview(logo)
        logo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 5).isActive = true
        logo.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 80/812).isActive = true
        logo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 138/375).isActive = true
        
        view.addSubview(stack)
        stack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 285/375).isActive = true
        stack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 402/812).isActive = true
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: logo.bottomAnchor, constant: 30).isActive = true
        
        stack.addArrangedSubview(stayConnectedLabel)
        stack.addArrangedSubview(bodyLabel)
        stack.addArrangedSubview(img)
        logo.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true

        view.addSubview(enableButton)
        enableButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 308/375).isActive = true
        enableButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 55/812).isActive = true
        enableButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        enableButton.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -130).isActive = true
        
        //MARK: skip button
        view.addSubview(skipButton)
        skipButton.widthAnchor.constraint(equalTo: enableButton.widthAnchor).isActive = true
        skipButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 22/812).isActive = true
        skipButton.centerXAnchor.constraint(equalTo: enableButton.centerXAnchor).isActive = true
        skipButton.topAnchor.constraint(equalTo: enableButton.bottomAnchor, constant: 25).isActive = true
    }
    
    @objc func enableTapped(_:UIButton) {
        registerForPushNotifications()
        UserDefaults.standard.set(true, forKey: "finishedOnboarding")
    }
    
    @objc func skipTapped(_:UIButton) {
        //UserDefaults.standard.set(true, forKey: "finishedOnboarding") //y skip notification? ANNOY USER >:(
        showNextVC()
    }
    
    func showNextVC() {
        
        
        if (organizationData.organizationList.isEmpty) {
            let nextVC = WelcomeToSilloViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        else {
            organizationData.changeOrganization(dest: organizationData.organizationList[0])
            let nextVC = prepareTabVC()
            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true)
        }
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
          .requestAuthorization(
            options: [.alert, .sound, .badge]) { [weak self] granted, _ in
            DispatchQueue.main.async {
                self?.showNextVC()
            }
            guard granted else { return }
            print("Permission granted: \(granted)")
            self?.getNotificationSettings()
          }
    }
    
    //MARK: Get Push Notification Settings
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
        print("Notification settings: \(settings)")
        
        guard settings.authorizationStatus == .authorized else { return }
        DispatchQueue.main.async {
          UIApplication.shared.registerForRemoteNotifications()
        }
        // upload notification token to user's database
        InstanceID.instanceID().instanceID { (result, error) in
              if let error = error {
              print("Error fetching remote instange ID: \(error)")
              } else if let result = result {
              print("Remote instance ID token: \(result.token)")
                analytics.log_notifications_enabled()
               localUser.uploadFCMToken(token: result.token)
               }
              }
      }
    }
}
