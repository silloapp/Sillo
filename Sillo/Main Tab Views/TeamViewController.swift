//
//  TeamViewController.swift
//  Sillo
//
//  Created by Eashan Mathur on 1/28/21.
//

import UIKit

class TeamViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{

    private let contacts = [
        Contact(name: "My Profile", jobTitle: "Designer", country: "bo"),
        Contact(name: "My Connections", jobTitle: "SEO Specialist", country: "be"),
        Contact(name: "People", jobTitle: "Interactive Designer", country: "af"),
        Contact(name: "Engagement", jobTitle: "Architect", country: "al"),
        Contact(name: "Notifications", jobTitle: "Economist", country: "br"),
        Contact(name: "Reports", jobTitle: "Web Strategist", country: "ar"),
        Contact(name: "Quests", jobTitle: "Product Designer", country: "az"),
        Contact(name: "Sign Out", jobTitle: "Editor", country: "bo")
    ]
    
    let contactsTableView = UITableView() // view
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        view.backgroundColor = .white
        
        view.addSubview(contactsTableView)
        
        contactsTableView.translatesAutoresizingMaskIntoConstraints = false
        
        contactsTableView.topAnchor.constraint(equalTo:view.safeAreaLayoutGuide.topAnchor).isActive = true
        contactsTableView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor).isActive = true
        contactsTableView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor).isActive = true
        contactsTableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        contactsTableView.dataSource = self
        contactsTableView.delegate = self

        contactsTableView.register(TeamCell.self, forCellReuseIdentifier: "contactCell")

        navigationItem.title = "Organization Information"
    }
    
   
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "contactCell", for: indexPath) as! TeamCell

        cell.contact = contacts[indexPath.row]

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    

}
