//
//  AddPeopleToSpaceViewController.swift
//  Sillo
//
//  Created by Eashan Mathur on 1/13/21.
//

import UIKit

class AddPeopleToSpaceViewController: UIViewController, UIGestureRecognizerDelegate, UITextViewDelegate {

    //MARK: Figma #1221

    var onboardingMode = true
    
    var bar = UIProgressView()
    var orgNameString:String? = nil
    var orgImage:UIImage? = nil
    var emailTextView = UITextView()
    var nextButton = UIButton()
    var prefilledText:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap)
        
        setupProgressBar()
        setupView()
    }
    @objc func hideKeyboard() {
        emailTextView.resignFirstResponder()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        populateTextView()
        setNavBar()
    }
    
    func setNavBar() {
        
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 242/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        self.title = "People"
        let textAttributes = [NSAttributedString.Key.foregroundColor:Color.burple]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        //Setting Buttons :
        
        let backbutton = UIButton(type: UIButton.ButtonType.custom)
        backbutton.setImage(UIImage(named: "back"), for: .normal)
        backbutton.addTarget(self, action:#selector(callMethod), for: .touchUpInside)
        backbutton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let barbackbutton = UIBarButtonItem(customView: backbutton)
        self.navigationItem.leftBarButtonItems = [barbackbutton]
        
    }
    
    @objc func callMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    func setupProgressBar() {
        bar.trackTintColor = Color.gray
        bar.progressTintColor = Color.buttonClickable
        bar.setProgress(2/4, animated: true)
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
        stack.spacing = 15
        view.addSubview(stack)
        
        let header = UILabel()
        header.text = "Add people to this space"
        header.font = UIFont(name: "Apercu Medium", size: dynamicFontSize(22))
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
        hStack.spacing = 25
        stack.addArrangedSubview(hStack)
        
        hStack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15).isActive = true
        hStack.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 1).isActive = true
        
        // TODO: change added photos
        let addPhotoImage = UIImageView()
        addPhotoImage.image = orgImage ?? UIImage(named: "addPhoto")
        addPhotoImage.contentMode = .scaleAspectFit
        addPhotoImage.layer.cornerRadius = 0.5 * addPhotoImage.bounds.size.width
        addPhotoImage.clipsToBounds = true
        
        let orgName = UILabel()
        orgName.text = orgNameString ?? "Organization"
        orgName.textColor = Color.textSemiBlack
        orgName.font = UIFont(name: "Apercu Medium", size: dynamicFontSize(22))
        
        hStack.addArrangedSubview(addPhotoImage)
        hStack.addArrangedSubview(orgName)
        
        orgName.widthAnchor.constraint(equalTo: hStack.widthAnchor, multiplier: 0.7).isActive = true
        orgName.heightAnchor.constraint(equalTo: hStack.heightAnchor, multiplier: 30/71).isActive = true
        addPhotoImage.widthAnchor.constraint(equalTo: orgName.heightAnchor).isActive = true
        addPhotoImage.heightAnchor.constraint(equalTo: orgName.heightAnchor).isActive = true
        addPhotoImage.layer.cornerRadius = 0.5 * addPhotoImage.bounds.size.width
        addPhotoImage.clipsToBounds = true
        
        let instructionLabel = UILabel()
        instructionLabel.text = "Please separate multiple email addresses with commas"
        instructionLabel.font = UIFont(name: "Apercu Regular", size: dynamicFontSize(17))
        instructionLabel.adjustsFontSizeToFitWidth = true
        instructionLabel.textColor = Color.textSemiBlack
        instructionLabel.numberOfLines = 1
        stack.addArrangedSubview(instructionLabel)
        
        // set up stack view for text view
        let textStack = UIStackView()
        textStack.distribution = .fillProportionally
        textStack.alignment = .center
        textStack.axis = .horizontal
        //textStack.spacing = 10w
        stack.addArrangedSubview(textStack)
        
        textStack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15).isActive = true
        textStack.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 1).isActive = true
        
        textStack.addArrangedSubview(emailTextView)
        
        // add text view
        emailTextView.delegate = self
        
        emailTextView.translatesAutoresizingMaskIntoConstraints = false
        emailTextView.autocorrectionType = .no
        emailTextView.text = "name@domain.com, name@domain.com"
        emailTextView.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
        emailTextView.textColor = .secondaryLabel
        emailTextView.font = UIFont(name: "Apercu Regular", size: 17)
        emailTextView.layer.cornerRadius = 10
        emailTextView.isScrollEnabled = true
        emailTextView.textContainerInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
        emailTextView.isEditable = true
