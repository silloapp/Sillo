//
//  NameChangeProcessingViewController.swift
//  Sillo
//
//  Created by William Loo on 1/15/21.
//

import UIKit
import Firebase

//MARK: figma screen 166
class NameChangeProcessingViewController: UIViewController {
    
    var displayName:String = ""
    
    //MARK: init success image
    let waitImage: UIImageView = {
        let image = UIImage(named: "wait_a_moment")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: init success label
    let waitLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apercu Medium", size: 28)
        label.text = "Just a moment..."
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
        //MARK: wait image
        view.addSubview(waitImage)
        waitImage.widthAnchor.constraint(equalToConstant: 270).isActive = true
        waitImage.heightAnchor.constraint(equalToConstant: 119).isActive = true
        waitImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        waitImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70).isActive = true
        
        //MARK: wait label
        view.addSubview(waitLabel)
        waitLabel.widthAnchor.constraint(equalToConstant: 213).isActive = true
        waitLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
        waitLabel.topAnchor.constraint(equalTo: waitImage.bottomAnchor, constant: 30).isActive = true
        waitLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        setName(displayName: self.displayName)
    }
    
    //MARK: Change name in user database
    func setName(displayName: String) {
        Constants.USERNAME = displayName
        localUser.updateUserName(name: displayName)
        var errorMsg = "Oops, something unexpected happened! Please contact the Sillo team"
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        changeRequest?.commitChanges(completion: {_ in
        let user = Auth.auth().currentUser!
        user.reload(completion: {_ in
            if user.displayName != nil {
                // Code verification successful, move to next VC
                let nextVC = NotificationRequestViewController()
                nextVC.modalPresentationStyle = .fullScreen
                self.navigationController?.pushViewController(nextVC, animated: true)
                print("SUCCESS")
            }
            else {
                errorMsg = "Error setting name, please try again later."
                DispatchQueue.main.async {
                    let alert = UIAlertController(title: errorMsg, message: "", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {_ in self.navigationController?.popViewController(animated: true)}))
                    self.present(alert, animated: true, completion: nil)
                }
            }
        })
        })
    }
}

