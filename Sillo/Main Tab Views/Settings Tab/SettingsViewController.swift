//
//  SettingsViewController.swift
//  Sillo
//
//  Created by Angelica Pan on 2/19/21.
//

import UIKit
import SafariServices
import MessageUI

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate {

    let header : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.navBar
        return view
    }()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    private let menuItems = [
        MenuItem(name: "Privacy Policy", nextVC: MyConnectionsVC(), withArrow: true, fontSize: 17), //TODO: replace with actual VC
        MenuItem(name: "Terms of Use", nextVC: MyConnectionsVC(), withArrow: true, fontSize: 17),
        //MenuItem(name: "Help & FAQ", nextVC: MyConnectionsVC(), withArrow: true, fontSize: 17),
        MenuItem(name: "Feedback", nextVC: MyConnectionsVC(), withArrow: true, fontSize: 17),
        MenuItem(name: "About Sillo", nextVC: MyConnectionsVC(), withArrow: true, fontSize: 17),
        MenuItem(name: "Log out", nextVC: MyConnectionsVC(), withArrow: true, fontSize: 17),
        MenuItem(name: "Account", nextVC: MyConnectionsVC(), withArrow: true, fontSize: 17)
    ]
    
    let menuItemTableView = UITableView() // view
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupHeader()
        view.backgroundColor = .white
        overrideUserInterfaceStyle = .light
        
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(screenEdgeSwiped))
        edgePan.edges = .left

        view.addGestureRecognizer(edgePan)
        
        view.addSubview(menuItemTableView)
        self.menuItemTableView.tableFooterView = UIView() // removes separators at bottom of tableview
        menuItemTableView.translatesAutoresizingMaskIntoConstraints = false
        menuItemTableView.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        menuItemTableView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor).isActive = true
        menuItemTableView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
        menuItemTableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        menuItemTableView.isScrollEnabled = false
        menuItemTableView.dataSource = self
        menuItemTableView.delegate = self
        menuItemTableView.register(TeamCell.self, forCellReuseIdentifier: "contactCell") //TODO: replace identifier
    }
    
    @objc func screenEdgeSwiped(_ recognizer: UIScreenEdgePanGestureRecognizer) {
        if recognizer.state == .recognized {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! TeamCell
        cell.item = menuItems[indexPath.row]
        cell.separatorInset = UIEdgeInsets.zero
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = menuItems[indexPath.row].name
        if name == "Privacy Policy" {
            presentURL(urlString: "https://www.sillo.co/privacy-policy")
           }
        
        if name == "Terms of Use" {
            presentURL(urlString: "https://www.sillo.co/terms-and-conditions")
        }
        
        if name == "About Sillo" {
            presentURL(urlString: "https://www.sillo.co")
        }
        
        if name == "Feedback" {
            //let nextVC = FeedbackViewController()
            //nextVC.modalPresentationStyle = .fullScreen
            //self.navigationController?.pushViewController(nextVC, animated: true)
            sendEmail()
        }
        if name == "Log out" {
            let alertVC = AlertView(headingText: "Log out?", messageText: "You are currently logged in as \(Constants.EMAIL!).", action1Label: "Cancel", action1Color: Color.buttonClickableUnselected, action1Completion: {
                self.dismiss(animated: true, completion: nil)
            }, action2Label: "Log out", action2Color: Color.burple, action2Completion: {
                localUser.signOut()
                let nextVC = StartScreenViewController()
                nextVC.modalPresentationStyle = .fullScreen
                self.present(nextVC, animated: true, completion: nil)
            }, withCancelBtn: false, image: UIImage(named:"sparkle sign out"), withOnlyOneAction: false)
            
            alertVC.modalTransitionStyle = .crossDissolve
            alertVC.modalPresentationStyle = .overCurrentContext
            self.present(alertVC, animated: true, completion: nil)
            
            
        }
        if name == "Account" {
            let nextVC = AccountViewController()
            nextVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
    }
    
    func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients(["feedback@sillo.co"])
            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)

            present(mail, animated: true)
        } else {
            // show failure alert
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "Oops!", message: "Thanks for taking the time to write feedback. It looks like your device does not allow email sending. We'd still appreciate your thoughts at feedback@sillo.co", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {_ in}))
                self.present(alert, animated: true)
            }
        }
    }

    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    
    func setupHeader() {
        view.addSubview(header)
        
        header.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        header.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        header.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 110/812).isActive = true

        let icon = UIImageView()
        header.addSubview(icon)
        icon.translatesAutoresizingMaskIntoConstraints = false
        icon.image = UIImage(named: "Backward Arrow")
        icon.contentMode = .scaleAspectFit
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backTapped(tapGestureRecognizer:)))
        icon.isUserInteractionEnabled = true
        icon.addGestureRecognizer(tapGestureRecognizer)
        
        icon.heightAnchor.constraint(equalToConstant: 17).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 10).isActive = true
        icon.leftAnchor.constraint(equalTo: header.leftAnchor, constant: 28).isActive = true
        
        let settingsLabel = UILabel()
        header.addSubview(settingsLabel)
        settingsLabel.text = "Settings"
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsLabel.font = UIFont(name: "Apercu-Bold", size: 22)
        settingsLabel.textColor = Color.teamHeader
        
        settingsLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor).isActive = true
        settingsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        
        icon.centerYAnchor.constraint(equalTo: settingsLabel.centerYAnchor).isActive = true
    }
    
    @objc func backTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func presentURL(urlString: String) {
        let config = SFSafariViewController.Configuration()
        config.entersReaderIfAvailable = true
     
        let vc = SFSafariViewController(url: URL(string: urlString)!, configuration: config)
        present(vc, animated: true)
    }
}
