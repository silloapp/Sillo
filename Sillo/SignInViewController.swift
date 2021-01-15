//
//  SignInViewController.swift
//  Sillo
//
//  Created by William Loo on 1/14/21.
//

import UIKit
import Firebase
import GoogleSignIn

//MARK: figma screen 1266
class SignInViewController: UIViewController, GIDSignInDelegate {
    
    //MARK: init email text field
    let emailTextField: UITextField = {
        let etextField = UITextField()
        etextField.placeholder = " youremail@berkeley.edu"
        etextField.layer.cornerRadius = 10.0;
        //textField.keyboardType = .emailAddress
        etextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        etextField.translatesAutoresizingMaskIntoConstraints = false
        return etextField
    }()
    
    //MARK: init password text field
    var passwordTextField: UITextField = {
        let ptextField = UITextField()
        ptextField.placeholder = " Password"
        ptextField.layer.cornerRadius = 10.0;
        ptextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        ptextField.isSecureTextEntry = true
        ptextField.translatesAutoresizingMaskIntoConstraints = false
        return ptextField
    }()
    
    //MARK: Scroll view
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        let screensize: CGRect = UIScreen.main.bounds
        let screenHeight = screensize.height
        print(screenHeight)
        scrollView.contentSize = CGSize(width: 0, height: 896.0)
    }
    //MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .white
        GIDSignIn.sharedInstance().presentingViewController = self
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(tap)

        self.view.addSubview(scrollView)
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 1.0).isActive = true
        scrollView.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 1.0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -1.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -1.0).isActive = true
        scrollView.isScrollEnabled = true
        
        //MARK: sillo logotype
        let silloLogotype: UIImageView = {
            let image = UIImage(named: "onboardingSillo")
            let imageView = UIImageView(image: image)
            imageView.contentMode = .left
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        scrollView.addSubview(silloLogotype)
        silloLogotype.widthAnchor.constraint(equalToConstant: 132).isActive = true
        silloLogotype.heightAnchor.constraint(equalToConstant: 61).isActive = true
        silloLogotype.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: 63).isActive = true
        silloLogotype.leftAnchor.constraint(equalTo: scrollView.leftAnchor,constant: 32).isActive = true
        
        //MARK: sign in account label
        let signInLabel: UILabel = {
            let label = UILabel()
            label.font = Font.medium(dynamicFontSize(28))
            label.text = "Sign in"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        scrollView.addSubview(signInLabel)
        signInLabel.widthAnchor.constraint(equalToConstant: 261).isActive = true
        signInLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        signInLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 36).isActive = true
        signInLabel.topAnchor.constraint(equalTo: silloLogotype.topAnchor, constant: 119).isActive = true
        
        //MARK: school email label
        let schoolEmailLabel: UILabel = {
            let label = UILabel()
            label.font = Font.regular(dynamicFontSize(17))
            label.text = "Enter your school email"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        scrollView.addSubview(schoolEmailLabel)
        schoolEmailLabel.widthAnchor.constraint(equalToConstant: 284).isActive = true
        schoolEmailLabel.heightAnchor.constraint(equalToConstant: 27).isActive = true
        schoolEmailLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 38).isActive = true
        schoolEmailLabel.topAnchor.constraint(equalTo: signInLabel.topAnchor, constant: 49).isActive = true
        
        //MARK: email text field
        scrollView.addSubview(emailTextField)
        emailTextField.backgroundColor = Color.textFieldBackground
        emailTextField.widthAnchor.constraint(equalToConstant: 319).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 32).isActive = true
        emailTextField.topAnchor.constraint(equalTo: schoolEmailLabel.topAnchor, constant: 25).isActive = true
        
        //MARK: password label
        let createPasswordLabel: UILabel = {
            let label = UILabel()
            label.font = Font.regular(dynamicFontSize(17))
            label.text = "Password"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        scrollView.addSubview(createPasswordLabel)
        createPasswordLabel.widthAnchor.constraint(equalToConstant: 284).isActive = true
        createPasswordLabel.heightAnchor.constraint(equalToConstant: 27).isActive = true
        createPasswordLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 38).isActive = true
        createPasswordLabel.topAnchor.constraint(equalTo: emailTextField.topAnchor, constant: 68).isActive = true

        //MARK: password text field
        passwordTextField.backgroundColor = Color.textFieldBackground
        scrollView.addSubview(passwordTextField)
        passwordTextField.widthAnchor.constraint(equalToConstant: 319).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 34).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: createPasswordLabel.topAnchor, constant: 29).isActive = true
        
        //MARK: password visiblity toggle
        let passwordVisibilityToggle: UIButton = {
            let button = UIButton()
            let image = UIImage(named:"visibility")
            //button.setBackgroundImage(image, for: .normal)
            button.setImage(image, for: .normal)
            button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.imageView?.contentMode = .scaleAspectFit
            return button
        }()
        scrollView.addSubview(passwordVisibilityToggle)
        passwordVisibilityToggle.widthAnchor.constraint(equalToConstant: 24).isActive = true
        passwordVisibilityToggle.heightAnchor.constraint(equalToConstant: 24).isActive = true
        passwordVisibilityToggle.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 327).isActive = true
        passwordVisibilityToggle.topAnchor.constraint(equalTo: emailTextField.topAnchor, constant: 62).isActive = true

        //MARK: next button
        let nextButton: UIButton = {
            let button = UIButton()
            button.layer.cornerRadius = 8
            button.setTitle("Sign in with e-mail", for: .normal)
            button.titleLabel?.font = Font.bold(20)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = Color.buttonClickable
            button.addTarget(self, action: #selector(nextClicked(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        scrollView.addSubview(nextButton)
        nextButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 37).isActive = true
        nextButton.topAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: 74).isActive = true
        
        //MARK: reset password button
        let resetPasswordButton: UIButton = {
            let button = UIButton()
            button.setTitle("Forgot password?", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.setTitleColor(.darkGray, for: .highlighted)
            button.addTarget(self, action: #selector(resetPassword(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        
        view.addSubview(resetPasswordButton)
        resetPasswordButton.widthAnchor.constraint(equalToConstant: 216).isActive = true
        resetPasswordButton.heightAnchor.constraint(equalToConstant: 22).isActive = true
        resetPasswordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        resetPasswordButton.topAnchor.constraint(equalTo: nextButton.topAnchor, constant: 68).isActive = true
        
        
        //MARK: or divider
        let divider: UIImageView = {
            let imageView = UIImageView()
            let image = UIImage(named: "or-divider")
            imageView.image = image
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        scrollView.addSubview(divider)
        divider.widthAnchor.constraint(equalToConstant: 305).isActive = true
        divider.heightAnchor.constraint(equalToConstant: 22).isActive = true
        divider.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        divider.topAnchor.constraint(equalTo: resetPasswordButton.topAnchor, constant: 62).isActive = true
        
        //MARK: google-signin button
        let googleSignIn: UIButton = {
            let button = UIButton()
            let image = UIImage(named:"google-signin")
            let imagePressed = UIImage(named:"google-signin-pressed")
            button.setBackgroundImage(image, for: .normal)
            button.setBackgroundImage(imagePressed, for: .highlighted)
            button.addTarget(self, action: #selector(signInButtonPressed(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.imageView?.contentMode = .scaleToFill
            return button
        }()
        scrollView.addSubview(googleSignIn)
        googleSignIn.widthAnchor.constraint(equalToConstant: 300).isActive = true
        googleSignIn.heightAnchor.constraint(equalToConstant: 65).isActive = true
        googleSignIn.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        googleSignIn.topAnchor.constraint(equalTo: divider.topAnchor, constant: 47).isActive = true

    }
    //MARK: toggle password visibility
    @objc func togglePasswordVisibility(_:UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
    }
    
    //MARK: next clicked
    @objc func nextClicked(_:UIButton) {
        var errorState = false
        var errorMsg = "Uncaught Exception: please contact the sillo team."
        var email:String = ""
        var password:String = ""
        
        if (emailTextField.hasText && passwordTextField.hasText) {
            email = emailTextField.text!
            password = passwordTextField.text!
        
                Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
                    //Check that user isn't NIL
                    if authResult != nil {
                        cloudutil.generateAuthenticationCode()
                        let nextVC = PasscodeVerificationViewController()
                        nextVC.modalPresentationStyle = .fullScreen
                        self.present(nextVC, animated: true, completion:nil)
                    }
                    else {
                        //Check error and show message
                        errorState=true
                        errorMsg = error!.localizedDescription
                        DispatchQueue.main.async {
                            let alert = UIAlertController(title: errorMsg, message: "", preferredStyle: .alert)
                            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {_ in }))
                            self.present(alert, animated: true, completion: nil)
                        }
                    }
                }
        }
        else {
            errorState=true
            errorMsg="Please fill out all fields to continue."
        }
        if (errorState) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: errorMsg, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {_ in}))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: reset password
    @objc func resetPassword(_ sender: Any) {
        var errorMsg = "Uncaught Exception: please contact the sillo team."
        if (emailTextField.hasText) {
            let email : String = emailTextField.text!
            Auth.auth().sendPasswordReset(withEmail: email) { error in
                if let e = error {
                    errorMsg = e.localizedDescription
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: errorMsg, message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {_ in }))
                        self.present(alert, animated: true, completion: nil)
                    }
                }
            }
        }
        else {
            errorMsg="Please fill out your email to continue."
            DispatchQueue.main.async {
                let alert = UIAlertController(title: errorMsg, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {_ in}))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: sign in with google
    @objc func signInButtonPressed(_ sender: Any) {
            GIDSignIn.sharedInstance().signIn()
        }
        
        func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        //Sign in functionality will be handled here
            if let error = error {
                print(error.localizedDescription)
                return
            }
            guard let auth = user.authentication else { return }
            let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
            Auth.auth().signIn(with: credentials) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Login Successful.")
                    UserDefaults.standard.set(true, forKey: "loggedIn")
                }
            }
        }
    
    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
                scrollView.contentInset = UIEdgeInsets(top: keyboardSize.height + view.safeAreaInsets.top, left: 0, bottom: keyboardSize.height + view.safeAreaInsets.bottom, right: 0)
            }
        }
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
            //scrollView.setContentOffset(CGPoint(x: 0.0, y: 0.0), animated: true)
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }
    
    @objc func hideKeyboard() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

}