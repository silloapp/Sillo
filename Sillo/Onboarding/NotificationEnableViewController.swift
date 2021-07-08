//
//  NotificationEnableViewController.swift
//  Sillo
//
//  Created by Angelica Pan on 1/12/21.
//
import UIKit

class NotificationEnableViewController: UIViewController {

    //MARK: init sillo logotype
    let silloLogotype: UIImageView = {
        let image = UIImage(named: "onboardingSillo")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .left
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    //MARK: init Header label
    let headerLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apercu-Bold", size: 32)
        label.textColor = Color.buttonClickable
        label.text = "Stay connected"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    //MARK: init body text label
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 5;
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont(name: "Apercu-Regular", size: 20)
        label.text = "Now let’s turn on notifications so we can let you know when members want to connect with you. "
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    //MARK: init enable notifications button
    let enableNotificationsButton: UIButton = {
        let button = UIButton()
        button.setTitle("Enable Notifications", for: .normal)
        button.titleLabel?.font = UIFont(name: "Apercu-Bold", size: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Color.buttonClickable
        button.addTarget(self, action: #selector(enableNotifications(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()

    //MARK: init skip notifications button
    let skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Skip this step", for: .normal)
        button.titleLabel?.font = UIFont(name: "Apercu-Bold", size: 17)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(skipNotifications(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .white

        //MARK: logotype
        view.addSubview(silloLogotype)
        silloLogotype.widthAnchor.constraint(equalToConstant: 132).isActive = true
        silloLogotype.heightAnchor.constraint(equalToConstant: 61).isActive = true
        silloLogotype.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 91).isActive = true
        silloLogotype.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,constant: 55).isActive = true

        //MARK: header label
        view.addSubview(headerLabel)
        headerLabel.widthAnchor.constraint(equalToConstant: 280).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
        headerLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 55).isActive = true
        headerLabel.topAnchor.constraint(equalTo: silloLogotype.bottomAnchor, constant: 100).isActive = true

        //MARK: body label
        view.addSubview(bodyLabel)
        bodyLabel.widthAnchor.constraint(equalToConstant: 280).isActive = true
        bodyLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 55).isActive = true
        bodyLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 30).isActive = true

        //MARK: enable notifications button
        view.addSubview(enableNotificationsButton)
        enableNotificationsButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        enableNotificationsButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        enableNotificationsButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        enableNotificationsButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -60).isActive = true

        //MARK: skip notifications button
        view.addSubview(skipButton)
        skipButton.widthAnchor.constraint(equalToConstant: 291).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        skipButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        skipButton.topAnchor.constraint(equalTo: enableNotificationsButton.bottomAnchor, constant: 20).isActive = true
    }

    //MARK: Push Notification
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(
                options: [.alert, .sound, .badge]) { [weak self] granted, _ in
                print("Permission granted: \(granted)")
                guard granted else {
                    DispatchQueue.main.async {
                        let nextVC = AllSetViewController()
                        nextVC.modalPresentationStyle = .fullScreen
                        self?.present(nextVC, animated: true, completion:nil)
                    }
                    return
                }
                self?.getNotificationSettings()
            }
    }

    //MARK: Get Push Notification Settings
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else {
                let nextVC = AllSetViewController()
                nextVC.modalPresentationStyle = .fullScreen
                self.present(nextVC, animated: true, completion:nil)
                return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
                let nextVC = AllSetViewController()
                nextVC.modalPresentationStyle = .fullScreen
                self.present(nextVC, animated: true, completion:nil)
            }
        }
    }

    //User pressed enable notifications button
    @objc func enableNotifications(_:UIButton) {
        registerForPushNotifications()
    }

    //User pressed skip notifications button
    @objc func skipNotifications(_:UIButton) {
        let nextVC = AllSetViewController()
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion:nil)
    }

    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
}
