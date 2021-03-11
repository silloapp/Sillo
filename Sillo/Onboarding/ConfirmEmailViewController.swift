//
//  ViewController.swift
//  Sillo
//
//  Created by Chi Tsai on 2/14/21.
//

import UIKit

class ConfirmEmailViewController: UIViewController, UIGestureRecognizerDelegate, UITableViewDelegate, UITableViewDataSource {

    // MARK: Figma 1224
    
    var bar = UIProgressView()
    var emailTableView = UITableView()
    var confirmButton = UIButton()
    let memberInvites:[String] = organizationData.memberInvites ?? []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupProgressBar()
        setUpView()
    }
    
    //MARK: Prevents NavBar header from showing up when going back to root VC
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated);
        super.viewWillDisappear(animated)
    }

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
        instructionsLabel.font = Font.medium(dynamicFontSize(17))
        instructionsLabel.adjustsFontSizeToFitWidth = true
        instructionsLabel.textColor = Color.textSemiBlack
        instructionsLabel.numberOfLines = 3
        stack.addArrangedSubview(instructionsLabel)
        
        let invitationsLabel = UILabel()
        invitationsLabel.text = "Invitations"
        invitationsLabel.font = Font.medium(dynamicFontSize(22))
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
        
        emailTableView.backgroundColor = .white
        emailTableView.tableHeaderView = UIView()
        emailTableView.translatesAutoresizingMaskIntoConstraints = false

        emailTableView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        emailTableView.topAnchor.constraint(equalTo: stack.bottomAnchor).isActive = true
        emailTableView.bottomAnchor.constraint(equalTo: confirmButton.topAnchor, constant: -10).isActive = true
        
        confirmButton.backgroundColor = Color.buttonClickable
        confirmButton.setTitle("Confirm", for: .normal)
        confirmButton.titleLabel?.font = Font.bold(dynamicFontSize(20))
        confirmButton.isEnabled = true
        confirmButton.layer.cornerRadius = 5
        confirmButton.addTarget(self, action: #selector(confirmClicked), for: .touchUpInside)
        
        confirmButton.translatesAutoresizingMaskIntoConstraints = false
        confirmButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        confirmButton.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        confirmButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor) .isActive = true
    }
    
    @objc func confirmClicked() {
        organizationData.createNewOrganization()
        
        let transition = CATransition()
        transition.duration = 0.3
        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
        transition.type = .fade
        self.navigationController?.view.layer.add(transition, forKey: nil)
        
        // TODO: transition to next VC
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memberInvites.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // TODO: change the margins of the text to be spaced out
        let cell = tableView.dequeueReusableCell(withIdentifier: "emailCell", for: indexPath as IndexPath)
        cell.selectionStyle = .none
        cell.textLabel?.text = memberInvites[indexPath.row]
        return cell
    }
}
