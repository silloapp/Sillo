//
//  ProfileEditViewController.swift
//  Sillo
//
//  Created by William Loo on 2/25/21.
//

import UIKit
import Firebase
import GoogleSignIn

class ProfileEditViewController: UIViewController, GIDSignInDelegate {
        
    private var latestButtonPressTimestamp: Date = Date()
    private var DEBOUNCE_LIMIT: Double = 0.5 //in seconds
    
    //MARK: init email text field
    let emailTextField: UITextField = {
        let etextField = UITextField()
        etextField.placeholder = " He/Him/His"
        etextField.text = " He/Him/His"
        etextField.layer.cornerRadius = 10.0;
        etextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        etextField.translatesAutoresizingMaskIntoConstraints = false
        return etextField
    }()
    
    //MARK: init password text field
    var passwordTextField: UITextView = {
        let ptextField = UITextView()
        //ptextField.placeholder = " Password"
        ptextField.layer.cornerRadius = 10.0;
        var frameRect = ptextField.frame
        frameRect.size.height = 400; // <-- Specify the height you want here.
        ptextField.frame = frameRect;
        ptextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        //ptextField.isSecureTextEntry = true
        ptextField.text = "Hi my name is Eashan and I am potato."
        ptextField.translatesAutoresizingMaskIntoConstraints = false
        return ptextField
    }()
    
    var interests:[String] = ["design","baking","meditation"]
    var restaurants:[String] = ["Asha Tea House","Eureka","Thai Basil"]
    
    //MARK: Scroll view
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override func viewDidAppear(_ animated: Bool) {
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
        silloLogotype.widthAnchor.constraint(equalToConstant: 319).isActive = true
        silloLogotype.heightAnchor.constraint(equalToConstant: 61).isActive = true
        silloLogotype.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        silloLogotype.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: 63).isActive = true
        
        
        //MARK: create account label
        let createAccountLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .left
            label.font = Font.medium(dynamicFontSize(28))
            label.text = "Set up your Profile (JANK)"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        scrollView.addSubview(createAccountLabel)
        createAccountLabel.widthAnchor.constraint(equalToConstant: 319).isActive = true
        createAccountLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        createAccountLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        createAccountLabel.topAnchor.constraint(equalTo: silloLogotype.topAnchor, constant: 119).isActive = true
        
        //MARK: school email label
        let schoolEmailLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .left
            label.font = Font.regular(dynamicFontSize(17))
            label.text = "Enter your pronouns"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        scrollView.addSubview(schoolEmailLabel)
        schoolEmailLabel.widthAnchor.constraint(equalToConstant: 319).isActive = true
        schoolEmailLabel.heightAnchor.constraint(equalToConstant: 27).isActive = true
        schoolEmailLabel.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        schoolEmailLabel.topAnchor.constraint(equalTo: createAccountLabel.topAnchor, constant: 49).isActive = true
        
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
            label.textAlignment = .left
            label.font = Font.regular(dynamicFontSize(17))
            label.text = "Bio"
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
        passwordVisibilityToggle.leftAnchor.constraint(equalTo: createPasswordLabel.leftAnchor, constant: 319-24).isActive = true
        passwordVisibilityToggle.topAnchor.constraint(equalTo: passwordTextField.topAnchor, constant: -24).isActive = true

        //MARK: next button
        let nextButton: UIButton = {
            let button = UIButton()
            button.layer.cornerRadius = 8
            button.setTitle("Create Profile", for: .normal)
            button.titleLabel?.font = Font.bold(20)
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
        
        //MARK: terms text view
        let termsTextView: UITextView = {
            let tview = UITextView()
            tview.textAlignment = .left
            tview.isEditable = false
            tview.isScrollEnabled = false
            tview.font = Font.regular(dynamicFontSize(13))
            tview.textColor = .black
            tview.text = "By creating an account, you are indicating that you have read and acknowledged the Terms of Service and Privacy Policy."
            tview.translatesAutoresizingMaskIntoConstraints = false
            return tview
        }()
        scrollView.addSubview(termsTextView)
        termsTextView.widthAnchor.constraint(equalToConstant: 310).isActive = true
        termsTextView.heightAnchor.constraint(equalToConstant: 73).isActive = true
        termsTextView.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        termsTextView.topAnchor.constraint(equalTo: nextButton.topAnchor, constant: 70).isActive = true
        
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
        divider.topAnchor.constraint(equalTo: termsTextView.topAnchor, constant: 74).isActive = true
        
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
    @objc func togglePasswordVisibility(_:UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        //confirmPasswordTextField.isSecureTextEntry.toggle()
    }
    
    @objc func nextClicked(_:UIButton) {
        var errorState = false
        var errorMsg = "Oops, something unexpected happened! Please contact the Sillo team"
        //var email:String = ""
        //var password:String = ""
        //var confirmedPassword:String = ""
        
        let requestThrottled: Bool = -self.latestButtonPressTimestamp.timeIntervalSinceNow < self.DEBOUNCE_LIMIT
        
        if (requestThrottled) {
            return
        }
        let USE_SEPARATE_PROFILES = false
        if (emailTextField.hasText && passwordTextField.hasText) {
            let pronouns = emailTextField.text!
            let bio = passwordTextField.text!
            self.latestButtonPressTimestamp = Date()
            //set the orgaization document to overwrite
            var profileDocumentName = "all_orgs"
            if (USE_SEPARATE_PROFILES) {
                profileDocumentName = "some_org"
            }
            
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let upperUserRef = db.collection("profiles").document(userID)
            upperUserRef.setData(["use_separate_profiles":USE_SEPARATE_PROFILES])
            
            let userRef = db.collection("profiles").document(userID).collection("org_profiles").document(profileDocumentName)
            /*
            userRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                    print("Document data: \(dataDescription)")
                    userRef.updateData(["pronouns":pronouns,"bio":bio,"interests":self.interests,"data":"some more important data."])
                } else {
                    print("Document does not exist")
                    userRef.setData(["use_separate_profiles":USE_SEPARATE_PROFILES])
                }
            }
            */
            userRef.setData(["pronouns":pronouns,"bio":bio,"interests":self.interests,"restaurants":self.restaurants, "data":"some more important data."])
            
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
                    DispatchQueue.main.async {
                        let alert = UIAlertController(title: error.localizedDescription, message: "", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {_ in}))
                        self.present(alert, animated: true, completion: nil)
                    }
                } else {
                    UserDefaults.standard.set(true, forKey: "loggedIn")
                    let nextVC = VerificationSuccessViewController()
                    nextVC.modalPresentationStyle = .fullScreen
                    self.navigationController?.pushViewController(nextVC, animated: true)
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
        //confirmPasswordTextField.resignFirstResponder()
    }
}
