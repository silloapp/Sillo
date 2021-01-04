//
//  CreateAccountViewController.swift
//  Sillo
//
//  Created by William Loo on 1/3/21.
//

import UIKit
class CreateAccountViewController: UIViewController {
    //MARK: TODO: add to color file
    let grayColor = UIColor(red: CGFloat(249), green: CGFloat(249), blue: CGFloat(249), alpha: CGFloat(1))
    
    //MARK: instantiate password text field
    let passwordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " Password"
        textField.layer.cornerRadius = 10.0;
        textField.isSecureTextEntry = true
        textField.textContentType = .oneTimeCode
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    //MARK: instantiate confirm password text field
    let confirmPasswordTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " Password"
        textField.layer.cornerRadius = 10.0;
        //textField.backgroundColor = grayColor
        textField.isSecureTextEntry = true
        textField.textContentType = .oneTimeCode
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        
        //MARK: sillo logotype
        let silloLogotype: UIImageView = {
            let image = UIImage(named: "onboardingSillo")
            let imageView = UIImageView(image: image)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        view.addSubview(silloLogotype)
        silloLogotype.widthAnchor.constraint(equalToConstant: 132).isActive = true
        silloLogotype.heightAnchor.constraint(equalToConstant: 61).isActive = true
        silloLogotype.topAnchor.constraint(equalTo: view.topAnchor,constant: 91).isActive = true
        silloLogotype.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 36).isActive = true
        
        //MARK: create account label
        let createAccountLabel: UILabel = {
            let label = UILabel()
            label.font = Font.medium(28)
            label.text = "Create your account"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        view.addSubview(createAccountLabel)
        createAccountLabel.widthAnchor.constraint(equalToConstant: 261).isActive = true
        createAccountLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        createAccountLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 36).isActive = true
        createAccountLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 201).isActive = true
        
        //MARK: school email label
        let schoolEmailLabel: UILabel = {
            let label = UILabel()
            label.font = Font.regular(17)
            label.text = "Enter your school email"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        view.addSubview(schoolEmailLabel)
        schoolEmailLabel.widthAnchor.constraint(equalToConstant: 284).isActive = true
        schoolEmailLabel.heightAnchor.constraint(equalToConstant: 27).isActive = true
        schoolEmailLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 38).isActive = true
        schoolEmailLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 248).isActive = true
        
        //MARK: email text field
        let emailTextField: UITextField = {
            let textField = UITextField()
            textField.placeholder = " youremail@berkeley.edu"
            textField.layer.cornerRadius = 10.0;
            textField.backgroundColor = grayColor
            textField.translatesAutoresizingMaskIntoConstraints = false
            return textField
        }()
        view.addSubview(emailTextField)
        emailTextField.widthAnchor.constraint(equalToConstant: 319).isActive = true
        emailTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        emailTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        emailTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 275).isActive = true
        
        
        //MARK: password label
        let createPasswordLabel: UILabel = {
            let label = UILabel()
            label.font = Font.regular(17)
            label.text = "Create a password"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        view.addSubview(createPasswordLabel)
        createPasswordLabel.widthAnchor.constraint(equalToConstant: 284).isActive = true
        createPasswordLabel.heightAnchor.constraint(equalToConstant: 27).isActive = true
        createPasswordLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 41).isActive = true
        createPasswordLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 356).isActive = true

        //MARK: password text field
        view.addSubview(passwordTextField)
        passwordTextField.widthAnchor.constraint(equalToConstant: 319).isActive = true
        passwordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        passwordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 34).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 385).isActive = true
        
        //MARK: password visiblity toggle
        let passwordVisibilityToggle: UIButton = {
            let button = UIButton()
            let image = UIImage(named:"visibility")
            //button.setBackgroundImage(image, for: .normal)
            button.setImage(image, for: .normal)
            button.addTarget(self, action: #selector(togglePasswordVisibility(_:)), for: .touchUpInside)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.imageView?.contentMode = .scaleAspectFit
            //button.backgroundColor = .lightGray
            return button
        }()
        view.addSubview(passwordVisibilityToggle)
        passwordVisibilityToggle.widthAnchor.constraint(equalToConstant: 24).isActive = true
        passwordVisibilityToggle.heightAnchor.constraint(equalToConstant: 24).isActive = true
        passwordVisibilityToggle.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 327).isActive = true
        passwordVisibilityToggle.topAnchor.constraint(equalTo: view.topAnchor, constant: 349).isActive = true
        
        //MARK: comfirm password label
        let confirmPasswordLabel: UILabel = {
            let label = UILabel()
            label.font = Font.regular(17)
            label.text = "Confirm password"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        view.addSubview(confirmPasswordLabel)
        confirmPasswordLabel.widthAnchor.constraint(equalToConstant: 284).isActive = true
        confirmPasswordLabel.heightAnchor.constraint(equalToConstant: 27).isActive = true
        confirmPasswordLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 41).isActive = true
        confirmPasswordLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 466).isActive = true

        //MARK: confirm password text field
        view.addSubview(confirmPasswordTextField)
        confirmPasswordTextField.widthAnchor.constraint(equalToConstant: 319).isActive = true
        confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        confirmPasswordTextField.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 34).isActive = true
        confirmPasswordTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 495).isActive = true

        //MARK: terms text view
        let termsTextView: UITextView = {
            let view = UITextView()
            view.isEditable = false
            view.font = Font.regular(13)
            view.text = "By creating an account, you are indicating that you have read and acknowledged the Terms of Service and Privacy Policy."
            view.translatesAutoresizingMaskIntoConstraints = false
            return view
        }()
        view.addSubview(termsTextView)
        termsTextView.widthAnchor.constraint(equalToConstant: 310).isActive = true
        termsTextView.heightAnchor.constraint(equalToConstant: 53).isActive = true
        termsTextView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 41).isActive = true
        termsTextView.topAnchor.constraint(equalTo: view.topAnchor, constant: 574).isActive = true
        
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
        view.addSubview(nextButton)
        nextButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 39).isActive = true
        nextButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 732).isActive = true

    }
    @objc func togglePasswordVisibility(_:UIButton) {
        passwordTextField.isSecureTextEntry.toggle()
        confirmPasswordTextField.isSecureTextEntry.toggle()
    }
    
    @objc func nextClicked(_:UIButton) {
        print("BUSINESS LOGIC")
    }

}
