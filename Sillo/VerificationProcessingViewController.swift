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
        let image = UIImage(named: "onboardingSillo")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: init success label
    let waitLabel: UILabel = {
        let label = UILabel()
        label.font = Font.medium(28)
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
        waitImage.widthAnchor.constraint(equalToConstant: 136).isActive = true
        waitImage.heightAnchor.constraint(equalToConstant: 114).isActive = true
        waitImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        waitImage.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -70).isActive = true
        
        //MARK: wait label
        view.addSubview(waitLabel)
        waitLabel.widthAnchor.constraint(equalToConstant: 213).isActive = true
        waitLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
        waitLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        waitLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
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
                    // Code verification successful, move to next VC
                    let nextVC = VerificationSuccessViewController()
                    nextVC.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(nextVC, animated: true)
                    
                }
                else {
                    //incorrect passcode
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Code is incorrect.", message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {_ in self.navigationController?.popViewController(animated: true)}))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                })
            }
        }.resume()
    }
}
