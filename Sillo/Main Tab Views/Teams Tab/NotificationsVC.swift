//
//  NotificationsViewController.swift
//  Sillo
//
//  Created by Eashan Mathur on 3/25/21.
//

import UIKit

class NotificationsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    var toggleTableView = UITableView()
    
    let isAdmin: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        toggleTableView.dataSource = self
        toggleTableView.delegate = self
        toggleTableView.register(UITableViewCell.self, forCellReuseIdentifier: "MyCell")
        
        setupHeader()
        setupTableView()
    }
    
    
    func setupHeader() {
        let header = SetupNavBar(title: "Notifications") {
            self.navigationController?.popViewController(animated: true)
        }
        
        view.addSubview(header)
        header.translatesAutoresizingMaskIntoConstraints = false
        header.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        header.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        header.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 110/812).isActive = true
        
    }
    
    func setupTableView() {
        
    }
    
    @objc func backTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        navigationController?.popViewController(animated: true)
    }
    
}

extension NotificationsVC {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isAdmin {
            return 6
        } else {
            return 5
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        <#code#>
    }
    
}
