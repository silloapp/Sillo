//
//  PasscodeVerificationViewController.swift
//  Sillo
//
//  Created by William Loo on 1/7/21.
//

import UIKit
import Firebase

let cloudutil = CloudUtil()

//MARK: figma screen 164, 165
class PasscodeVerificationViewController: UIViewController {
    
    private var latestAuthRequestTimestamp: Date = Date()
    private var THROTTLE_LIMIT: Double = 5.0 //in seconds
    
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
        label.font = Font.medium(28)
        label.text = "Verify your email"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: init body text label
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.font = Font.regular(17)
        label.text = "Check your inbox for a verification code."
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: init passcode text field
    let passcodeField: UITextField = {
        let textField = UITextField()
        textField.placeholder = ""
        textField.textAlignment = .center
        textField.layer.cornerRadius = 10.0;
        textField.clearsOnBeginEditing = true
        textField.keyboardType = .phonePad
        textField.textContentType = .oneTimeCode
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return range.location < 5
    }
    
    //MARK: init resend email label
    let resendLabel: UILabel = {
        let label = UILabel()
        label.font = Font.regular(22)
        label.text = "I didn't receive a code!"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: init resend email button
    let resendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Resend", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)
        button.addTarget(self, action: #selector(resendRequested(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: init verify button
    let verifyButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.setTitle("Verify", for: .normal)
        button.titleLabel?.font = Font.bold(20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Color.buttonClickable
        button.addTarget(self, action: #selector(verifyClicked(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
        
        
        //MARK: logotype
        view.addSubview(silloLogotype)
        silloLogotype.widthAnchor.constraint(equalToConstant: 132).isActive = true
        silloLogotype.heightAnchor.constraint(equalToConstant: 61).isActive = true
        silloLogotype.topAnchor.constraint(equalTo: view.topAnchor,constant: 91).isActive = true
        silloLogotype.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 36).isActive = true
        
        //MARK: header label
        view.addSubview(headerLabel)
        headerLabel.widthAnchor.constraint(equalToConstant: 211).isActive = true
        headerLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
        headerLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        headerLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 192).isActive = true
        
        //MARK: body label
        view.addSubview(bodyLabel)
        bodyLabel.widthAnchor.constraint(equalToConstant: 327).isActive = true
        bodyLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        bodyLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        bodyLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 233).isActive = true
         
        //MARK: passcode field
        view.addSubview(passcodeField)
        passcodeField.backgroundColor = Color.textFieldBackground
        passcodeField.widthAnchor.constraint(equalToConstant: 250).isActive = true
        passcodeField.heightAnchor.constraint(equalToConstant: 55).isActive = true
        passcodeField.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passcodeField.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        //MARK: resend label
        view.addSubview(resendLabel)
        resendLabel.widthAnchor.constraint(equalToConstant: 291).isActive = true
        resendLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        resendLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        resendLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 478).isActive = true
        
        //MARK: resend code button
        view.addSubview(resendButton)
        resendButton.widthAnchor.constraint(equalToConstant: 291).isActive = true
        resendButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        resendButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resendButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 505).isActive = true
        
        
        //MARK: verify Button
        view.addSubview(verifyButton)
        verifyButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        verifyButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        verifyButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        verifyButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 730).isActive = true
        
    }
    
    @objc func resendRequested(_:UIButton) {
        let requestThrottled: Bool = -self.latestAuthRequestTimestamp.timeIntervalSinceNow < self.THROTTLE_LIMIT
        if (!requestThrottled) {
            cloudutil.generateAuthenticationCode()
            self.latestAuthRequestTimestamp = Date()
        }
        else {
            print("throttle limit exceeded!")
        }
    }
    
    @objc func verifyClicked(_:UIButton) {
        if (passcodeField.hasText) {
            validatePasscode(passcode: passcodeField.text!)
        }
        else {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Please enter a verification code.", message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {_ in}))
                self.present(alert, animated: true, completion: nil)
            }
        }
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
                    self.passcodeField.resignFirstResponder()
                    let nextVC = VerificationSuccessViewController()
                    nextVC.modalPresentationStyle = .fullScreen
                    self.present(nextVC, animated: true, completion:nil)
                    
                }
                else {
                    //incorrect passcode
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: "Code is incorrect.", message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {_ in self.passcodeField.text = nil}))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
                })
            }
        }.resume()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
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
