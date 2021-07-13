//
//  AccountViewController.swift
//  Sillo
//
//  Created by Angelica Pan on 2/20/21.
//

import UIKit

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let accountEmail: String = Constants.EMAIL ?? "your email"
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
        MenuItem(name: "Delete Account", nextVC: StartScreenViewController(), withArrow: true, fontSize: 17)
    ]
    
    let menuItemTableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupHeader()
        view.backgroundColor = .white
        
        view.addSubview(menuItemTableView)
        self.menuItemTableView.tableFooterView = UIView() // removes separators at bottom of tableview
        menuItemTableView.translatesAutoresizingMaskIntoConstraints = false
        menuItemTableView.topAnchor.constraint(equalTo:view.topAnchor, constant: 132).isActive = true
        menuItemTableView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor).isActive = true
        menuItemTableView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
        menuItemTableView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        menuItemTableView.isScrollEnabled = false
        menuItemTableView.dataSource = self
        menuItemTableView.delegate = self
        menuItemTableView.backgroundColor = .white
        menuItemTableView.register(TeamCell.self, forCellReuseIdentifier: "contactCell") //TODO: replace identifier
        
        text.text = "If you choose to delete your account, it will be permanently removed from Sillo and you will be removed from all spaces associated with \(accountEmail)"
        text.textColor = Color.matte
        view.addSubview(text)
        text.topAnchor.constraint(equalTo:menuItemTableView.bottomAnchor, constant: 5).isActive = true
        text.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor, constant: 32).isActive = true
        text.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor, constant: -32).isActive = true
        text.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }

    let text: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apercu-Regular", size: 12)
        label.numberOfLines = 3
        label.text = "If you choose to delete your account, it will be permanently removed from Sillo and you will be removed from all spaces associated with your email"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! TeamCell
        cell.backgroundColor = .white
        cell.item = menuItems[indexPath.row]
        cell.separatorInset = UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let name = menuItems[indexPath.row].name
        switch name {
        case "Delete Account":
            //log account deletion
            if let nextVC = menuItems[indexPath.row].nextVC as? StartScreenViewController {
                print("delete account")
                DispatchQueue.main.async {
                    let alert = AlertView(headingText: "Are you sure?", messageText: "Deleting your account will remove you from all Sillo spaces associated with \(self.accountEmail)", action1Label: "Delete", action1Color: Color.salmon, action1Completion: {
                        self.deleteHelper(nextVC)
                        self.dismiss(animated: true, completion: nil)
                    }, action2Label: "Cancel", action2Color: .gray, action2Completion: {
                        self.dismiss(animated: true, completion: nil)
                    }, withCancelBtn: false, image: nil, withOnlyOneAction: false)
                    alert.modalPresentationStyle = .overCurrentContext
                    alert.modalTransitionStyle = .crossDissolve
            
                    self.present(alert, animated: true, completion: nil)
                }
            }
            break
        default:
            break
        }

    }
    func deleteHelper(_ nextVC: UIViewController) {
        localUser.deleteUser()
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true, completion: {analytics.log_delete_account()})
        }
        
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
        settingsLabel.text = "Account"
        settingsLabel.translatesAutoresizingMaskIntoConstraints = false
        settingsLabel.font = UIFont(name: "Apercu-Bold", size: 22)
        settingsLabel.textColor = Color.teamHeader
        
        settingsLabel.centerXAnchor.constraint(equalTo: header.centerXAnchor).isActive = true
        settingsLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
        
        icon.centerYAnchor.constraint(equalTo: settingsLabel.centerYAnchor).isActive = true
    }
    
    @objc func backTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("Going back to previous VC... ")
        self.navigationController?.popViewController(animated: true)
    }
}
