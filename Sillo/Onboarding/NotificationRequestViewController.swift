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
 
    //MARK: init Stay Connected label
    let stayConnectedLabel: UILabel = {
        let label = UILabel()
        label.font = Font.medium(28)
        label.textColor = .black
        label.text = "Stay connected"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: init body label
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = Font.regular(20)
        label.text = "Now let's turn on notifications so we can let you know when members want to connect with you."
        label.textAlignment = .left
        label.contentMode = .scaleToFill
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: init enable button
    let enableButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.setTitle("Enable Notifications", for: .normal)
        button.titleLabel?.font = Font.bold(20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Color.buttonClickable
        button.addTarget(self, action: #selector(enableTapped(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
        
        //MARK: stay connected
        view.addSubview(stayConnectedLabel)
        stayConnectedLabel.widthAnchor.constraint(equalToConstant: 279).isActive = true
        stayConnectedLabel.heightAnchor.constraint(equalToConstant: 30).isActive = true
        stayConnectedLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stayConnectedLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 224).isActive = true
        
        //MARK: body label
        view.addSubview(bodyLabel)
        bodyLabel.widthAnchor.constraint(equalToConstant: 279).isActive = true
        bodyLabel.heightAnchor.constraint(equalToConstant: 150).isActive = true
        bodyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        bodyLabel.topAnchor.constraint(equalTo: stayConnectedLabel.bottomAnchor, constant: 0).isActive = true
        
        //MARK: enable button
        view.addSubview(enableButton)
        enableButton.widthAnchor.constraint(equalToConstant: 308).isActive = true
        enableButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        enableButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        enableButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 415).isActive = true
        
        //MARK: skip button
        view.addSubview(skipButton)
        skipButton.widthAnchor.constraint(equalToConstant: 228).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        skipButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        skipButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 493).isActive = true
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
               localUser.uploadFCMToken(token: result.token)
               }
              }
      }
    }
}
