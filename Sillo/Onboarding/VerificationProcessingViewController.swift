//
//  VerificationProcessingViewController.swift
//  Sillo
//
//  Created by William Loo on 1/15/21.
//

import UIKit
import Firebase

//MARK: figma screen 166
class VerificationProcessingViewController: UIViewController {
    
    var passcode:String = ""
    
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
        label.font = UIFont(name: "Apercu-Medium", size: 28)
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
        
        validatePasscode(passcode: self.passcode)
    }
    
    //MARK: Call the validateAuthenticationCode cloud function service
    func validatePasscode(passcode: String) {
        guard let url = URL(string: "https://us-central1-anonymous-d1615.cloudfunctions.net/validateAuthenticationCode") else {return}
        var request = URLRequest(url: url)
        let userID : String = Auth.auth().currentUser!.uid
        let payload = "{\"userID\": \"\(userID)\", \"passcode\": \"\(passcode)\"}".data(using: .utf8)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = payload
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { print(error!.localizedDescription); return }
            guard let data = data else { print("Empty data");return }

            if let str = String(data: data, encoding: .utf8) {
                print(str)
                let user = Auth.auth().currentUser!
                
                user.reload(completion: {_ in
                    let auth_status:Bool = user.isEmailVerified
                if (auth_status == true) {
                    //log successful passcode verification
                    analytics.log_passcode_verification_success()
                    
                    //create new user
                    localUser.createNewUser(newUser:Auth.auth().currentUser!.uid)
                    
                    //set logged in
                    UserDefaults.standard.set(true, forKey: "loggedIn")
                    
                    // Code verification successful, move to next VC
                    let nextVC = VerificationSuccessViewController()
                    nextVC.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(nextVC, animated: true)
                    
                }
                else {
                    //incorrect passcode
                    DispatchQueue.main.async {
                        let alert = AlertView(headingText: "Code is invalid.", messageText: "", action1Label: "Okay", action1Color: Color.burple, action1Completion: {
                            self.dismiss(animated: true, completion: nil)
                            self.navigationController?.popViewController(animated: true)
                        }, action2Label: "Nil", action2Color: .gray, action2Completion: {
                        }, withCancelBtn: false, image: nil, withOnlyOneAction: true)
                        alert.modalPresentationStyle = .overCurrentContext
                        alert.modalTransitionStyle = .crossDissolve
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                })
            }
        }.resume()
    }
}

