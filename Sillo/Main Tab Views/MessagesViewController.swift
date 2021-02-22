//
//  MessagesViewController.swift
//  Sillo
//
//  Created by Angelica Pan on 2/20/21.
//

import UIKit

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    private let messages = [ //placeholder data, TODO: fetch conversations from firebase
        Message(alias: "Potato", name: "Alexa", profilePicture: UIImage(named:"avatar-1"), message: "Hey I really like potatoes what abotu you", timeSent: "2.55pm", isRead: false),
        Message(alias: "Apple Pie", name: "Barnie", profilePicture: UIImage(named:"avatar-2"), message: "BABABAABBANA BANAANAN ABANA BANA!", timeSent: "7.55pm", isRead: true),
        Message(alias: "Bongo", name: "Sender", profilePicture: UIImage(named:"avatar-3"), message: "I really like candles would you like one here u go", timeSent: "7.55pm", isRead: false),
        Message(alias: "Bingo", name: "Mickey", profilePicture: UIImage(named:"avatar-1"), message: "Did you know that hippo milk is pink??", timeSent: "7.33pm", isRead: true),
        Message(alias: "Sink", name: "Siri", profilePicture: UIImage(named:"avatar-3"), message: "my favourite flavour of icecream is giraffe", timeSent: "5.15pm", isRead: false),
        Message(alias: "Potato", name: "Aqua", profilePicture: UIImage(named:"avatar-1"), message: "baby shark doo doo doo doo do ", timeSent: "2.55pm", isRead: false),
        Message(alias: "Apple Pie", name: "Bob", profilePicture: UIImage(named:"avatar-2"), message: "whooo is thta girl i see??? staring straight??? back at me", timeSent: "7.55pm", isRead: true),
        Message(alias: "Bongo", name: "Angel", profilePicture: UIImage(named:"avatar-3"), message: "Houston to Apollo 13 do you copy o", timeSent: "7.55pm", isRead: false),
        Message(alias: "Bingo", name: "Frances", profilePicture: UIImage(named:"avatar-1"), message: "I have a pencil and my pencil is black", timeSent: "7.33pm", isRead: true),
        Message(alias: "Sink", name: "Seargant", profilePicture: UIImage(named:"avatar-1"), message: "I rly rly like sillo wbu rbo", timeSent: "5.15pm", isRead: false),
        Message(alias: "Potato", name: "Aqua", profilePicture: UIImage(named:"avatar-1"), message: "baby shark doo doo doo doo do ", timeSent: "2.55pm", isRead: false),
        Message(alias: "Apple Pie", name: "Bob", profilePicture: UIImage(named:"avatar-2"), message: "whooo is thta girl i see??? staring straight??? back at me", timeSent: "7.55pm", isRead: true),
        Message(alias: "Bongo", name: "Angel", profilePicture: UIImage(named:"avatar-3"), message: "Houston to Apollo 13 do you copy o", timeSent: "7.55pm", isRead: false),
        Message(alias: "Bingo", name: "Frances", profilePicture: UIImage(named:"avatar-1"), message: "I have a pencil and my pencil is black", timeSent: "7.33pm", isRead: true),
        Message(alias: "Sink", name: "Seargant", profilePicture: UIImage(named:"avatar-1"), message: "I rly rly like sillo wbu rbo", timeSent: "5.15pm", isRead: false),
                
    ]

    let cellID = "cellID"
    
    let chatListTable : UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
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
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        setupHeader()
        setupTableView()
        
        //set up status bar up top
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
        teamPic.image = UIImage(named: "avatar-1")
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
        chatListTable.delegate = self
        chatListTable.dataSource = self
        view.addSubview(chatListTable)
        chatListTable.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        chatListTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        chatListTable.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        chatListTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        chatListTable.register(ChatViewTableViewCell.self, forCellReuseIdentifier: cellID)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ChatViewTableViewCell
        cell.item = messages[indexPath.row]
        cell.separatorInset = UIEdgeInsets.zero
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView.init(frame: CGRect.init(x: 25, y: 0, width: tableView.frame.width, height: 50))
        
            let label = UILabel()
            label.frame = CGRect.init(x: 25, y: 5, width: headerView.frame.width, height: headerView.frame.height-10)
            label.text = "Today"
            label.font = Font.bold(20)
            label.textColor = UIColor.black
            headerView.addSubview(label)

            return headerView
        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 35
        }
}
