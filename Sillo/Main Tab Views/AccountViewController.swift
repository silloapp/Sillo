//
//  AccountViewController.swift
//  Sillo
//
//  Created by Angelica Pan on 2/20/21.
//

import UIKit

class AccountViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let header : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.navBar
        return view
    }()
    
    
    private let menuItems = [
        MenuItem(name: "Delete Account", nextVC: "", withArrow: true, fontSize: 17)
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
        menuItemTableView.heightAnchor.constraint(equalToConstant: 60).isActive = true
        menuItemTableView.isScrollEnabled = false
        menuItemTableView.dataSource = self
        menuItemTableView.delegate = self
        menuItemTableView.register(TeamCell.self, forCellReuseIdentifier: "contactCell") //TODO: replace identifier
        
        
        
        text.text = "If you choose to delete your account, it will be permanently removed from Sillo and you will be removed from all spaces associated with \(accountEmail)"
        view.addSubview(text)
        text.topAnchor.constraint(equalTo:menuItemTableView.bottomAnchor, constant: 5).isActive = true
        text.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor, constant: 32).isActive = true
        text.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor, constant: -32).isActive = true
        text.heightAnchor.constraint(equalToConstant: 60).isActive = true

    }
    
    let accountEmail: String = "user@placeholder.com"
    
    //MARK: init success label
    let text: UILabel = {
        let label = UILabel()
        label.font = Font.regular(12)
        label.numberOfLines = 3
        label.text = "If you choose to delete your account, it will be permanently removed from Sillo and you will be removed from all spaces associated with placeholder@placeholder.com"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
   
    
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
            let nextVC = HomeViewController() //placeholder
            nextVC.modalPresentationStyle = .fullScreen
            self.navigationController?.pushViewController(nextVC, animated: true)
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
        tabName.text = "Account"
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
