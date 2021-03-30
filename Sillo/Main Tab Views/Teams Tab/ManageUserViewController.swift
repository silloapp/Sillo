//
//  ManageUserViewController.swift
//  Sillo
//
//  Created by William Loo on 3/26/21.
//

import Foundation
import FirebaseAuth

class ManageUserViewController: UIViewController {
    var userID = ""
    var username = "User Name"
    var email = "user email @ sillo.co"
    var profilePic: UIImage = UIImage(named:"avatar-4")!
    var userIsAdmin = false
    
    //MARK: init profilePic
    let profilepic: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 50 // make circle
        return imageView
    }()
    
    //MARK: name label
    let nameLabel:UILabel = {
        let label = UILabel()
        label.contentMode = .center
        label.text = "NAME GOES HERE"
        label.font = Font.bold(20)
        label.textColor = Color.matte
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: email label
    let emailLabel:UILabel = {
        let label = UILabel()
        label.contentMode = .center
        label.text = "EMAIL@gobears.edu"
        label.font = Font.regular(17)
        label.textColor = Color.matte
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: admin manage button
    let adminManageButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = Color.buttonClickable
        button.setTitle("Add as admin", for: .normal)
        button.titleLabel?.font = Font.bold(20)
        button.isEnabled = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(adminAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    @objc func adminAction() {
        var adminActionText  = "Add Admin?"
        var adminDescriptionText = "Please confirm that you would like to add \(username) as an admin."
        var adminFunction = organizationData.promoteMember
        
        if userIsAdmin {
            adminActionText  = "Remove Admin?"
            adminDescriptionText = "Please confirm that you would like to remove \(username) as an admin."
            adminFunction = organizationData.demoteMember
        }
        
        DispatchQueue.main.async {
            let alert = AlertView(headingText: adminActionText, messageText: adminDescriptionText, action1Label: "Cancel", action1Color: Color.buttonClickableUnselected, action1Completion: {
                self.dismiss(animated: true, completion: nil)
            }, action2Label: "Confirm", action2Color: Color.buttonClickable, action2Completion: {adminFunction(self.userID);self.dismiss(animated: true, completion: nil)
            }, withCancelBtn: false, image: nil, withOnlyOneAction: false)
            alert.modalPresentationStyle = .overCurrentContext
            alert.modalTransitionStyle = .crossDissolve
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: remove member button
    let removeMemberButton:UIButton = {
        let button = UIButton()
        button.backgroundColor = Color.salmon
        button.setTitle("Remove member", for: .normal)
        button.titleLabel?.font = Font.bold(20)
        button.isEnabled = true
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(removeAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    @objc func removeAction() {
        let removeActionText = "Remove Member?"
        let removeDescriptionText = "Are you sure you want to remove \(username) from \(organizationData.currOrganizationName!)?"
        DispatchQueue.main.async {
            let alert = AlertView(headingText: removeActionText, messageText: removeDescriptionText, action1Label: "No", action1Color: Color.buttonClickableUnselected, action1Completion: {
                self.dismiss(animated: true, completion: nil)
            }, action2Label: "Yes", action2Color: Color.buttonClickable, action2Completion: {organizationData.removeMemberFromCurrentOrganization(userID: self.userID);self.dismiss(animated: true, completion: nil)
            }, withCancelBtn: false, image: nil, withOnlyOneAction: false)
            alert.modalPresentationStyle = .overCurrentContext
            alert.modalTransitionStyle = .crossDissolve
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    //MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        
        //MARK: stack
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.axis = .vertical
        stack.spacing = 15
        stack.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(stack)
        stack.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        
        //MARK: add profile pic to stack
        profilepic.image = profilePic
        let maskImageView = UIImageView()
        maskImageView.contentMode = .scaleAspectFit
        maskImageView.image = UIImage(named: "profile_mask")
        maskImageView.frame = CGRect(x: 0, y: 0, width: 150, height: 150)
        profilepic.mask = maskImageView
        stack.addArrangedSubview(profilepic)
        profilepic.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profilepic.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        //MARK: text stack
        let textStack = UIStackView()
        textStack.distribution = .equalSpacing
        textStack.alignment = .center
        textStack.axis = .vertical
        textStack.spacing = 5
        textStack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(textStack)
        textStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        //MARK: add name label
        nameLabel.text = username
        textStack.addArrangedSubview(nameLabel)
        
        //MARK: add email label
        emailLabel.text = email
        textStack.addArrangedSubview(emailLabel)
        
        let buttonStack = UIStackView()
        buttonStack.distribution = .equalSpacing
        buttonStack.alignment = .center
        buttonStack.axis = .vertical
        buttonStack.spacing = 10
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(buttonStack)
        buttonStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonStack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        //MARK: add admin button
        userIsAdmin = Array(organizationData.currOrganizationAdmins.keys).contains(userID)
        if userIsAdmin {
            adminManageButton.setTitle("Remove admin", for: .normal)
        }
        buttonStack.addArrangedSubview(adminManageButton)
        adminManageButton.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5).isActive = true
        
        //MARK: add remove button
        buttonStack.addArrangedSubview(removeMemberButton)
        removeMemberButton.widthAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.5).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = ViewBgColor
        setNavBar()
        NotificationCenter.default.addObserver(self, selector: #selector(self.didFinishAction(note:)), name: Notification.Name("finishUserManagementAction"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.profilePictureLoaded(note:)), name: Notification.Name("refreshPicture"), object: nil)
    }
    
    @objc func didFinishAction(note:NSNotification) {
        self.view.layoutIfNeeded()
        DispatchQueue.main.async {
            let alert = AlertView(headingText: "User Action Complete", messageText: "Requested action complete.", action1Label: "Okay", action1Color: Color.buttonClickable, action1Completion: {
                self.dismiss(animated: true, completion: nil);self.goBack()
            }, action2Label: "NIL", action2Color: Color.buttonClickable, action2Completion: {
            }, withCancelBtn: false, image: nil, withOnlyOneAction: true)
            alert.modalPresentationStyle = .overCurrentContext
            alert.modalTransitionStyle = .crossDissolve
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @objc func profilePictureLoaded(note:NSNotification) {
        if let all = imageCache.value(forKey: "allObjects") as? NSArray {
            for object in all {
                print("object is \(object)")
            }
        }
        let imageRef = "profiles/\(userID)\(Constants.image_extension)"
        if let cachedImage = imageCache.object(forKey: imageRef as NSString) {
            print("STILL CACHED ")
            profilepic.image = cachedImage
            imageCache.setObject(cachedImage, forKey: imageRef as NSString)
        }
    }
    
    //MARK: set nav bar
    func setNavBar() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 242/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        self.title = username
        let textAttributes = [NSAttributedString.Key.foregroundColor:Color.burple]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        //Setting Buttons :
        
        let backbutton = UIButton(type: UIButton.ButtonType.custom)
        backbutton.setImage(UIImage(named: "back"), for: .normal)
        backbutton.addTarget(self, action:#selector(goBack), for: .touchUpInside)
        backbutton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let barbackbutton = UIBarButtonItem(customView: backbutton)
        self.navigationItem.leftBarButtonItems = [barbackbutton]
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }
}
