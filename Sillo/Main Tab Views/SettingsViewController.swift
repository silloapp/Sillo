//
//  SettingsViewController.swift
//  Sillo
//
//  Created by Angelica Pan on 2/19/21.
//

import UIKit
import SafariServices

class SettingsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    let header : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.navBar
        return view
    }()
    
    
    private let menuItems = [
        MenuItem(name: "Privacy Policy", nextVC: "", withArrow: true), //TODO: replace with actual VC
        MenuItem(name: "Terms of Use", nextVC: "", withArrow: true),
        MenuItem(name: "Help & FAQ", nextVC: "", withArrow: true),
        MenuItem(name: "Feedback", nextVC: "", withArrow: true),
        MenuItem(name: "About Sillo", nextVC: "", withArrow: true),
        MenuItem(name: "Log out", nextVC: "", withArrow: true),
        MenuItem(name: "Account", nextVC: "", withArrow: true)
    ]
    
    let menuItemTableView = UITableView() // view
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
        menuItemTableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        menuItemTableView.isScrollEnabled = false
        menuItemTableView.dataSource = self
        menuItemTableView.delegate = self

        menuItemTableView.register(TeamCell.self, forCellReuseIdentifier: "contactCell") //TODO: replace identifier

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
        let name = menuItems[indexPath.row].name
        print(name)
        //TODO: add Segway into nextVC
        
        if name == "Privacy Policy" {
               let config = SFSafariViewController.Configuration()
               config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: URL(string: "https://www.sillo.co/privacy-policy")!, configuration: config)
               present(vc, animated: true)
           }
        
        if name == "Terms of Use" {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: URL(string: "https://www.sillo.co/terms-and-conditions")!, configuration: config)
            present(vc, animated: true)
        }
        
        if name == "About Sillo" {
            let config = SFSafariViewController.Configuration()
            config.entersReaderIfAvailable = true

            let vc = SFSafariViewController(url: URL(string: "https://www.sillo.co")!, configuration: config)
            present(vc, animated: true)
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func setupPhotoTeamName() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 100
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let icon = UIImageView()
        icon.image = UIImage(named: "Backward Arrow")
        icon.heightAnchor.constraint(equalToConstant: 17).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 10).isActive = true
        icon.contentMode = .scaleAspectFit
       
        stack.addArrangedSubview(icon)
        
        
         let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backTapped(tapGestureRecognizer:)))
         icon.isUserInteractionEnabled = true
         icon.addGestureRecognizer(tapGestureRecognizer)
        
        let tabName = UILabel()
        tabName.text = "Settings"
        tabName.font = Font.bold(22)
        tabName.textColor = Color.teamHeader
        tabName.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        stack.addArrangedSubview(tabName)
        
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
            //        let icon = UIImageView()
            //        icon.image = UIImage(named: "Backward Arrow")
            //        icon.heightAnchor.constraint(equalToConstant: 17).isActive = true
            //        icon.widthAnchor.constraint(equalToConstant: 10).isActive = true
            //        icon.contentMode = .scaleAspectFit
            //        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backTapped(tapGestureRecognizer:)))
            //        icon.isUserInteractionEnabled = true
            //        icon.addGestureRecognizer(tapGestureRecognizer)
            //        header.addSubview(icon)
            //
            //        let tabName = UILabel()
            //        tabName.text = "Settings"
            //        tabName.font = Font.bold(22)
            //        tabName.textColor = Color.teamHeader
            //        header.addSubview(tabName)
            //
            //
            //        icon.topAnchor.constraint(equalTo: header.safeAreaLayoutGuide.topAnchor).isActive = true
            //        icon.leadingAnchor.constraint(equalTo: header.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
            //        tabName.centerXAnchor.constraint(equalTo: header.centerXAnchor, constant: 0).isActive = true
            //        tabName.centerYAnchor.constraint(equalTo: icon.centerYAnchor, constant:0 ).isActive = true
            //        tabName.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        
        


    }
    
    @objc func backTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("Going back to previous VC... ")
        self.navigationController?.popViewController(animated: true)
    }
    

}
