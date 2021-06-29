//
//  SetupOrganizationViewController.swift
//  Sillo
//
//  Created by Eashan Mathur on 1/10/21.
//

import Foundation
import UIKit

//MARK: Figma #1338

class SetupOrganizationViewController: UIViewController, UIGestureRecognizerDelegate, UITextFieldDelegate {

    var bar = UIProgressView()
    var nextButton = UIButton()
    var picButton = UIButton()
    var imagePicker: UIImagePickerController!
    var orgNameField = UITextField()
    var orgImage:UIImage? = nil
    
    //MARK: ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector:#selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        orgNameField.addTarget(self, action: #selector(self.textFieldDidEndEditing(_:)), for: .editingChanged)
        navigationController?.navigationBar.isHidden = false
        
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .photoLibrary

        configureNavBar()
        setupProgressBar()
        setupView()
    }

    
//    //MARK: Prevents NavBar header from showing up when going back to root VC
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: animated);
//        super.viewWillDisappear(animated)
//    }
//
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)

    }
    
    func configureNavBar() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.navigationBar.barTintColor = .white
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
    }
    
    
    func setupProgressBar() {

        bar.trackTintColor = Color.gray
        bar.progressTintColor = Color.buttonClickable
        bar.setProgress(1/4, animated: true)
        view.addSubview(bar)
        
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        bar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bar.heightAnchor.constraint(equalToConstant: 3).isActive = true
    }
    

    func setupView() {
        
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.axis = .vertical
        stack.spacing = 20
        view.addSubview(stack)
        
        let header = UILabel()
        header.text = "Set up your organization’s profile"
        header.font = UIFont(name: "Apercu-Medium", size: dynamicFontSize(22))
        header.adjustsFontSizeToFitWidth = true
        header.textColor = Color.textSemiBlack
        header.numberOfLines = 1
        stack.addArrangedSubview(header)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 300/375).isActive = true

        let hStack = UIStackView()
        hStack.distribution = .fillProportionally
        hStack.alignment = .center
        hStack.axis = .horizontal
        hStack.spacing = 20
        stack.addArrangedSubview(hStack)
        
        hStack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15).isActive = true
        hStack.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 1).isActive = true
        
        picButton.setImage(UIImage(named: "addPhoto"), for: .normal)
        picButton.contentMode = .scaleAspectFit
        picButton.addTarget(self, action: #selector(choosePic), for: .touchUpInside)
        picButton.layer.cornerRadius = 0.5 * picButton.bounds.size.width
        picButton.clipsToBounds = true
        
        orgNameField.backgroundColor = Color.textFieldBackground
        orgNameField.textColor = Color.textSemiBlack
        orgNameField.attributedPlaceholder = NSAttributedString(string:"Organization name", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: CGFloat(249/255), green: CGFloat(249/255), blue: CGFloat(249/255), alpha: CGFloat(0.5))])
        orgNameField.attributedPlaceholder = NSAttributedString(string: "Organization name", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont(name: "Apercu-Regular", size: 16)
        ])
        orgNameField.layer.sublayerTransform = CATransform3DMakeTranslation(19, 0, 0)
        orgNameField.font = UIFont(name: "Apercu-Regular", size: dynamicFontSize(17))
        orgNameField.placeholder = "Organization name"
        orgNameField.clipsToBounds = true
        orgNameField.layer.cornerRadius = 5
        orgNameField.delegate = self
        orgNameField.becomeFirstResponder()
        
        hStack.addArrangedSubview(picButton)
        hStack.addArrangedSubview(orgNameField)
        
        orgNameField.widthAnchor.constraint(equalTo: hStack.widthAnchor, multiplier: 0.76).isActive = true
        orgNameField.heightAnchor.constraint(equalTo: hStack.heightAnchor, multiplier: 30/71).isActive = true
        picButton.widthAnchor.constraint(equalTo: orgNameField.heightAnchor).isActive = true
        picButton.heightAnchor.constraint(equalTo: orgNameField.heightAnchor).isActive = true
        
        nextButton.backgroundColor = Color.buttonClickableUnselected
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "Apercu-Bold", size: dynamicFontSize(20))
        nextButton.isEnabled = false
        nextButton.layer.cornerRadius = 5
        nextButton.addTarget(self, action: #selector(nextClicked), for: .touchUpInside)
        stack.addArrangedSubview(nextButton)
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 52/809).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
    }
    
    @objc func nextClicked() {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .fade
        self.navigationController?.view.layer.add(transition, forKey: nil)

        let destVC = AddPeopleToSpaceViewController()

        destVC.orgNameString = orgNameField.text!
        destVC.orgImage = orgImage

        navigationController?.pushViewController(destVC, animated: false)
    }

    @objc func choosePic() {
        present(imagePicker, animated: true, completion: nil)
    }
    
    //MARK: Handle positioning of NEXT button - adaptive to keyboard size
    @objc func keyboardWillShow(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -(keyboardRectangle.height + 8)).isActive = true
        }
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if (!orgNameField.text!.trimmingCharacters(in: .whitespaces).isEmpty) {
            nextButton.isEnabled = true
            nextButton.backgroundColor = Color.buttonClickable
            organizationData.newOrganizationName = orgNameField.text!
        }
        else {
            self.nextButton.isEnabled = false
            nextButton.backgroundColor = Color.buttonClickableUnselected
        }
    }
    
    //MARK: Textfield button selection/deselection
    func textFieldDidEndEditing(_ textField: UITextField) {
        if (!orgNameField.text!.trimmingCharacters(in: .whitespaces).isEmpty) {
            nextButton.isEnabled = true
            nextButton.backgroundColor = Color.buttonClickable
            organizationData.newOrganizationName = orgNameField.text!
        }
        else {
            self.nextButton.isEnabled = false
            nextButton.backgroundColor = Color.buttonClickableUnselected
        }
    }

}

extension SetupOrganizationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            orgImage = image
            self.picButton.setImage(image, for: .normal)
            self.picButton.layer.cornerRadius = 0.5 * picButton.bounds.size.width
            self.picButton.clipsToBounds = true
            organizationData.newOrganizationPic = image
        }
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
}
