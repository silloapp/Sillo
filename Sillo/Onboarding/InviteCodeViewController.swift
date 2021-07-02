//
//  InviteCodeViewController.swift
//  Sillo
//
//  Created by William Loo on 7/1/21.
//

import UIKit
import Firebase

//MARK: figma screen 164, 165
class InviteCodeViewController: UIViewController {
    
    private var latestAuthRequestTimestamp: Date = Date()-5.0
    private var DEBOUNCE_LIMIT = 2.0
    
    //MARK: init exit button
    let exitButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "back"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
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
        label.font = UIFont(name: "Apercu-Medium", size: 28)
        label.text = "Enter Invite Code"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: init body text label
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apercu-Regular", size: 17)
        label.text = "Check with your group admin. A new Sillo Space invitation will be created for valid invite codes."
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: init passcode text field
    let passcodeField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ""
        textField.textAlignment = .center
        textField.attributedPlaceholder = NSAttributedString(string: "", attributes: [
            .font: UIFont(name: "Apercu-Regular", size: 17)
        ])
        textField.autocapitalizationType = .allCharacters
        textField.layer.cornerRadius = 10.0;
        textField.clearsOnBeginEditing = true
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 5
    }
    
    //MARK: init verify button
    let verifyButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.setTitle("Submit", for: .normal)
        button.titleLabel?.font = UIFont(name: "Apercu-Bold", size: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Color.buttonClickable
        button.addTarget(self, action: #selector(verifyClicked(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: animated)
        tabBarController?.tabBar.isHidden = true
    }
    
    override func viewDidLoad() {
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
        
        //MARK: exit button
        self.view.addSubview(exitButton)
        exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        exitButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 15).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        exitButton.addTarget(self, action: #selector(exitPressed), for: .touchUpInside)
        
        //MARK: logotype
        view.addSubview(silloLogotype)
        silloLogotype.widthAnchor.constraint(equalToConstant: 132).isActive = true
        silloLogotype.heightAnchor.constraint(equalToConstant: 61).isActive = true
        silloLogotype.topAnchor.constraint(equalTo: view.topAnchor,constant: 91).isActive = true
        silloLogotype.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 36).isActive = true
        
        //MARK: header label
        view.addSubview(headerLabel)
        headerLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
        headerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 192).isActive = true
        
        //MARK: body label
        view.addSubview(bodyLabel)
        bodyLabel.widthAnchor.constraint(equalToConstant: 327).isActive = true
        bodyLabel.heightAnchor.constraint(equalToConstant: 80).isActive = true
        bodyLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        bodyLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 233).isActive = true
         
        //MARK: passcode field
        view.addSubview(passcodeField)
        passcodeField.backgroundColor = Color.textFieldBackground
        passcodeField.widthAnchor.constraint(equalToConstant: 250).isActive = true
        passcodeField.heightAnchor.constraint(equalToConstant: 55).isActive = true
        passcodeField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passcodeField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        
        //MARK: verify Button
        view.addSubview(verifyButton)
        verifyButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        verifyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        verifyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        verifyButton.topAnchor.constraint(equalTo: passcodeField.topAnchor, constant: 74).isActive = true
        
    }
    
    @objc func exitPressed() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func verifyClicked(_:UIButton) {
        let requestThrottled: Bool = -self.latestAuthRequestTimestamp.timeIntervalSinceNow < self.DEBOUNCE_LIMIT
        if requestThrottled {
            return
        }
        
        if (passcodeField.hasText) {
            self.latestAuthRequestTimestamp = Date()
            self.passcodeField.resignFirstResponder()
            
            let alert = AlertView(headingText: "Please wait..", messageText: "Your invite code has been submitted.", action1Label: "", action1Color: UIColor.white, action1Completion: {
            }, action2Label: "Nil", action2Color: .gray, action2Completion: {
            }, withCancelBtn: false, image: UIImage(named:"wait_a_moment"), withOnlyOneAction: true)
            alert.modalPresentationStyle = .overCurrentContext
            alert.modalTransitionStyle = .crossDissolve
            self.present(alert, animated: false, completion: nil)
            
            guard let url = URL(string: "https://us-central1-anonymous-d1615.cloudfunctions.net/verifyInviteCode") else {return}
            var request = URLRequest(url: url)
            let payload = "{\"userID\": \"\(Constants.FIREBASE_USERID!)\", \"passcode\": \"\(passcodeField.text!)\"}".data(using: .utf8)
            
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = payload
            
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                guard error == nil else { print(error!.localizedDescription); return }
                guard let data = data else { print("Empty data");return }

                if let str = String(data: data, encoding: .utf8) {
                    
                    print("invite code function result: \(str)")
                    DispatchQueue.main.async {
                        alert.dismiss(animated: true, completion: nil)
                        self.navigationController?.popViewController(animated: true)
                    }
                }
            }.resume()
            
            
        }
        else {
            DispatchQueue.main.async {
                let alert = AlertView(headingText: "Oops!", messageText: "Please enter an invite code.", action1Label: "Okay", action1Color: Color.burple, action1Completion: {
                    self.dismiss(animated: true, completion: nil)
                }, action2Label: "Nil", action2Color: .gray, action2Completion: {
                }, withCancelBtn: false, image: nil, withOnlyOneAction: true)
                alert.modalPresentationStyle = .overCurrentContext
                alert.modalTransitionStyle = .crossDissolve
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 && self.view.frame.height < 812 {
                self.view.frame.origin.y -= (keyboardSize.height/3)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    @objc func hideKeyboard() {
        passcodeField.resignFirstResponder()
    }
}

