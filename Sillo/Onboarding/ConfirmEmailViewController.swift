//
//  ViewController.swift
//  Sillo
//
//  Created by Chi Tsai on 2/14/21.
//

import UIKit

class ConfirmEmailViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {

    // MARK: Figma 1224
    
    var onboardingMode = true
    
    var bar = UIProgressView()
    var emailTableView = UITableView()
    var confirmButton = UIButton()
    let memberInvites:[String] = organizationData.memberInvites ?? []
    
    private var latestButtonPressTimestamp: Date = Date()-2.0
    private var DEBOUNCE_LIMIT: Double = 2.0 //in seconds
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupProgressBar()
        setUpView()
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
    
    //MARK: Prevents NavBar header from showing up when going back to root VC
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated);
        super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
        NotificationCenter.default.addObserver(self, selector: #selector(self.creationSuccess(note:)), name: Notification.Name("OrganizationCreationSuccess"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.creationFail(note:)), name: Notification.Name("OrganizationCreationFail"), object: nil)
    }
    

    func setupProgressBar() {
        bar.trackTintColor = Color.gray
        bar.progressTintColor = Color.buttonClickable
        bar.setProgress(3/4, animated: true)
        view.addSubview(bar)
        
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        bar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bar.heightAnchor.constraint(equalToConstant: 3).isActive = true
    }

    func setUpView() {
        // TODO: change weird spacing between "Invitations" and instructions
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.axis = .vertical
        stack.spacing = 10
        view.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 300/375).isActive = true
        stack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15).isActive = true
        
        let instructionsLabel = UILabel()
        instructionsLabel.text = "Please review and confirm this list of emails to add members to your space"
        instructionsLabel.font = UIFont(name: "Apercu Medium", size: dynamicFontSize(17))
        instructionsLabel.adjustsFontSizeToFitWidth = true
        instructionsLabel.textColor = Color.textSemiBlack
        instructionsLabel.numberOfLines = 3
        stack.addArrangedSubview(instructionsLabel)
        
        let invitationsLabel = UILabel()
        invitationsLabel.text = "Invitations"
        invitationsLabel.font = UIFont(name: "Apercu Medium", size: dynamicFontSize(22))
        invitationsLabel.adjustsFontSizeToFitWidth = true
        invitationsLabel.textColor = Color.textSemiBlack
        invitationsLabel.numberOfLines = 1
        stack.addArrangedSubview(invitationsLabel)
        invitationsLabel.leadingAnchor.constraint(equalTo: stack.leadingAnchor).isActive = true
    
        view.addSubview(emailTableView)
        view.addSubview(confirmButton)
        
        emailTableView.register(UITableViewCell.self, forCellReuseIdentifier: "emailCell")
        emailTableView.delegate = self
        emailTableView.dataSource = self
        emailTableView.contentSize = CGSize(width: self.view.safeAreaLayoutGuide.layoutFrame.width, height: emailTableView.contentSize.height);
        emailTableView.alwaysBounceHorizontal = false
        
        emailTableView.backgroundColor = .white
        emailTableView.tableHeaderView = UIView()
        emailTableView.translatesAutoresizingMaskIntoConstraints = false

        emailTableView.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor, multiplier: 0.9).isActive = true
        emailTableView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.65).isActive = true
        emailTableView.topAnchor.constraint(equalTo: stack.bottomAnchor).isActive = true
        emailTableView.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        confirmButton.backgroundColor = Color.buttonClickable
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.titleLabel?.font = UIFont(name: "Apercu Bold", size: dynamicFontSize(20))
        confirmButton.isEnabled = true
        confirmButton.layer.cornerRadius = 5
        confirmButton.addTarget(self, action: #selector(confirmClicked), for: .touchUpInside)
        
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmButton.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        confirmButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 52/810).isActive = true
        confirmButton.topAnchor.constraint(equalTo: emailTableView.bottomAnchor, constant: 10).isActive = true
    }
    
    @objc func confirmClicked() {
        let requestThrottled: Bool = -self.latestButtonPressTimestamp.timeIntervalSinceNow < self.DEBOUNCE_LIMIT
        
        if (requestThrottled) {
            return
        }
        self.latestButtonPressTimestamp = Date()
        if self.onboardingMode {
            organizationData.createNewOrganization()
        }
        else {
            // not onboarding mode, invite return to peopleVC
            organizationData.inviteMembers(organizationID: organizationData.currOrganization!, organizationName: organizationData.currOrganizationName!, emails: memberInvites )
            let controller = self.navigationController?.viewControllers[(self.navigationController?.viewControllers.count)! - 3]
            self.navigationController?.popToViewController(controller!, animated: true)
            organizationData.memberInvites = []
        }
        
        return
    }
    
    @objc func creationSuccess(note:NSNotification) {
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .fade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        
        self.navigationController?.pushViewController(ProfilePromptViewController(), animated: true)
    }
    
    @objc func creationFail(note:NSNotification) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: "Oops!", message: "Something went wrong with creating your organization. Please try again later.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {_ in}))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberInvites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: change the margins of the text to be spaced out
        let cell = tableView.dequeueReusableCell(withIdentifier: "emailCell", for: indexPath as IndexPath)
        cell.backgroundColor = .white
        cell.selectionStyle = .none
        cell.textLabel?.textColor = Color.textSemiBlack
        cell.textLabel?.text = memberInvites[indexPath.row]
        return cell
    }
}