//        emailTextView.keyboardType = .emailAddress
        
        emailTextView.heightAnchor.constraint(equalTo: textStack.heightAnchor, multiplier: 1).isActive = true
        emailTextView.widthAnchor.constraint(equalTo: textStack.widthAnchor, multiplier: 1).isActive = true
        
        
        // add next button
        stack.addArrangedSubview(nextButton)
        nextButton.isEnabled = false
        nextButton.backgroundColor = Color.buttonClickableUnselected
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = UIFont(name: "Apercu Bold", size: dynamicFontSize(20))
        nextButton.layer.cornerRadius = 5
        nextButton.addTarget(self, action: #selector(nextClicked), for: .touchUpInside)
        
        nextButton.translatesAutoresizingMaskIntoConstraints = false
        nextButton.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        nextButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 52/810).isActive = true
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func populateTextView() {
        var i = 0
        self.prefilledText = ""
        while (organizationData.memberInvites != nil && !organizationData.memberInvites!.isEmpty && i < organizationData.memberInvites!.count) {
            let email = organizationData.memberInvites![i]
            if i+1 < organizationData.memberInvites!.count {
                self.prefilledText+=email+","
            }
            else {
                self.prefilledText+=email
                self.emailTextView.textColor = Color.matte
                self.emailTextView.text = self.prefilledText
                self.nextButton.isEnabled = true
                self.nextButton.backgroundColor = Color.buttonClickable
            }
            i+=1
        }
    }
    
    
    @objc func nextClicked() {
        let lowercasedInput = emailTextView.text.lowercased()
        organizationData.makeEmailArray(input: lowercasedInput)
        let preFilteredEmailCount = lowercasedInput.filter {$0 != " " && $0 != "\n"}.components(separatedBy: ",").count
        if preFilteredEmailCount != organizationData.memberInvites?.count {
            DispatchQueue.main.async {
                let alert = AlertView(headingText: "Email Typo Detected!", messageText: "One or more of your emails is misspelled and will not be invited.", action1Label: "Okay", action1Color: Color.burple, action1Completion: {
                    self.dismiss(animated: true, completion: nil)
                }, action2Label: "Nil", action2Color: .gray, action2Completion: {
                }, withCancelBtn: false, image: nil, withOnlyOneAction: true)
                alert.modalPresentationStyle = .overCurrentContext
                alert.modalTransitionStyle = .crossDissolve
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        
        if organizationData.memberInvites!.contains(Constants.EMAIL!) {
            DispatchQueue.main.async {
                let alert = AlertView(headingText: "Inviting yourself?", messageText: "There's no need to invite yourself, you're automatically included as the admin of your new space.", action1Label: "Okay", action1Color: Color.burple, action1Completion: {
                    self.dismiss(animated: true, completion: nil)
                }, action2Label: "Nil", action2Color: .gray, action2Completion: {
                }, withCancelBtn: false, image: nil, withOnlyOneAction: true)
                alert.modalPresentationStyle = .overCurrentContext
                alert.modalTransitionStyle = .crossDissolve
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .fade
        self.navigationController?.view.layer.add(transition, forKey: nil)

        let destVC = ConfirmEmailViewController()
        
        if (!self.onboardingMode) {
            destVC.onboardingMode = false
        }

        navigationController?.pushViewController(destVC, animated: false)
    }
    
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        emailTextView.text = self.prefilledText
        emailTextView.textColor = Color.matte
    }
    
    func textViewDidChange(_ textView: UITextView) {
        if (!emailTextView.text.trimmingCharacters(in: .whitespaces).isEmpty) {
            nextButton.isEnabled = true
            nextButton.backgroundColor = Color.buttonClickable
        }
        else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = Color.buttonClickableUnselected
        }
    }
    
    private func textViewDidEndEditing(_ textField: UITextField) {
        if (!emailTextView.text.trimmingCharacters(in: .whitespaces).isEmpty) {
            nextButton.isEnabled = true
            nextButton.backgroundColor = Color.buttonClickable
        }
        else {
            nextButton.isEnabled = false
            nextButton.backgroundColor = Color.buttonClickableUnselected
        }
    }
}
