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
    var isAdmin: Bool!
    let labels = ["New posts", "New connections", "Quest progress", "Quest completion", "Messages", "Reports"]
    
    let toggleTableView = UITableView()
    let toggleHeader: UILabel = {
        let lb = UILabel()
        lb.font = Font.bold(19)
        lb.textColor = .black
        lb.text = "Notify me about"
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(toggleTableView)
        view.addSubview(toggleHeader)
        setupHeader()
        
        toggleHeader.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 35).isActive = true
        toggleHeader.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 325/375).isActive = true
        toggleHeader.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        isAdmin = true
        
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
        toggleTableView.register(ToggleCell.self, forCellReuseIdentifier: cellID)
        
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
        tabName.font = Font.bold(22)
        tabName.textColor = Color.teamHeader
        tabName.widthAnchor.constraint(equalToConstant: 200).isActive = true
        stack.addArrangedSubview(tabName)
        
        return stack
    }
    
    
    @objc func backTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        self.navigationController?.popViewController(animated: true)
    }

}

extension NotificationsViewController: UITableViewDataSource, UITableViewDelegate  {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isAdmin {
            return 6
        }
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ToggleCell
        cell.toggleLabel.text = labels[indexPath.row]
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
        return stack
    }()
    
    
    let toggleLabel: UILabel = {
        let label = UILabel()
        label.font = Font.regular(17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let toggle: UISwitch = {
        let newSwitch = UISwitch()
        newSwitch.onTintColor = Color.burple
        newSwitch.addTarget(self, action:#selector(toggleSwitch(_:)), for: .valueChanged)
        newSwitch.translatesAutoresizingMaskIntoConstraints = false
        return newSwitch
    }()
    
    @objc func toggleSwitch(_ sender : UISwitch!){
        print("HI")
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
