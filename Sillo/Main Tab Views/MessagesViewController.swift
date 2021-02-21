//
//  MessagesViewController.swift
//  Sillo
//
//  Created by Angelica Pan on 2/20/21.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private let messages = [ //placeholder data
        Message(alias: "Potato", name: "Alexa", profilePicture: UIImage(named:"avatar-1"), message: "Hey I really like potatoes what abotu you", timeSent: "2.55pm", isRead: false),
        Message(alias: "Apple Pie", name: "Barnie", profilePicture: UIImage(named:"avatar-2"), message: "BABABAABBANA BANAANAN ABANA BANA!", timeSent: "7.55pm", isRead: true),
        Message(alias: "Bongo", name: "Sender", profilePicture: UIImage(named:"avatar-3"), message: "I really like candles would you like one here u go", timeSent: "7.55pm", isRead: false),
        Message(alias: "Bingo", name: "Mickey", profilePicture: UIImage(named:"avatar-1"), message: "Did you know that hippo milk is pink??", timeSent: "7.33pm", isRead: true),
        Message(alias: "Sink", name: "Siri", profilePicture: UIImage(named:"avatar-1"), message: "my favourite flavour of icecream is giraffe", timeSent: "5.15pm", isRead: false),
                
    ]

    let cellID = "cellID"
    let mainChatTable : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        table.separatorColor = .clear
        return table
    }()
    
    let header : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.headerBackground
        return view
    }()
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        view.backgroundColor = .white
        
        navigationController?.isNavigationBarHidden = true
        self.setNeedsStatusBarAppearanceUpdate()
        
        if #available(iOS 13, *) {
          let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
            statusBar.backgroundColor = Color.headerBackground
          UIApplication.shared.keyWindow?.addSubview(statusBar)
            
        } else {
             let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
             if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                statusBar.backgroundColor = Color.headerBackground
             }
             UIApplication.shared.statusBarStyle = .lightContent
            
        }
        
        setupHeader()
        setupTableView()
        mainChatTable.separatorStyle = .singleLine
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    
    func setupHeader() {
        view.addSubview(header)
        
        header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        header.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        
        //app logo and team name stack
        let logoTeamStack = setupPhotoTeamName()
        header.addSubview(logoTeamStack)
        
        logoTeamStack.leadingAnchor.constraint(equalTo: header.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        logoTeamStack.topAnchor.constraint(equalTo: header.safeAreaLayoutGuide.topAnchor).isActive = true
        logoTeamStack.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -15).isActive = true
        logoTeamStack.heightAnchor.constraint(equalToConstant: 40).isActive = true

        //team picture
        let teamPic = UIImageView()
        teamPic.image = UIImage(named: "onboarding2")
        teamPic.translatesAutoresizingMaskIntoConstraints = false
        teamPic.contentMode = .center
        teamPic.layer.masksToBounds = true
        teamPic.layer.borderWidth = 5.0
        teamPic.layer.borderColor = Color.gray.cgColor
        teamPic.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        teamPic.layer.cornerRadius = teamPic.frame.height / 2
        header.addSubview(teamPic)
        
        teamPic.rightAnchor.constraint(equalTo: header.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        teamPic.centerYAnchor.constraint(equalTo: logoTeamStack.centerYAnchor).isActive = true
        teamPic.heightAnchor.constraint(equalToConstant: 45).isActive = true
        teamPic.widthAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setupPhotoTeamName() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 11
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let clubName = UILabel()
        clubName.text = "Messages"
        clubName.font = Font.bold(22)
        clubName.textColor = Color.teamHeader
        stack.addArrangedSubview(clubName)
        
        return stack
    }
    
    func setupTableView() {
    
        mainChatTable.delegate = self
        mainChatTable.dataSource = self
        self.view.addSubview(mainChatTable)
        
        mainChatTable.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        mainChatTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mainChatTable.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mainChatTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true

        mainChatTable.register(ChatViewTableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ChatViewTableViewCell
        cell.item = messages[indexPath.row]
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
        
    }
    
   
}

