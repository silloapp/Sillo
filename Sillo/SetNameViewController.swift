//
//  SetNameViewController.swift
//  Sillo
//
//  Created by William Loo on 1/14/21.
//

import UIKit

//MARK: figma screen 1265
class SetNameViewController: UIViewController {
    
    //MARK: init first name text field
    let firstNameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " ie. Angelica"
        textField.layer.cornerRadius = 10.0;
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    //MARK: init last name text field
    let lastNameField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " ie. Pan"
        textField.layer.cornerRadius = 10.0;
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
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
        scrollView.contentSize = CGSize(width: 0, height: 896.0)
    }
    //MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .white
        
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
        
        //MARK: what's your name label
        let nameLabel: UILabel = {
            let label = UILabel()
            label.font = Font.medium(dynamicFontSize(28))
            label.text = "What's your name?"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        scrollView.addSubview(nameLabel)
        nameLabel.widthAnchor.constraint(equalToConstant: 261).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 36).isActive = true
        nameLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 36).isActive = true
        nameLabel.topAnchor.constraint(equalTo: silloLogotype.topAnchor, constant: 119).isActive = true
        
        //MARK: body label
        let bodyLabel: UILabel = {
            let label = UILabel()
            label.numberOfLines = 0
            label.font = Font.regular(dynamicFontSize(17))
            label.text = "Please use your real name - this will be displayed onced you reveal. You will not be able to change this."
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        scrollView.addSubview(bodyLabel)
        bodyLabel.widthAnchor.constraint(equalToConstant: 291).isActive = true
        bodyLabel.heightAnchor.constraint(equalToConstant: 63).isActive = true
        bodyLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 36).isActive = true
        bodyLabel.topAnchor.constraint(equalTo: nameLabel.topAnchor, constant: 51).isActive = true
        
        //MARK: first name label
        let firstNameLabel: UILabel = {
            let label = UILabel()
            label.font = Font.regular(dynamicFontSize(17))
            label.text = "First Name"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        scrollView.addSubview(firstNameLabel)
        firstNameLabel.widthAnchor.constraint(equalToConstant: 284).isActive = true
        firstNameLabel.heightAnchor.constraint(equalToConstant: 27).isActive = true
        firstNameLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 38).isActive = true
        firstNameLabel.topAnchor.constraint(equalTo: bodyLabel.topAnchor, constant: 99).isActive = true
        
        //MARK: first name text field
        scrollView.addSubview(firstNameField)
        firstNameField.backgroundColor = Color.textFieldBackground
        firstNameField.widthAnchor.constraint(equalToConstant: 319).isActive = true
        firstNameField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        firstNameField.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 32).isActive = true
        firstNameField.topAnchor.constraint(equalTo: firstNameLabel.topAnchor, constant: 25).isActive = true
        
        //MARK: last name label
        let lastNameLabel: UILabel = {
            let label = UILabel()
            label.font = Font.regular(dynamicFontSize(17))
            label.text = "Last Name"
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        scrollView.addSubview(lastNameLabel)
        lastNameLabel.widthAnchor.constraint(equalToConstant: 284).isActive = true
        lastNameLabel.heightAnchor.constraint(equalToConstant: 27).isActive = true
        lastNameLabel.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 38).isActive = true
        lastNameLabel.topAnchor.constraint(equalTo: firstNameField.topAnchor, constant: 68).isActive = true

        //MARK: last name text field
        scrollView.addSubview(lastNameField)
        lastNameField.backgroundColor = Color.textFieldBackground
        lastNameField.widthAnchor.constraint(equalToConstant: 319).isActive = true
        lastNameField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        lastNameField.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 34).isActive = true
        lastNameField.topAnchor.constraint(equalTo: lastNameLabel.topAnchor, constant: 29).isActive = true

        //MARK: next button
        let nextButton: UIButton = {
            let button = UIButton()
            button.layer.cornerRadius = 8
            button.setTitle("Next", for: .normal)
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
        nextButton.topAnchor.constraint(equalTo: lastNameField.topAnchor, constant: 74).isActive = true
    }
    
    //MARK: next clicked
    @objc func nextClicked(_:UIButton) {
        var errorState = false
        var errorMsg = "Oops, something unexpected happened! Please contact the Sillo team"
        
        if (firstNameField.hasText && lastNameField.hasText) {
            let firstName = firstNameField.text!
            let lastName = lastNameField.text!
            let displayName = "\(firstName) \(lastName)"
            let nextVC = NameChangeProcessingViewController()
            nextVC.displayName = displayName
            nextVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(nextVC, animated: true)
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
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
    }

}

