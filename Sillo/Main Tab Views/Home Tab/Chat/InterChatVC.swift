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
    
    let appearance : UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        return appearance
    }()
    
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
    //how to make this conditional?
//    override func viewWillDisappear(_ animated: Bool) {
//        navigationController?.isNavigationBarHidden = true
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //now that message has been opened, mark as read for user
        chatHandler.readChat(userID: Constants.FIREBASE_USERID!, chatId: self.chatID)
        
//        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isTranslucent = true
        
        self.tabBarController?.tabBar.isHidden = true
        self.view.backgroundColor = .white
        settingElemets()
        //forStsBar()
        self.navigationController?.navigationBar.isHidden = false
        setNavBar2()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshChatView(note:)), name: Notification.Name("refreshChatView"), object: nil)
        
        if !Array(chatHandler.chatMetadata.keys).contains(self.chatID) {
            let firstPost = Message(messageID: "DUMMY", senderID: self.initPost?.posterUserID, message: self.initPost?.message, attachment: UIImage(named: (self.initPost?.attachment)!), timestamp: self.initPost?.date, isRead: true)
            chatHandler.messages[self.chatID] = [firstPost]
        }else {
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
                        if !chatHandler.messages[self.chatID]!.contains(msg) {
                            chatHandler.messages[self.chatID]?.append(msg)
                            print("added message: \(message) to messagelist for chat \(self.chatID)" )
                        }
                    }
                }
                if (diff.type == .removed) {
                    let messageID = diff.document.documentID
                    print("Removed msg: \(messageID)")
                }
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshChatView"), object: nil)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    @objc func backBtnPressed() {
        navigationController?.isNavigationBarHidden = true
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    
    func setNavBar2() {
        navigationController?.navigationBar.standardAppearance = self.appearance
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 242/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        //Set name and picture of person you're conversing with on header
        let label = UILabel()
        var profilePicName = chatHandler.chatMetadata[chatID]?.recipient_image ?? self.initPost?.posterImageName
        var person = chatHandler.chatMetadata[chatID]?.recipient_name ?? self.initPost?.posterAlias!
        label.text = self.initPost?.posterAlias ?? person
        label.textAlignment = .left
        label.textColor = Color.matte
        label.font = Font.bold(20)
        
        self.navigationItem.titleView = label
        
        label.superview?.addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: label.superview, attribute: .centerX, multiplier: 1, constant: -120))
        label.superview?.addConstraint(NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: label.superview, attribute: .width, multiplier: 0.5, constant: 0))
        label.superview?.addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: label.superview, attribute: .centerY, multiplier: 1, constant: 0))
        label.superview?.addConstraint(NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: label.superview, attribute: .height, multiplier: 1, constant: 0))
        
        //  NSLayoutConstraint.activate(BottomTableconstraints)
        
        self.view.layoutIfNeeded()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        //setting buttons
        let backbutton = UIButton(type: UIButton.ButtonType.custom)
        backbutton.setImage(UIImage(named: "back"), for: .normal)
        backbutton.addTarget(self, action:#selector(backBtnPressed), for: .touchUpInside)
        backbutton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let barbackbutton = UIBarButtonItem(customView: backbutton)
        
        let Imagebutton = UIButton(type: UIButton.ButtonType.custom)
        Imagebutton.setImage(UIImage(named: profilePicName!), for: .normal)
        Imagebutton.addTarget(self, action:#selector(backBtnPressed), for: .touchUpInside)
        Imagebutton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        Imagebutton.imageView?.contentMode = .scaleAspectFill
        Imagebutton.layer.cornerRadius = 10
        Imagebutton.layer.masksToBounds = true
        let barImagebutton = UIBarButtonItem(customView: Imagebutton)
        
        self.navigationItem.leftBarButtonItems = [barbackbutton,barImagebutton]
        
        let Rightbutton2 = UIButton(type: UIButton.ButtonType.custom)
        Rightbutton2.setImage(UIImage(named: "menu"), for: .normal)
        Rightbutton2.addTarget(self, action:#selector(menuMethod), for: .touchUpInside)
        Rightbutton2.frame = CGRect(x: 0, y: 0, width: 20, height: 30)
        let barRightbutton2 = UIBarButtonItem(customView: Rightbutton2)
        self.navigationItem.rightBarButtonItems = [barRightbutton2]
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
        let date = chatHandler.chatMetadata[chatID]?.latestMessageTimestamp!
        
        // Create Date Formatter
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.dateStyle = .long
        dateFormatter.timeStyle = .short

        titleLabel.text = dateFormatter.string(from: date!)
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = UIColor.lightGray
        titleLabel.font = UIFont(name: "Apercu-Regular", size: 15)
        titleLabel.textAlignment = .center
        
        let TITLEconstraints = [
            titleLabel.topAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.topAnchor, constant: 10),
            titleLabel.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor, constant: 0),
            titleLabel.heightAnchor.constraint(equalToConstant: 25)
            
        ]
        
        // FOR BOTTOM LAYOUT:
        // FOR bottomMsge :
        
        
        let bottomContainer = UIView()
        self.view.addSubview(bottomContainer)
        bottomContainer.backgroundColor = UIColor.init(red: 242/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        bottomContainer.translatesAutoresizingMaskIntoConstraints = false
        
        bottomContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        bottomContainer.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        bottomContainer.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        
        // FOR STACK VIEW:
        
        stackView.axis  = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 3
        
        let stackViewconstraints = [
            self.stackView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            self.stackView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            self.stackView.bottomAnchor.constraint(equalTo:  self.view.bottomAnchor),
            self.stackView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 100/812)
        ]
        
        bottomContainer.addSubview(stackView)
        
        let respondLaterBtn = UIButton()
        respondLaterBtn.setTitle("Respond Later", for: .normal)
        respondLaterBtn.setTitleColor(.black, for: .normal)
        respondLaterBtn.titleLabel?.font = UIFont(name: "Apercu-Bold", size: 15)
        //TODO: Delete chat in backend
        respondLaterBtn.backgroundColor = ViewBgColor
        respondLaterBtn.addTarget(self, action: #selector(deletePressed), for: .touchUpInside)
        
        let chatAcceptBtn = UIButton()
        chatAcceptBtn.setTitle("Chat", for: .normal)
        chatAcceptBtn.setTitleColor(themeColor, for: .normal)
        chatAcceptBtn.titleLabel?.font = UIFont(name: "Apercu-Bold", size: 15)
        chatAcceptBtn.backgroundColor = ViewBgColor
        chatAcceptBtn.addTarget(self, action: #selector(chatPressed), for: .touchUpInside)
        
        
        self.stackView.addArrangedSubview(respondLaterBtn)
        self.stackView.addArrangedSubview(chatAcceptBtn)
        
        let interchatWarning = UILabel()
        bottomContainer.addSubview(interchatWarning)
        interchatWarning.text = "Reply to see who is messaging you. They won't know who you are until you've responded."
        interchatWarning.textColor = Color.matte
        interchatWarning.font = UIFont(name: "Apercu-Medium", size: 17)
        interchatWarning.textAlignment = .center
        interchatWarning.numberOfLines = 0
        interchatWarning.lineBreakMode = .byWordWrapping
        
        let bottomMsgconstraints = [
            interchatWarning.bottomAnchor.constraint(equalTo:  stackView.topAnchor),
            interchatWarning.leftAnchor.constraint(equalTo: bottomContainer.leftAnchor, constant: 16),
            interchatWarning.rightAnchor.constraint(equalTo: bottomContainer.rightAnchor, constant: -16),
            interchatWarning.heightAnchor.constraint(equalToConstant: 90)
        ]
        bottomContainer.topAnchor.constraint(equalTo: interchatWarning.topAnchor, constant: 8).isActive = true
        
        //------------------------------------ FOR TABLE VIEWS--------------------------------------------------//
        
        // FOR TOP TABLE  :
        
        TopTable.separatorStyle = .none
        TopTable.backgroundColor = .clear
        TopTable.bounces = true
        TopTable.isScrollEnabled = true
        TopTable.register(ChatsbleViewCell.self, forCellReuseIdentifier: "cell")
        
        let TopTableconstraints = [
            self.TopTable.topAnchor.constraint(equalTo:  self.titleLabel.bottomAnchor, constant: 0),
            self.TopTable.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            self.TopTable.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            self.TopTable.bottomAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.bottomAnchor, constant: -150)
        ]
        self.view.addSubview(TopTable)
        
        self.TopTable.delegate = self
        self.TopTable.dataSource = self
        
        //-----------for activating constraints:
        
        NSLayoutConstraint.activate(TopTableconstraints)
        NSLayoutConstraint.activate(TITLEconstraints)
        NSLayoutConstraint.activate(stackViewconstraints)
        NSLayoutConstraint.activate(bottomMsgconstraints)
        
        self.view.layoutIfNeeded()
        self.stackView.layoutIfNeeded()
        
        TopTable.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        stackView.translatesAutoresizingMaskIntoConstraints = false
        interchatWarning.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    //MARK: Chat or delete pressed
    @objc func deletePressed() {
        self.navigationController?.popViewController(animated: true)
        print("delete pressed")
    }
    
    @objc func chatPressed() {
        
        //do da big reveal
        chatHandler.revealChat(chatId: self.chatID)
    //REVEAL VC WILL BE CALLED AFTER NOTIFICATION ONCE THE CHAT METADATA HAS BEEN UPDATED TO CONTAIN THE REVEAL IDENTITIES, THIS IS TO AVOID HAVING ANON NAME ON THERE
        
//        let revealVC = AnimationWaterBubbleVC(chatID: self.chatID)
//        self.navigationController?.isNavigationBarHidden = false
//        self.navigationController?.pushViewController(revealVC, animated: true)
        
        let chatVC = ChatsViewController(messageInputBarStyle: .facebook, chatID: self.chatID, post: nil)
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
        cell.ViewRight.topAnchor.constraint(equalTo:  cell.contentView.topAnchor, constant: 8).isActive = true
        
        cell.ViewRight.rightAnchor.constraint(equalTo:  cell.contentView.rightAnchor, constant: -20).isActive = true
        
        
        cell.labRight.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth).isActive = true
        cell.ViewRight.widthAnchor.constraint(equalTo:cell.labRight.widthAnchor,constant: 15).isActive = true
        cell.labRight.topAnchor.constraint(equalTo:  cell.ViewRight.topAnchor, constant: 8).isActive = true
        cell.labRight.rightAnchor.constraint(equalTo:  cell.ViewRight.rightAnchor, constant: -8).isActive = true
        
        
        cell.Viewleft.topAnchor.constraint(equalTo:  cell.contentView.topAnchor, constant: 8).isActive = true
        
        cell.Viewleft.leftAnchor.constraint(equalTo:  cell.contentView.leftAnchor, constant: 20).isActive = true
        
        cell.labLeft.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth).isActive = true
        cell.Viewleft.widthAnchor.constraint(equalTo:cell.labLeft.widthAnchor,constant: 15).isActive = true
        cell.labLeft.topAnchor.constraint(equalTo:  cell.Viewleft.topAnchor, constant: 8).isActive = true
        cell.labLeft.leftAnchor.constraint(equalTo:  cell.Viewleft.leftAnchor, constant: 8).isActive = true
        
        cell.labRight.bottomAnchor.constraint(equalTo:  cell.contentView.bottomAnchor, constant: -14).isActive = true
        cell.labLeft.bottomAnchor.constraint(equalTo:  cell.contentView.bottomAnchor, constant: -14).isActive = true

        cell.ViewRight.bottomAnchor.constraint(equalTo:  cell.labRight.bottomAnchor, constant: 8).isActive = true
        cell.Viewleft.bottomAnchor.constraint(equalTo:  cell.labLeft.bottomAnchor, constant: 8).isActive = true
        
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
