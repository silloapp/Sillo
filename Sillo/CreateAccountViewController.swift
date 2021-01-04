//
//  CreateAccountViewController.swift
//  Sillo
//
//  Created by William Loo on 1/3/21.
//

import UIKit
class CreateAccountViewController: UIViewController {
    //MARK: TODO: add to color file
    let grayColor = UIColor(red: CGFloat(249/255), green: CGFloat(249/255), blue: CGFloat(249/255), alpha: CGFloat(0.05))
    
    //MARK: instantiate password text field
    var passwordTextField: UITextField = {
        let ptextField = UITextField()
        ptextField.placeholder = " Password"
        ptextField.layer.cornerRadius = 10.0;
        ptextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        ptextField.isSecureTextEntry = true
        ptextField.textContentType = .oneTimeCode
        ptextField.translatesAutoresizingMaskIntoConstraints = false
        return ptextField
    }()
    
    //MARK: instantiate confirm password text field
    var confirmPasswordTextField: UITextField = {
        let ctextField = UITextField()
        ctextField.placeholder = " Password"
        ctextField.layer.cornerRadius = 10.0;
        ctextField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        ctextField.isSecureTextEntry = true
        ctextField.textContentType = .oneTimeCode
        ctextField.translatesAutoresizingMaskIntoConstraints = false
        return ctextField
    }()
    
    //MARK: Scroll view
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    override func viewDidAppear(_ animated: Bool) {
        let screensize: CGRect = UIScreen.main.bounds
        let screenWidth = screensize.width
        let screenHeight = screensize.height
        scrollView.contentSize = CGSize(width: screenWidth, height: screenHeight)
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        let tap = UITapGestureRecognizer(target: scrollView, action: #selector(UIView.endEditing))
        view.addGestureRecognizer(tap)

        view.addSubview(scrollView)
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 1.0).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor, constant: 1.0).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -1.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -1.0).isActive = true
        scrollView.isScrollEnabled = true

        
        //MARK: sillo logotype
        let silloLogotype: UIImageView = {
            let image = UIImage(named: "onboardingSillo")
            let imageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        scrollView.addSubview(silloLogotype)
        silloLogotype.widthAnchor.constraint(equalToConstant: 132).isActive = true
        silloLogotype.heightAnchor.constraint(equalToConstant: 61).isActive = true
        silloLogotype.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: 91).isActive = true
        silloLogotype.leftAnchor.constraint(equalTo: scrollView.leftAnchor,constant: 36).isActive = true
        
        //MARK: create account label
        let createAccountLabel: UILabel = {
            let label = UILabel()
            label.font = Font.medium(28)
            label.text = "Create your account"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        scrollView.addSubview(createAccountLabel)
        createAccountLabel.widthAnchor.constraint(equalToConstant: 261).isActive = true
        createAccountLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        createAccountLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 36).isActive = true
        createAccountLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 201).isActive = true
        
        //MARK: school email label
        let schoolEmailLabel: UILabel = {
            let label = UILabel()
            label.font = Font.regular(17)
            label.text = "Enter your school email"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        scrollView.addSubview(schoolEmailLabel)
        schoolEmailLabel.widthAnchor.constraint(equalToConstant: 284).isActive = true
        schoolEmailLabel.heightAnchor.constraint(equalToConstant: 27).isActive = true
        schoolEmailLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 38).isActive = true
        schoolEmailLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 248).isActive = true
        
        //MARK: email text field
        let emailTextField: UITextField = {
            let textField = UITextField()
            textField.placeholder = " youremail@berkeley.edu"
            textField.layer.cornerRadius = 10.0;
            textField.backgroundColor = grayColor
            textField.keyboardType = UIKeyboardType.emailAddress
            textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
            textField.translatesAutoresizingMaskIntoConstraints = false
            return textField
        }()
        scrollView.addSubview(emailTextField)
        emailTextField.widthAnchor.constraint(equalToConstant: 319).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 32).isActive = true
        emailTextField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 275).isActive = true
        
        
        //MARK: password label
        let createPasswordLabel: UILabel = {
            let label = UILabel()
            label.font = Font.regular(17)
            label.text = "Create a password"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        scrollView.addSubview(createPasswordLabel)
        createPasswordLabel.widthAnchor.constraint(equalToConstant: 284).isActive = true
        createPasswordLabel.heightAnchor.constraint(equalToConstant: 27).isActive = true
        createPasswordLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 41).isActive = true
        createPasswordLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 356).isActive = true

        //MARK: password text field
        passwordTextField.keyboardType = .default
        passwordTextField.backgroundColor = grayColor
        scrollView.addSubview(passwordTextField)
        passwordTextField.widthAnchor.constraint(equalToConstant: 319).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 34).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 385).isActive = true
        
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
        passwordVisibilityToggle.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 349).isActive = true
        
        //MARK: confirm password label
        let confirmPasswordLabel: UILabel = {
            let label = UILabel()
            label.font = Font.regular(17)
            label.text = "Confirm password"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        scrollView.addSubview(confirmPasswordLabel)
        confirmPasswordLabel.widthAnchor.constraint(equalToConstant: 284).isActive = true
        confirmPasswordLabel.heightAnchor.constraint(equalToConstant: 27).isActive = true
        confirmPasswordLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 41).isActive = true
        confirmPasswordLabel.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 466).isActive = true

        //MARK: confirm password text field
        confirmPasswordTextField.keyboardType = .default
        confirmPasswordTextField.backgroundColor = grayColor
        scrollView.addSubview(confirmPasswordTextField)
        confirmPasswordTextField.widthAnchor.constraint(equalToConstant: 319).isActive = true
        confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        confirmPasswordTextField.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 34).isActive = true
        confirmPasswordTextField.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 495).isActive = true

        //MARK: terms text view
        let termsTextView: UITextView = {
            let view = UITextView()
            view.isEditable = false
            view.isScrollEnabled = false
            view.font = Font.regular(13)
            view.textColor = grayColor
            view.text = "By creating an account, you are indicating that you have read and acknowledged the Terms of Service and Privacy Policy."
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        scrollView.addSubview(termsTextView)
        termsTextView.widthAnchor.constraint(equalToConstant: 310).isActive = true
        termsTextView.heightAnchor.constraint(equalToConstant: 73).isActive = true
        termsTextView.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 41).isActive = true
        termsTextView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 574).isActive = true
        
        //MARK: next button
        let nextButton: UIButton = {
            let button = UIButton()
            button.setTitle("Next", for: .normal)
            button.setTitleColor(.black, for: .normal)
            button.backgroundColor = .lightGray
            button.addTarget(self, action: #selector(nextClicked(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            return button
        }()
        scrollView.addSubview(nextButton)
        nextButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 39).isActive = true
        nextButton.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 732).isActive = true

    }
    @objc func togglePasswordVisibility(_:UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        confirmPasswordTextField.isSecureTextEntry.toggle()
    }
    
    @objc func nextClicked(_:UIButton) {
        print("BUSINESS LOGIC")
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
            scrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
    }

}
