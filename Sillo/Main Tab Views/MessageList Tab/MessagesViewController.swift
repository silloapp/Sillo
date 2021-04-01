//
//  MessagesViewController.swift
//  Sillo
//
//  Created by Angelica Pan on 2/20/21.
//

import UIKit
import Firebase

class MessagesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

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
    
    //MARK: listener
    private var activeChatListener: ListenerRegistration?
    
    @objc func refreshMessageListView(note: NSNotification) {
        //refresh the subtask table
        
        chatHandler.sortedChats = chatHandler.sortActiveChats()
        self.chatListTable.reloadData()
        print("refreshed the messageListView")
        
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshMessageListView(note:)), name: Notification.Name("refreshMessageListView"), object: nil)
        //MARK: attach listener for added and removed chats :::: for modified chat, will have to map it back to chats not user chats. maybe be able to see changes in user_chats so i don't have to do this? for example add isRead
        let myUserID = Constants.FIREBASE_USERID ?? "ERROR"
        let reference = db.collection("user_chats").document(myUserID).collection("chats").order(by: "timestamp", descending: true)
        activeChatListener = reference.addSnapshotListener { [self] querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    let chatID = diff.document.documentID
                    print("New conversation: \(chatID)")
                    //add or update active chat
                    chatHandler.fetchChatSummary(chatID: chatID)
                }
                if (diff.type == .removed) {
                    let chatID = diff.document.documentID
                    print("Removed conversation: \(chatID)")
                    chatHandler.activeChats[chatID] = nil
                }
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshMessageListView"), object: nil)
        }
      
    }
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        overrideUserInterfaceStyle = .light
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
        tableView.backgroundView = nil
        let activeChats_count = chatHandler.activeChats.count
        if activeChats_count > 0 {
            return activeChats_count
        }
        else {
            //MARK: set up fallback if message table is empty
            
            let noMessagesUIView: UIView = {
                let bigView = UIView()
                let imageView : UIImageView = {
                    let view = UIImageView()
                    let scaling:CGFloat = 0.2
                    view.frame = CGRect(x: 0, y: 0, width: scaling*(tableView.bounds.width), height: scaling*(tableView.frame.height))
                    view.clipsToBounds = true
                    view.contentMode = .scaleAspectFit
                    let image = UIImage(named:"no messages")
                    view.image = image
                    view.translatesAutoresizingMaskIntoConstraints = false
                    return view
                }()
                
                let desc : UILabel = {
                    let label = UILabel()
                    label.text = "You have no messages.. yet!"
                    label.numberOfLines = 2
                    label.font = Font.bold(22)
                    label.textColor = Color.matte
                    label.translatesAutoresizingMaskIntoConstraints = false
                    return label
                }()
                
                bigView.addSubview(imageView)
                bigView.addSubview(desc)
                imageView.centerXAnchor.constraint(equalTo: bigView.centerXAnchor).isActive = true
                imageView.centerYAnchor.constraint(equalTo: bigView.centerYAnchor, constant: -50).isActive = true
                desc.centerXAnchor.constraint(equalTo: bigView.centerXAnchor).isActive = true
                desc.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
                return bigView
            }()
            

            tableView.backgroundView = noMessagesUIView
            return 0
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ChatViewTableViewCell
        let chatID = chatHandler.sortedChats[indexPath.row].chatID ?? "ERROR"
        cell.item = chatHandler.activeChats[chatID]
        cell.separatorInset = UIEdgeInsets.zero
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView.init(frame: CGRect.init(x: 25, y: 0, width: tableView.frame.width, height: 50))
        
            let label = UILabel()
            label.frame = CGRect.init(x: 25, y: 5, width: headerView.frame.width, height: headerView.frame.height-10)
            label.text = ""
            if chatHandler.sortedChats.count > 0 {
            label.text = "Today" //TODO: change this when viewing older messages
            }
            label.font = Font.bold(20)
            label.textColor = UIColor.black
            headerView.addSubview(label)

            return headerView
        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 35
        }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let chatID = chatHandler.sortedChats[indexPath.row].chatID ?? "ERROR"
        let chatVC = ChatsViewController(messageInputBarStyle: .facebook, chatID: chatID, post: nil)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(chatVC, animated: true)
        
        
        
    }
}
