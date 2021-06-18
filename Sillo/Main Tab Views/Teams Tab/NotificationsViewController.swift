//
//  NotificationsViewController.swift
//  Sillo
//
//  Created by Eashan Mathur on 4/8/21.
//

import UIKit

class NotificationsViewController: UIViewController {
    
    let cellID = "cellID"
    
    let header : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.navBar
        return view
    }()
    let isAdmin:Bool = organizationData.adminStatusMap[organizationData.currOrganization!] ?? false
    let labels:[String] = ["New posts", "New connections", "Quest progress", "Quest completion", "Messages", "Reports"]
    var statuses: [Bool] = [true,true,true,true,true,true]
    
    let toggleTableView = UITableView()
    let toggleHeader: UILabel = {
        let lb = UILabel()
        lb.font = UIFont(name: "Apercu Bold", size: 19)
        lb.textColor = .black
        lb.text = "Notify me about"
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    override func viewWillAppear(_ animated: Bool) {
        fetchNotificationSettings()
        
        tabBarController?.tabBar.isHidden = true
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshNotificationTableView(note:)), name: Notification.Name("NotificationSettingsFetchComplete"), object: nil)
    }
    
    @objc func refreshNotificationTableView(note: NSNotification) {
        self.toggleTableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(toggleTableView)
        view.addSubview(toggleHeader)
        setupHeader()
        
        tabBarController?.tabBar.isHidden = true
        
        //MARK: Allows swipe from left to go back (making it interactive caused issue with the header)
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(leftEdgeSwipe))
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
        
        toggleHeader.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 35).isActive = true
        toggleHeader.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 325/375).isActive = true
        toggleHeader.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        self.toggleTableView.tableFooterView = UIView() // remove separators at bottom of tableview
        
        toggleTableView.translatesAutoresizingMaskIntoConstraints = false
        toggleTableView.topAnchor.constraint(equalTo: toggleHeader.bottomAnchor, constant: 20).isActive = true
        toggleTableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 25).isActive = true
        toggleTableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 25).isActive = true
//        toggleTableView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        toggleTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        toggleTableView.isScrollEnabled = false
        toggleTableView.dataSource = self
        toggleTableView.showsVerticalScrollIndicator = false
        toggleTableView.delegate = self
        toggleTableView.separatorColor = .clear
        toggleTableView.backgroundColor = .white
        toggleTableView.register(ToggleCell.self, forCellReuseIdentifier: cellID)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
    }
    
    
    func setupHeader() {
        view.addSubview(header)
        
        header.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        header.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: 132).isActive = true
        
        let logoTeamStack = setupPhotoTeamName()
        header.addSubview(logoTeamStack)
        logoTeamStack.leadingAnchor.constraint(equalTo: header.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        logoTeamStack.topAnchor.constraint(equalTo: header.safeAreaLayoutGuide.topAnchor).isActive = true
        logoTeamStack.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -15).isActive = true
        logoTeamStack.heightAnchor.constraint(equalToConstant: 40).isActive = true
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
        tabName.text = "Notifications"
        tabName.font = UIFont(name:"Apercu-Bold", size: 22)
        tabName.textColor = Color.teamHeader
        tabName.widthAnchor.constraint(equalToConstant: 200).isActive = true
        stack.addArrangedSubview(tabName)
        
        return stack
    }
    
    //MARK: function for left swipe gesture
    @objc func leftEdgeSwipe(_ recognizer: UIScreenEdgePanGestureRecognizer) {
       if recognizer.state == .recognized {
          pushNotificationSettings()
          self.navigationController?.popViewController(animated: true)
       }
    }
    
    @objc func backTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        pushNotificationSettings()
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: fetch notification settings
    func fetchNotificationSettings() {
        db.collection("notifications").document(Constants.FIREBASE_USERID!).collection("user_notifications").document(organizationData.currOrganization!).getDocument() { (query, err) in
            if (query != nil) {
                if query!.exists {
                    let newPosts = query?.get("new_posts") as! Bool
                    let newConnections = query?.get("new_connections") as! Bool
                    let questProgress = query?.get("quest_progress") as! Bool
                    let questCompletion = query?.get("quest_completion") as! Bool
                    let messages = query?.get("new_messages") as! Bool
                    let reports = query?.get("new_reports") as! Bool
                    
                    self.statuses = [newPosts, newConnections, questProgress, questCompletion, messages, reports]
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NotificationSettingsFetchComplete"), object: nil)
                }
                else {
                    //document does not exist, set all options to true
                    db.collection("notifications").document(Constants.FIREBASE_USERID!).collection("user_notifications").document(organizationData.currOrganization!).setData(["new_posts":self.statuses[0], "new_connections":self.statuses[1], "quest_progress":self.statuses[2], "quest_completion":self.statuses[3], "new_messages":self.statuses[4], "new_reports":self.statuses[5]])
                }
            }
        }
    }
    //MARK: push notification settings
    func pushNotificationSettings() {
        for (i,cell) in toggleTableView.visibleCells.enumerated() {
            statuses[i] = (cell as! ToggleCell).toggle.isOn
        }
        db.collection("notifications").document(Constants.FIREBASE_USERID!).collection("user_notifications").document(organizationData.currOrganization!).updateData(["new_posts":self.statuses[0], "new_connections":self.statuses[1], "quest_progress":self.statuses[2], "quest_completion":self.statuses[3], "new_messages":self.statuses[4], "new_reports":self.statuses[5]])
    }
}

extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isAdmin {
            return statuses.count
        }
        else {
            return statuses.count-1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ToggleCell
        cell.toggleLabel.text = labels[indexPath.row]
        cell.toggle.isOn = statuses[indexPath.row]
        cell.separatorInset = UIEdgeInsets.zero
        cell.selectionStyle = .none
        return cell
    }
    
}

class ToggleCell: UITableViewCell {

    
    let stack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 35
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.backgroundColor = .white
        return stack
    }()
    
    
    let toggleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apercu-Regular", size: 17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let toggle: UISwitch = {
        let newSwitch = UISwitch()
        newSwitch.onTintColor = Color.burple
        newSwitch.addTarget(self, action:#selector(toggleSwitch(_:)), for: .touchDragInside)
        newSwitch.translatesAutoresizingMaskIntoConstraints = false
        return newSwitch
    }()
    
    @objc func toggleSwitch(_ sender : UISwitch!){
        print("DO NOTHING")
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(stack)
        stack.addSubview(toggleLabel)
        stack.addSubview(toggle)
        
        stack.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: contentView.widthAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        toggleLabel.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 223/324).isActive = true
        toggle.leftAnchor.constraint(equalTo: toggleLabel.rightAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
