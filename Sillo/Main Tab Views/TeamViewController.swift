//
//  TeamViewController.swift
//  Sillo
//
//  Created by Angelica Pan on 2/19/21.
//

import UIKit

class TeamViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    let header : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.navBar
        return view
    }()
    
    
    private let menuItems = [
        MenuItem(name: "My Profile", nextVC: MyConnectionsVC(), withArrow: false, fontSize: 22), //TODO: replace with actual VC
        MenuItem(name: "My Connections", nextVC: MyConnectionsVC(), withArrow: false, fontSize: 22),
        MenuItem(name: "People", nextVC: MyConnectionsVC(), withArrow: false, fontSize: 22),
        MenuItem(name: "Engagement", nextVC: MyConnectionsVC(), withArrow: false, fontSize: 22),
        MenuItem(name: "Notifications", nextVC: MyConnectionsVC(), withArrow: false, fontSize: 22),
        MenuItem(name: "Reports", nextVC: MyConnectionsVC(), withArrow: false, fontSize: 22),
        MenuItem(name: "Quests", nextVC: MyConnectionsVC(), withArrow: false, fontSize: 22),
        MenuItem(name: "Sign Out", nextVC: MyConnectionsVC(), withArrow: false, fontSize: 22)
    ]
    
    let menuItemTableView = UITableView() // view
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        
        setupHeader()
        
        view.addSubview(menuItemTableView)
        self.menuItemTableView.tableFooterView = UIView() // remove separators at bottom of tableview
        menuItemTableView.translatesAutoresizingMaskIntoConstraints = false
        menuItemTableView.topAnchor.constraint(equalTo:view.topAnchor, constant: 132).isActive = true
        menuItemTableView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor).isActive = true
        menuItemTableView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
        menuItemTableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        menuItemTableView.isScrollEnabled = false
        menuItemTableView.dataSource = self
        menuItemTableView.delegate = self
        menuItemTableView.register(TeamCell.self, forCellReuseIdentifier: "contactCell")
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! TeamCell
        cell.item = menuItems[indexPath.row]
        cell.separatorInset = UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(menuItems[indexPath.row].name ?? ""  + " was clicked! Will not segway into next VC.. ")
        let vc = menuItems[indexPath.row].nextVC!
        self.navigationController?.pushViewController(vc, animated: true)
        //TODO: add Segway into nextVC
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func setupPhotoTeamName() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 11
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let silloLogo = UIImageView()
        silloLogo.image = UIImage(named: "sillo-logo-small")
        silloLogo.contentMode = .scaleAspectFit
        stack.addArrangedSubview(silloLogo)
        
        let clubName = UILabel()
        clubName.text = "Berkeley Design"
        clubName.font = Font.bold(22)
        clubName.textColor = Color.teamHeader
        stack.addArrangedSubview(clubName)
        
        return stack
    }
    
    func setupHeader() {
        view.addSubview(header)
        
        header.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        header.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: 132).isActive = true
        
        //app logo and team name stack
        let logoTeamStack = setupPhotoTeamName()
        header.addSubview(logoTeamStack)
        
        logoTeamStack.leadingAnchor.constraint(equalTo: header.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        logoTeamStack.topAnchor.constraint(equalTo: header.safeAreaLayoutGuide.topAnchor).isActive = true
        logoTeamStack.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -15).isActive = true
        logoTeamStack.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //team picture
        let settingsButton = UIImageView()
        settingsButton.image = UIImage(named: "Settings")
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.contentMode = .scaleAspectFit
        settingsButton.layer.masksToBounds = true
        settingsButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        settingsButton.isUserInteractionEnabled = true
        settingsButton.addGestureRecognizer(tapGestureRecognizer)
        header.addSubview(settingsButton)

        settingsButton.rightAnchor.constraint(equalTo: header.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        settingsButton.centerYAnchor.constraint(equalTo: logoTeamStack.centerYAnchor).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("Clicked on Settings! Time to segway into settings VC... ")
        let nextVC = SettingsViewController()
        nextVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}
