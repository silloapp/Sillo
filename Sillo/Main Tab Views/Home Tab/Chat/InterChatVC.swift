//
//  InterChatVC.swift
//  WithoutStoryboard
//
//  Created by USER on 19/02/21.
//

import UIKit
import Firebase

class InterChatVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK :IBDeclarations:
    
    let screenSize = UIScreen.main.bounds
    let titleLabel = UILabel()
    let TopTable = UITableView()
    var stackView = UIStackView()
    
    var chatID: String
    var initPost: Post?
    
    //MARK: listener
    private var messageListener: ListenerRegistration?
    deinit {
       messageListener?.remove()
     }
    
    
    init(chatID: String, post: Post?) {
        
        self.chatID = chatID
        
        super.init(nibName: nil, bundle: nil)
        
        if let inputpost = post {
            print("set init post whose message is \(inputpost.message)")
            self.initPost = inputpost
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func refreshChatView(note: NSNotification) {
        //refresh the subtask table
        self.TopTable.reloadData()
        //scrolls to bottom row when new message added
        self.TopTable.scrollToBottomRow()
        print("refreshed the chatView")
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) { self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isTranslucent = true
        self.view.backgroundColor = ViewBgColor
        settingElemets()
        forStsBar()
//        //now that message has been opened, mark as read for user
//        chatHandler.readChat(userID: Constants.FIREBASE_USERID!, chatId: self.chatID)
        
        
        self.navigationController?.navigationBar.isHidden = true
        setNavBar()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshChatView(note:)), name: Notification.Name("refreshChatView"), object: nil)
        
        if !Array(chatHandler.chatMetadata.keys).contains(self.chatID) { //is is not a chat, should only display one image, which is post. not from firebase.
             //convert post into message
            
            //let msg = Message(messageID: "DUMMY", senderID: self.initPost?.posterUserID, message: self.initPost?.message, attachment: UIImage(), timestamp: self.initPost?.date, isRead: false)
            let firstPost = Message(messageID: "DUMMY", senderID: self.initPost?.posterUserID, message: self.initPost?.message, attachment: UIImage(named: (self.initPost?.attachment)!), timestamp: self.initPost?.date, isRead: true)
             chatHandler.messages[self.chatID] = [firstPost]
        }else { //avoid appending the first post twice
            chatHandler.messages[self.chatID] = []
        }
        
        // add query listner for the chat's message collection
        let messageSubCol = db.collection("chats").document(chatID)
            .collection("messages").order(by: "timestamp", descending: false)
        messageListener = messageSubCol.addSnapshotListener { [self] querySnapshot, error in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(error!)")
                return
            }
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added || diff.type == .modified) {
                    let messageID = diff.document.documentID
                    print("New message: \(messageID)")
                    //add or update active chat
                    let message = diff.document.get("message") as! String
                    let senderID = diff.document.get("senderID") as! String
                    guard let stamp = diff.document.get("timestamp") as? Timestamp else {
                                return
                            }
                    let timestamp = stamp.dateValue()
                    let msg = Message(messageID: messageID, senderID: senderID, message: message, attachment: UIImage(), timestamp: timestamp, isRead: false)
                    
                    if chatHandler.messages[self.chatID] != nil {
                        //do not append msg twice
                        //CONTAINS MSG IS FLAWED CAUSING THE DOUBLE POST MSG BUG
                        //ALTERNATIVE FIX MAKE SURE ALL FIELDS IN MSG IS CONSISTENT
                        //OR ADD MSG IG into the message struct and check if the message id is already contained in the meantime
                        //this is def source of bug
                        if !chatHandler.messages[self.chatID]!.contains(msg) {
                            chatHandler.messages[self.chatID]?.append(msg)
                            
                            //sort messages (if no guarantee of sorting order, we should do it here)
                            //chatHandler.messages[self.chatID] = chatHandler.sortMessages(messages: chatHandler.messages[self.chatID]!)
                            
                            print("added message: \(message) to messagelist for chat \(self.chatID)" )
                        }
                    }
                }
                if (diff.type == .removed) {
                    let messageID = diff.document.documentID
                    print("Removed msg: \(messageID)")
                    //not implemented yet, need to change data struct first to map not array
//
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshChatView"), object: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func setNavBar() {
        
        //-------------------------For top bar:
        
        let TopbarView = UIView()
        
        TopbarView.backgroundColor = UIColor.init(red: 242/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        self.view.addSubview(TopbarView)
        
        let TopbarViewconstraints = [
            TopbarView.topAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            TopbarView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            TopbarView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            TopbarView.heightAnchor.constraint(equalToConstant: 60)
            
        ]
        let Backbutton = UIButton()
        
        Backbutton.setImage(UIImage(named: "back"), for: .normal)
        Backbutton.addTarget(self, action:#selector(callMethod), for: .touchUpInside)
        
        TopbarView.addSubview(Backbutton)
        
        let Backbuttonconstraints = [
            Backbutton.centerYAnchor.constraint(equalTo:  TopbarView.centerYAnchor, constant: 0),
            Backbutton.leftAnchor.constraint(equalTo: TopbarView.leftAnchor, constant: 20),
            Backbutton.widthAnchor.constraint(equalToConstant: 30),
            Backbutton.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        let menubutton = UIButton()
        
        menubutton.setImage(UIImage(named: "menu"), for: .normal)
        menubutton.addTarget(self, action:#selector(menuMethod), for: .touchUpInside)
        
        TopbarView.addSubview(menubutton)
        
        let menubuttonconstraints = [
            menubutton.centerYAnchor.constraint(equalTo:  TopbarView.centerYAnchor, constant: 0),
            menubutton.rightAnchor.constraint(equalTo: TopbarView.rightAnchor, constant: -20),
            menubutton.widthAnchor.constraint(equalToConstant: 30),
            menubutton.heightAnchor.constraint(equalToConstant: 30)
        ]
        
        let profileImg = UIImageView()
        profileImg.image = UIImage.init(named: "profile")
        TopbarView.addSubview(profileImg)
        
        let profileImgconstraints = [
            profileImg.centerYAnchor.constraint(equalTo:  TopbarView.centerYAnchor, constant: 0),
            profileImg.leftAnchor.constraint(equalTo: Backbutton.leftAnchor, constant: 50),
            profileImg.widthAnchor.constraint(equalToConstant: 40),
            profileImg.heightAnchor.constraint(equalToConstant: 40)
        ]
        profileImg.clipsToBounds = true
        profileImg.layer.cornerRadius = 20
        
        let label = UILabel()
        label.text = "Full Name"
        label.textAlignment = .left
        label.textColor = .black
        label.font = UIFont.init(name: "Apercu-Regular", size: 16)
        TopbarView.addSubview(label)
        
        let labelconstraints = [
            label.centerYAnchor.constraint(equalTo:  TopbarView.centerYAnchor, constant: -12),
            label.leftAnchor.constraint(equalTo: profileImg.leftAnchor, constant: 52),
            label.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        let sublabel = UILabel()
        sublabel.text = "3 shared connections"
        sublabel.textAlignment = .left
        sublabel.textColor = .black
        sublabel.font = UIFont.init(name: "Apercu-Regular", size: 16)
        TopbarView.addSubview(sublabel)
        
        let sublabelconstraints = [
            sublabel.centerYAnchor.constraint(equalTo:  TopbarView.centerYAnchor, constant: 8),
            sublabel.leftAnchor.constraint(equalTo: profileImg.leftAnchor, constant: 52),
            sublabel.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        
        
        
        //--------------------- for activationg constartints:
        
        NSLayoutConstraint.activate(TopbarViewconstraints)
        NSLayoutConstraint.activate(Backbuttonconstraints)
        NSLayoutConstraint.activate(profileImgconstraints)
        NSLayoutConstraint.activate(labelconstraints)
        NSLayoutConstraint.activate(menubuttonconstraints)
        NSLayoutConstraint.activate(sublabelconstraints)
        
        self.view.layoutIfNeeded()
        
        TopbarView.translatesAutoresizingMaskIntoConstraints = false
        Backbutton.translatesAutoresizingMaskIntoConstraints = false
        profileImg.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        menubutton.translatesAutoresizingMaskIntoConstraints = false
        sublabel.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    @objc func callMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func menuMethod() {
        self.navigationController?.popViewController(animated: true)
    }
  
    func forStsBar()
    {
        if #available(iOS 13.0, *) {
            let app = UIApplication.shared
            let statusBarHeight: CGFloat = app.statusBarFrame.size.height
            
            let statusbarView = UIView()
            statusbarView.backgroundColor = UIColor.init(red: 242/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
            view.addSubview(statusbarView)
            
            statusbarView.translatesAutoresizingMaskIntoConstraints = false
            statusbarView.heightAnchor
                .constraint(equalToConstant: statusBarHeight).isActive = true
            statusbarView.widthAnchor
                .constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
            statusbarView.topAnchor
                .constraint(equalTo: view.topAnchor).isActive = true
            statusbarView.centerXAnchor
                .constraint(equalTo: view.centerXAnchor).isActive = true
            
        } else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.init(red: 242/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        }
    }
    
    
    //===================================*** SETTING CONSTRAINT ***=======================================//
    
    func settingElemets()
    {
        
        // FOR TITLE :
        
        self.view.addSubview(titleLabel)
        titleLabel.text = "April 3.10:00 PM"
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "Apercu-Regular", size: 17)
        titleLabel.textAlignment = .center
        
        let TITLEconstraints = [
            titleLabel.topAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.topAnchor, constant: 80),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            titleLabel.heightAnchor.constraint(equalToConstant: 25)
            
        ]
        
        // FOR BOTTOM LAYOUT:
        
        
        // FOR bottomMsge :
        
        let bottomMsg = UILabel()
        self.view.addSubview(bottomMsg)
        bottomMsg.text = "Reply to see who is messaging you. They won't know who you are until you've responded."
        bottomMsg.backgroundColor = UIColor.init(red: 242/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        bottomMsg.textColor = .black
        bottomMsg.font = UIFont(name: "Apercu-Medium", size: 18)
        bottomMsg.textAlignment = .center
        bottomMsg.numberOfLines = 0
        bottomMsg.lineBreakMode = .byWordWrapping
        
        let bottomMsgconstraints = [
            bottomMsg.bottomAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.bottomAnchor, constant: -80),
            bottomMsg.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            bottomMsg.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            bottomMsg.heightAnchor.constraint(equalToConstant: 90)
        ]
        
        
        // FOR STACK VIEW:
        
        stackView.axis  = NSLayoutConstraint.Axis.horizontal
        stackView.spacing = 10
        stackView.backgroundColor = .lightGray
        
        let stackViewconstraints = [
            self.stackView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            self.stackView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            self.stackView.bottomAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.bottomAnchor, constant: -15),
            self.stackView.heightAnchor.constraint(equalToConstant: 60)
            
        ]
        self.view.addSubview(stackView)
        
        let deleteChatBtn = UIButton()
        deleteChatBtn.setTitle("Delete", for: .normal)
        deleteChatBtn.setTitleColor(.black, for: .normal)
        deleteChatBtn.titleLabel?.font = UIFont(name: "Apercu-Bold", size: 17)
        //TODO: Delete chat in backend
        deleteChatBtn.backgroundColor = ViewBgColor
        deleteChatBtn.addTarget(self, action: #selector(deletePressed), for: .touchUpInside)
        
        let chatAcceptBtn = UIButton()
        chatAcceptBtn.setTitle("Chat", for: .normal)
        chatAcceptBtn.setTitleColor(themeColor, for: .normal)
        chatAcceptBtn.titleLabel?.font = UIFont(name: "Apercu-Bold", size: 17)
        chatAcceptBtn.backgroundColor = ViewBgColor
        chatAcceptBtn.addTarget(self, action: #selector(chatPressed), for: .touchUpInside)
        
        let deleteBtnconstraints = [
            deleteChatBtn.leftAnchor.constraint(equalTo: self.stackView.safeAreaLayoutGuide.leftAnchor, constant: 0),
            deleteChatBtn.bottomAnchor.constraint(equalTo:  self.stackView.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            deleteChatBtn.heightAnchor.constraint(equalToConstant: 60),
            deleteChatBtn.widthAnchor.constraint(equalToConstant: screenSize.width/2-0.4)
        ]
        
        let cancelBtnconstraints = [
            chatAcceptBtn.widthAnchor.constraint(equalToConstant: screenSize.width/2-0.4),
            chatAcceptBtn.rightAnchor.constraint(equalTo: self.stackView.safeAreaLayoutGuide.rightAnchor, constant: 0),
            chatAcceptBtn.bottomAnchor.constraint(equalTo:  self.stackView.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            chatAcceptBtn.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        self.stackView.addSubview(deleteChatBtn)
        self.stackView.addSubview(chatAcceptBtn)
        
        //------------------------------------ FOR TABLE VIEWS--------------------------------------------------//
        
        // FOR TOP TABLE  :
        
        TopTable.separatorStyle = .none
        TopTable.backgroundColor = .clear
        TopTable.bounces = true
        TopTable.isScrollEnabled = false
        TopTable.register(ChatsbleViewCell.self, forCellReuseIdentifier: "cell")
        
        let TopTableconstraints = [
            self.TopTable.topAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.topAnchor, constant: 120),
            self.TopTable.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            self.TopTable.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            // self.TopTable.heightAnchor.constraint(equalToConstant: 350)
            self.TopTable.bottomAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.bottomAnchor, constant: -150)
        ]
        self.view.addSubview(TopTable)
        
        self.TopTable.delegate = self
        self.TopTable.dataSource = self
        
        
        
        //-----------for activating constraints:
        
        NSLayoutConstraint.activate(TopTableconstraints)
        NSLayoutConstraint.activate(TITLEconstraints)
        NSLayoutConstraint.activate(stackViewconstraints)
        NSLayoutConstraint.activate(deleteBtnconstraints)
        NSLayoutConstraint.activate(cancelBtnconstraints)
        NSLayoutConstraint.activate(bottomMsgconstraints)
        
        self.view.layoutIfNeeded()
        self.stackView.layoutIfNeeded()
        
        TopTable.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        deleteChatBtn.translatesAutoresizingMaskIntoConstraints = false
        chatAcceptBtn.translatesAutoresizingMaskIntoConstraints = false
        bottomMsg.translatesAutoresizingMaskIntoConstraints = false
        // bottomvw.translatesAutoresizingMaskIntoConstraints = false
        
        
    }
    
    //MARK: Chat or delete pressed
    @objc func deletePressed() {
        self.navigationController?.popViewController(animated: true)
        print("delete pressed")
    }
    
    @objc func chatPressed() {
//        let chatVC = ChatsViewController(messageInputBarStyle: .facebook)
//        let navigationController = UINavigationController(rootViewController: chatVC)
//        navigationController.modalPresentationStyle = .fullScreen
//        self.present(navigationController, animated: true, completion: nil)
        print("chat pressed! TODO: display revealVC")
        let chatVC = ChatsViewController(messageInputBarStyle: .facebook, chatID: self.chatID , post: nil)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(chatVC, animated: true)
        
    }
    
    //=============================*** DELEGATE DATASOURCE METHODS ***===============================//
    

    
     func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatHandler.messages[self.chatID]?.count ?? 0
    }
    
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatsbleViewCell
        cell.selectionStyle = .none
        
        //all messages
        var messagesList = chatHandler.messages[self.chatID]
        //single message
        let messageStruct = messagesList?[indexPath.row]

        //appears on the right if I sent it
        if messageStruct?.senderID == Constants.FIREBASE_USERID! {
            cell.labLeft.isHidden = true
            cell.labRight.isHidden = false
            cell.Viewleft.isHidden = true
            cell.ViewRight.isHidden = false
            cell.labRight.text = messageStruct?.message
        } else {//appears on the left if other person sends it
            cell.labLeft.isHidden = false
            cell.labRight.isHidden = true
            cell.Viewleft.isHidden = false
            cell.ViewRight.isHidden = true
            cell.labLeft.text = messageStruct?.message
        }
        
        
        let stringWidth = messageStruct?.message?.stringWidth
        let maxWidth = CGFloat(200)
        var chatWidth = CGFloat()
        
        if stringWidth! <= maxWidth{
            //looks like stringWidth extension is flawed???
            //chatWidth = stringWidth! + 30
            chatWidth = maxWidth
        } else {
            chatWidth = maxWidth
        }
    
        
        //HEIGHT
        //TODO: rn maximizes width, but later on get diff levels to balance out.
        var chatHeight = CGFloat()
        let stringHeight =  messageStruct?.message?.stringHeight
        //there is no max height for chat, but we will use a multiplier
        var multiplier = 1
        if (stringWidth! > maxWidth) {
            multiplier = Int((stringWidth! / maxWidth ).rounded(.up))
        }
        chatHeight = 60
        
 
       
        print("height:",chatHeight)
        print("width:", chatWidth)
        
      


            cell.ViewRight.topAnchor.constraint(equalTo:  cell.contentView.topAnchor, constant: 8).isActive = true
            cell.ViewRight.widthAnchor.constraint(equalToConstant: chatWidth + 30).isActive = true
            cell.ViewRight.rightAnchor.constraint(equalTo:  cell.contentView.rightAnchor, constant: -20).isActive = true
            
        
        cell.labRight.widthAnchor.constraint(equalToConstant: chatWidth).isActive = true
        cell.labRight.topAnchor.constraint(equalTo:  cell.ViewRight.topAnchor, constant: 8).isActive = true
        cell.labRight.rightAnchor.constraint(equalTo:  cell.ViewRight.rightAnchor, constant: -8).isActive = true
    
   
            cell.Viewleft.topAnchor.constraint(equalTo:  cell.contentView.topAnchor, constant: 8).isActive = true
           
            cell.Viewleft.widthAnchor.constraint(equalToConstant: chatWidth + 30).isActive = true
            cell.Viewleft.leftAnchor.constraint(equalTo:  cell.contentView.leftAnchor, constant: 20).isActive = true
            
        
            
      

            cell.labLeft.widthAnchor.constraint(equalToConstant: chatWidth).isActive = true
            cell.labLeft.topAnchor.constraint(equalTo:  cell.Viewleft.topAnchor, constant: 8).isActive = true
            cell.labLeft.leftAnchor.constraint(equalTo:  cell.Viewleft.leftAnchor, constant: 8).isActive = true
        
        
        //experiment with these two
        cell.ViewRight.bottomAnchor.constraint(equalTo:  cell.contentView.bottomAnchor, constant: -8).isActive = true
        cell.Viewleft.bottomAnchor.constraint(equalTo:  cell.contentView.bottomAnchor, constant: -8).isActive = true
        
        cell.ViewRight.heightAnchor.constraint(equalToConstant: CGFloat(chatHeight)).isActive = true
        cell.Viewleft.heightAnchor.constraint(equalToConstant: CGFloat(chatHeight)).isActive = true
        
        cell.contentView.layoutIfNeeded()
        
        return cell
        
    }
    
    
}

extension UILabel {
    var maxNumberOfLines: Int {
        let maxSize = CGSize(width: frame.size.width, height: CGFloat(MAXFLOAT))
        let text = (self.text ?? "") as NSString
        let textHeight = text.boundingRect(with: maxSize, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil).height
        let lineHeight = font.lineHeight
        return Int(ceil(textHeight / lineHeight))
    }
}
