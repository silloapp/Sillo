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
    
    private var latestButtonPressTimestamp: Date = Date()
    private var DEBOUNCE_LIMIT: Double = 0.5 //in seconds
    
    //loading screen
    let loadingVC = LoadingViewController()
    
    //MARK: init email text field
    let emailTextField: UITextField = {
        let etextField = UITextField()
        etextField.placeholder = " youremail@berkeley.edu"
        etextField.layer.cornerRadius = 10.0;
        etextField.attributedPlaceholder = NSAttributedString(string: " youremail@berkeley.edu", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont(name: "Apercu-Regular", size: 17)
        ])
        etextField.keyboardType = .emailAddress
        etextField.autocorrectionType = .no
        etextField.autocapitalizationType = .none
        etextField.font = UIFont(name: "Apercu-Regular", size: 17)
        etextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        etextField.translatesAutoresizingMaskIntoConstraints = false
        return etextField
    }()
    
    //MARK: init password text field
    var passwordTextField: UITextField = {
        let ptextField = UITextField()
        ptextField.placeholder = " Password"
        ptextField.attributedPlaceholder = NSAttributedString(string: " Password", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont(name: "Apercu-Regular", size: 17)
        ])
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
        sv.scrollIndicatorInsets = UIEdgeInsets(top: 65, left: 0, bottom: 0, right: 0)
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
        scrollView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -1.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor).isActive = true
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
        silloLogotype.widthAnchor.constraint(equalToConstant: 319).isActive = true
        silloLogotype.heightAnchor.constraint(equalToConstant: 61).isActive = true
        silloLogotype.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: 63).isActive = true
        silloLogotype.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        
        //MARK: sign in account label
        let signInLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .left
            label.font = UIFont(name: "Apercu-Medium", size: dynamicFontSize(28))
            label.text = "Sign in"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        scrollView.addSubview(signInLabel)
        signInLabel.widthAnchor.constraint(equalToConstant: 319).isActive = true
        signInLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        signInLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        signInLabel.topAnchor.constraint(equalTo: silloLogotype.topAnchor, constant: 119).isActive = true
        
        //MARK: school email label
        let schoolEmailLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .left
            label.font = UIFont(name: "Apercu-Regular", size: dynamicFontSize(17))
            label.text = "Enter your email"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        scrollView.addSubview(schoolEmailLabel)
        schoolEmailLabel.widthAnchor.constraint(equalToConstant: 319).isActive = true
        schoolEmailLabel.heightAnchor.constraint(equalToConstant: 27).isActive = true
        schoolEmailLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        schoolEmailLabel.topAnchor.constraint(equalTo: signInLabel.topAnchor, constant: 49).isActive = true
        
        //MARK: email text field
        scrollView.addSubview(emailTextField)
        emailTextField.backgroundColor = Color.textFieldBackground
        emailTextField.widthAnchor.constraint(equalToConstant: 319).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        emailTextField.topAnchor.constraint(equalTo: schoolEmailLabel.topAnchor, constant: 29).isActive = true
        
        //MARK: password label
        let createPasswordLabel: UILabel = {
            let label = UILabel()
            label.font = UIFont(name: "Apercu-Regular", size: dynamicFontSize(17))
            label.text = "Password"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        scrollView.addSubview(createPasswordLabel)
        createPasswordLabel.widthAnchor.constraint(equalToConstant: 319).isActive = true
        createPasswordLabel.heightAnchor.constraint(equalToConstant: 27).isActive = true
        createPasswordLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        createPasswordLabel.topAnchor.constraint(equalTo: emailTextField.topAnchor, constant: 68).isActive = true

        //MARK: password text field
        passwordTextField.backgroundColor = Color.textFieldBackground
        scrollView.addSubview(passwordTextField)
        passwordTextField.widthAnchor.constraint(equalToConstant: 319).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
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
        passwordVisibilityToggle.leftAnchor.constraint(equalTo: passwordTextField.leftAnchor, constant: 319-24).isActive = true
        passwordVisibilityToggle.topAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -24).isActive = true

        //MARK: next button
        let nextButton: UIButton = {
            let button = UIButton()
            button.layer.cornerRadius = 8
            button.setTitle("Sign in with e-mail", for: .normal)
            button.titleLabel?.font = UIFont(name: "Apercu-Bold", size: 20)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = Color.buttonClickable
            button.addTarget(self, action: #selector(nextClicked(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        scrollView.addSubview(nextButton)
        nextButton.widthAnchor.constraint(equalToConstant: 319).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
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
        var errorMsg = "Oops, something unexpected happened! Please contact the Sillo team"
        var email:String = ""
        var password:String = ""
        
        let requestThrottled: Bool = -self.latestButtonPressTimestamp.timeIntervalSinceNow < self.DEBOUNCE_LIMIT
        
        if (requestThrottled) {
            return
        }
        
        if (emailTextField.hasText && passwordTextField.hasText) {
            self.latestButtonPressTimestamp = Date()
            email = emailTextField.text!
            password = passwordTextField.text!
            Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
                    //Check that user isn't NIL
                    if authResult != nil {
                        //log sign-in event
                        analytics.log_sign_in_standard()
                        
                        let currentUser = Auth.auth().currentUser!
                        if (!currentUser.isEmailVerified) {
                            //email not verified, do not set logged in (it will be set after verification
                            UserDefaults.standard.set(false, forKey: "loggedIn")
                            
                            //localUser.createNewUser(newUser:Auth.auth().currentUser!.uid) is moved to verificationprocessingvc
                            let nextVC = PasscodeVerificationViewController()
                            //cloudutil.generateAuthenticationCode()
                            nextVC.modalPresentationStyle = .fullScreen
                            self.navigationController?.pushViewController(nextVC, animated: true)
                        }
                        else {
                            //verified, proceed
                            UserDefaults.standard.set(true, forKey: "loggedIn")
                            
                            localUser.createNewUser(newUser:Auth.auth().currentUser!.uid)
                            
                            let nextVC = VerificationSuccessViewController()
                            nextVC.modalPresentationStyle = .fullScreen
                            self.navigationController?.pushViewController(nextVC, animated: true)
                        }
                    }
                    else {
                        //Check error and show message
                        errorState=true
                        errorMsg = error!.localizedDescription
                        DispatchQueue.main.async {
                            let alert = AlertView(headingText: "Oops!", messageText: errorMsg, action1Label: "Okay", action1Color: Color.burple, action1Completion: {
                                self.dismiss(animated: true, completion: nil)
                            }, action2Label: "Nil", action2Color: .gray, action2Completion: {
                            }, withCancelBtn: false, image: nil, withOnlyOneAction: true)
                            alert.modalPresentationStyle = .overCurrentContext
                            alert.modalTransitionStyle = .crossDissolve
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
                let alert = AlertView(headingText: "Oops!", messageText: errorMsg, action1Label: "Okay", action1Color: Color.burple, action1Completion: {
                    self.dismiss(animated: true, completion: nil)
                }, action2Label: "Nil", action2Color: .gray, action2Completion: {
                }, withCancelBtn: false, image: nil, withOnlyOneAction: true)
                alert.modalPresentationStyle = .overCurrentContext
                alert.modalTransitionStyle = .crossDissolve
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    //MARK: sign in with google
    @objc func signInButtonPressed(_ sender: Any) {
            //show loading vc while backend business
            loadingVC.modalPresentationStyle = .overCurrentContext
            loadingVC.modalTransitionStyle = .crossDissolve
            self.present(loadingVC, animated: false, completion: nil)
            GIDSignIn.sharedInstance().signIn()
        }
        
        func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        //Sign in functionality will be handled here
            if let error = error {
                print(error.localizedDescription)
                self.loadingVC.dismiss(animated: false, completion: nil)
                return
            }
            guard let auth = user.authentication else { self.loadingVC.dismiss(animated: false, completion: nil);return }
            let credentials = GoogleAuthProvider.credential(withIDToken: auth.idToken, accessToken: auth.accessToken)
            Auth.auth().signIn(with: credentials) { (authResult, error) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("Login Successful.")
                    
                    //log google education sign-in
                    analytics.log_sign_in_google()
                    
                    localUser.createNewUser(newUser:Auth.auth().currentUser!.uid)
                    
                    UserDefaults.standard.set(true, forKey: "loggedIn")
                    let nextVC = VerificationSuccessViewController()
                    nextVC.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                self.loadingVC.dismiss(animated: false, completion: nil)
            }
        }
    
    //MARK: reset password
    @objc func resetPassword(_ sender: Any) {
        
        let requestThrottled: Bool = -self.latestButtonPressTimestamp.timeIntervalSinceNow < self.DEBOUNCE_LIMIT
        
        if (requestThrottled) {
            return
        }
        
        var errorMsg = "Uncaught Exception: please contact the sillo team."
        if (emailTextField.hasText) {
            self.latestButtonPressTimestamp = Date()
            let email : String = emailTextField.text!
            Auth.auth().sendPasswordReset(withEmail: email) { error in

            //log password reset
            analytics.log_forgot_password()
                DispatchQueue.main.async {
                    let alert = AlertView(headingText: "Password reset requested!", messageText: "If you have an email linked with Sillo, you will receieve a password reset link.", action1Label: "Okay", action1Color: Color.burple, action1Completion: {
                        self.dismiss(animated: true, completion: nil)
                    }, action2Label: "Nil", action2Color: .gray, action2Completion: {
                    }, withCancelBtn: false, image: nil, withOnlyOneAction: true)
                    alert.modalPresentationStyle = .overCurrentContext
                    alert.modalTransitionStyle = .crossDissolve
                    self.present(alert, animated: true, completion: nil)
                }
            }
        }
        else {
            errorMsg="Please fill out your email to continue."
            DispatchQueue.main.async {
                let alert = AlertView(headingText: "Oops!", messageText: errorMsg, action1Label: "Okay", action1Color: Color.burple, action1Completion: {
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
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= 2*(keyboardSize.height / 3)
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
