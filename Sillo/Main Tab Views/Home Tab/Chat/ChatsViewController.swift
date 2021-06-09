/*
 MIT License
 
 Copyright (c) 2017-2018 MessageKit
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit
import MessageInputBar
import Firebase

enum MessageInputBarStyle: String {
    
    case facebook = "Facebook"
    case `default` = "Default"
    
    func generate() -> MessageInputBar {
        switch self {
        // case .imessage: return iMessageInputBar()
        // case .slack: return SlackInputBar()
        // case .githawk: return GitHawkInputBar()
        case .facebook: return FacebookInputBar()
        case .default: return MessageInputBar()
        }
    }
}

final class ChatsViewController: UITableViewController {
    
    // MARK: - Properties
    
    override var inputAccessoryView: UIView? {
        return messageInputBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    /// The object that manages attachments
    /*  lazy var attachmentManager: AttachmentManager = { [unowned self] in
     let manager = AttachmentManager()
     manager.delegate = self
     return manager
     }()
     
     /// The object that manages autocomplete
     lazy var autocompleteManager: AutocompleteManager = { [unowned self] in
     let manager = AutocompleteManager(for: self.messageInputBar.inputTextView)
     manager.delegate = self
     manager.dataSource = self
     return manager
     }()*/
    
    let screenSize = UIScreen.main.bounds
    
    // MARK: - MessageInputBar
    
    private let messageInputBar: MessageInputBar
    var chatID: String
    var initPost: Post?
    
    let profilePreviewVC:ProfileVC = {
        let vc = ProfileVC()
        vc.modalPresentationStyle = .automatic
        vc.modalTransitionStyle = .coverVertical
        return vc
    }()
    
    //MARK: listener
    private var activeChatListener: ListenerRegistration?
    private var messageListener: ListenerRegistration?
    deinit {
        messageListener?.remove()
        activeChatListener?.remove()
    }
    
    let appearance : UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        appearance.backgroundColor = Color.headerBackground
        return appearance
    }()
    
    let Imagebutton : UIButton = {
        return UIButton(type: UIButton.ButtonType.custom)
    } ()
    
    let header : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.headerBackground
        return view
    }()
    
    // MARK: Init
    var atBottom = true
    
    init(messageInputBarStyle: MessageInputBarStyle, chatID: String, post: Post?) {
        
        self.chatID = chatID
        self.messageInputBar = messageInputBarStyle.generate()
        self.messageInputBar.inputTextView.textColor = .black
        
        super.init(nibName: nil, bundle: nil)
        
        if let inputpost = post {
            print("set init post whose message is \(inputpost.message)")
            self.initPost = inputpost
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    @objc func refreshChatView(note: NSNotification) {
        //refresh the subtask table
        self.tableView.reloadData()
        //scrolls to bottom row when new message added, ONLY IF ALREADY AT THE BOTTOM
//        if self.atBottom{ //IMPLEMENT THIS LATER ONCE ATBOTTOM WORKS OK!
            self.tableView.scrollToBottomRow()
//        }
        print("refreshed the chatView")
        
    }
    
    //NOT FUNCTIONAL RIGHT NOW, BUT THIS COULD MAYBE SOLVE THE ISSUE ON PREVENTING SCROLLING TO BOTTOM WHEN READING TOP MESSAGES
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.contentOffset.y
        let contentSizeHeight = scrollView.contentSize.height // this is the height of the tableview content
        let frameHeight = scrollView.frame.size.height
        
        print("offset", offset + 1)
        print("contentSizeHeight", contentSizeHeight + 1)
        print("framehEIGHT", frameHeight + 1)
        

    if (offset + 100 >= (contentSizeHeight - frameHeight)) {
        self.atBottom = true
        print("at the bottom: offset is \(offset), \(contentSizeHeight-frameHeight)")
    }

    if (offset < 0){
        self.atBottom = false
        //print("at the top: offset is \(offset)")
    }

    if (offset >= 0 && offset < (contentSizeHeight - frameHeight)){
        self.atBottom = false
        //print("not bottom not top, middle: offset is \(offset)")
    }}
    
    //notification callback for refreshing profile picture
    @objc func refreshPic(_:UIImage) {
        let profilePictureRef = "profiles/\(chatHandler.chatMetadata[self.chatID]?.recipient_uid ?? "")\(Constants.image_extension)" as NSString
        if imageCache.object(forKey: profilePictureRef) != nil { //image in cache
            
            //check if conversation is revealed
            if chatHandler.chatMetadata[self.chatID] != nil && chatHandler.chatMetadata[self.chatID]!.isRevealed! {
                let cachedImage = imageCache.object(forKey: profilePictureRef)! //fetch from cache
                Imagebutton.setImage(cachedImage, for: .normal) //set image
                self.profilePreviewVC.profilePic = cachedImage
            }
        }
    }
    
    @objc func revealUser(note: NSNotification) {
        print("OP has just accepted ur message and you are now revealed to each other!")
        let revealVC = AnimationWaterBubbleVC(chatID: self.chatID)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(revealVC, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //load in profile info
        if let metadata = chatHandler.chatMetadata[self.chatID] {
            let userID = metadata.recipient_uid!
            retrieveUserProfile(userID:userID)
        }
        else {
            //use when conversation doesn't exist yet (clicked on post)
            let userID = self.initPost?.posterUserID ?? "ERROR"
            retrieveUserProfile(userID: userID)
            
        }
        
        //now that message has been opened, mark as read for user
        chatHandler.readChat(userID: Constants.FIREBASE_USERID!, chatId: self.chatID)
        
        
        self.navigationController?.navigationBar.isHidden = false
        self.hidesBottomBarWhenPushed = true
        self.tabBarController?.tabBar.isHidden = true
        
        setNavBar()
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshChatView(note:)), name: Notification.Name("refreshChatView"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshPic), name: Notification.Name(rawValue: "refreshPicture"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(revealUser), name: Notification.Name(rawValue: "revealUser"), object: nil)
        
        if !Array(chatHandler.chatMetadata.keys).contains(self.chatID) { //is is not a chat, should only display one image, which is post. not from firebase.
            //convert post into message
            
            //let msg = Message(messageID: "DUMMY", senderID: self.initPost?.posterUserID, message: self.initPost?.message, attachment: UIImage(), timestamp: self.initPost?.date, isRead: false)
            let firstPost = Message(messageID: "DUMMY", senderID: self.initPost?.posterUserID, message: self.initPost?.message, attachment: UIImage(named: (self.initPost?.attachment)!), timestamp: self.initPost?.date, isRead: true)
            chatHandler.messages[self.chatID] = [firstPost]
        }else { //avoid appending the first post twice
            chatHandler.messages[self.chatID] = []
        }
        
        //add listener to chat metadata (for reveals)        
        let reference = db.collection("user_chats").document(Constants.FIREBASE_USERID!).collection(organizationData.currOrganization!)
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
                    chatHandler.handleNewUserChat(chatID: chatID, data: diff.document.data())
                }
                if (diff.type == .modified) {
                    let chatID = diff.document.documentID
                    print("updated active chat: \(chatID)")
                    //add or update active chat
                    chatHandler.handleNewUserChat(chatID: chatID, data: diff.document.data())
                    
                }
                if (diff.type == .removed) {
                    let chatID = diff.document.documentID
                    print("Removed conversation: \(chatID)")
                    chatHandler.chatMetadata[chatID] = nil
                    chatHandler.sortedChatMetadata = chatHandler.sortChatMetadata()
                }
            }
        }
        
        //MARK: Allows swipe from left to go back (making it interactive caused issue with the header)
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(leftEdgeSwipe))
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
        
        
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
                            chatHandler.messages[self.chatID] = chatHandler.sortMessages(messages: chatHandler.messages[self.chatID]!)
                            
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
        //updateMessages()
        
        //for initialising Table:
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        
        self.tableView.separatorStyle = .none
        
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.view.backgroundColor = .white
        
        self.tableView.register(ChatsbleViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        view.backgroundColor = ViewBgColor
        tableView.keyboardDismissMode = .interactive
        messageInputBar.delegate = self
        //scroll to bottom when first opening the app
        self.tableView.scrollToBottomRow()
    }
    
    //MARK: function for left swipe gesture
    @objc func leftEdgeSwipe(_ recognizer: UIScreenEdgePanGestureRecognizer) {
       if recognizer.state == .recognized {
            backBtnPressed()
       }
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    @objc private func keyboardWillShow(notification: NSNotification) {
        
        print("keyb show")
        
        var _kbSize:CGSize!
        
        if let info = notification.userInfo {
            
            let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
            
            //  Getting UIKeyboardSize.
            if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
                
                let screenSize = UIScreen.main.bounds
                
                //Calculating actual keyboard displayed size, keyboard frame may be different when hardware keyboard is attached (Bug ID: #469) (Bug ID: #381)
                let intersectRect = kbFrame.intersection(screenSize)
                
                if intersectRect.isNull {
                    _kbSize = CGSize(width: screenSize.size.width, height: 0)
                } else {
                    _kbSize = intersectRect.size
                }
                print("Your Keyboard Size \(_kbSize)")
                tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: _kbSize.height, right: 0)
            }
        }
        
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        print("keyb hide")
        
        self.tableView.contentInset = .zero
    }
    func setNavBar() {
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.standardAppearance = self.appearance
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 242/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        //Set name and picture of person you're conversing with on header
        let label = UILabel()
        //todo: replace with revealed
        var profilePicName = chatHandler.chatMetadata[chatID]?.recipient_image ?? self.initPost?.posterImageName
        var person = chatHandler.chatMetadata[chatID]?.recipient_name ?? self.initPost?.posterAlias!
        label.text = person
        label.textAlignment = .left
        label.textColor = Color.matte
        label.font = UIFont(name: "Apercu Bold", size: 20)
        
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
        
        
        Imagebutton.setImage(UIImage(named: profilePicName!), for: .normal)
        
        if chatHandler.chatMetadata[self.chatID] != nil {
            if chatHandler.chatMetadata[self.chatID]!.isRevealed! {
                let picRef:NSString = "profiles/\(chatHandler.chatMetadata[self.chatID]!.recipient_uid!)\(Constants.image_extension)" as NSString
                var firebaseImage:UIImage? = nil
                if (imageCache.object(forKey: picRef) != nil) {
                    firebaseImage = imageCache.object(forKey: picRef)
                }
                else {
                    firebaseImage = cloudutil.downloadImage(ref: "profiles/\(chatHandler.chatMetadata[self.chatID]!.recipient_uid!)\(Constants.image_extension)")
                }
                Imagebutton.setImage(firebaseImage!, for: .normal)
            }
        }
        
        Imagebutton.addTarget(self, action:#selector(showProfile), for: .touchUpInside)
        Imagebutton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        Imagebutton.clipsToBounds = true
        Imagebutton.imageView?.contentMode = .scaleAspectFill
        Imagebutton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        Imagebutton.heightAnchor.constraint(equalToConstant: 40).isActive = true
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
    
    //MARK: objc functions
    @objc func backBtnPressed() {
        if self.initPost != nil && !Array(chatHandler.chatMetadata.keys).contains(self.chatID) { // if no chat was ever made, remove from postToChat
            print("no chat made, set postToChat for this post back to nil")
            chatHandler.postToChat[(self.initPost?.postID)!] = nil
        }
        self.tabBarController?.tabBar.isHidden = false
        
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func showProfile() {
        self.present(self.profilePreviewVC, animated: true, completion: nil)
    }
    
    @objc func menuMethod() {
        //haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        generator.impactOccurred()
        
        DispatchQueue.main.async {
            let alert = AlertView(headingText: "Report user for inappropriate behavior?", messageText: "Your space's admin will be notified.", action1Label: "Cancel", action1Color: Color.buttonClickableUnselected, action1Completion: {
                self.dismiss(animated: true, completion: nil)
            }, action2Label: "Report", action2Color: Color.burple, action2Completion: {
                self.dismiss(animated: true, completion: nil); self.reportUser()
            }, withCancelBtn: false, image: UIImage(named:"reported post"), withOnlyOneAction: false)
            alert.modalPresentationStyle = .overCurrentContext
            alert.modalTransitionStyle = .crossDissolve
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: report user
    func reportUser() {
        let reporterID = Constants.FIREBASE_USERID!
        if let metadata = chatHandler.chatMetadata[self.chatID] {
            let posterID = metadata.recipient_uid ?? "ERROR"
            
            let reportUserRef = db.collection("reports").document(organizationData.currOrganization!).collection("reported_users").document(posterID)
            reportUserRef.getDocument() { (query, err) in
                if query != nil && query!.exists {
                    reportUserRef.updateData(["count":FieldValue.increment(1 as Int64), "reporters": FieldValue.arrayUnion([reporterID])])
                }
                else {
                    reportUserRef.setData(["count":1,"reporters":[reporterID]])
                }
            }
        }
    }
    
    //MARK: retrieve profile information
    func retrieveUserProfile(userID: String) {
        var profileDocumentName = "all_orgs"
        
        //get document info
        let upperUserRef = db.collection("profiles").document(userID)
        upperUserRef.getDocument { (document, error) in
            if let document = document, document.exists {
                //document exists, pull separate profile state
                let use_separate_profiles = document.get("use_separate_profiles") as! Bool
                if (use_separate_profiles) {
                    profileDocumentName = organizationData.currOrganization ?? "ERROR"
                }
                let userRef = db.collection("profiles").document(userID).collection("org_profiles").document(profileDocumentName)

                //actually pull the document
                userRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let innerDict = document.data()!
                        //pull name, but if chat doesn't exist use the post alias,
                        //if alias doesn't exist, well helo there Kevin Nguyen
                        let posterAlias:String = self.initPost?.posterAlias! ?? "Kevin Nguyen"
                        self.profilePreviewVC.name = chatHandler.chatMetadata[self.chatID]?.recipient_name ?? posterAlias
                        
                        //if conversation doesn't exist, revealed is false
                        let revealed:Bool = chatHandler.chatMetadata[self.chatID]?.isRevealed ?? false
                        
                        if revealed {
                            self.profilePreviewVC.pronouns = innerDict["pronouns"] as! String
                            self.profilePreviewVC.bio = innerDict["bio"] as! String
                            
                            if chatHandler.chatMetadata[self.chatID] != nil && chatHandler.chatMetadata[self.chatID]!.isRevealed! {
                                let profilePictureRef = "profiles/\(chatHandler.chatMetadata[self.chatID]?.recipient_uid ?? "")\(Constants.image_extension)" as NSString
                                if imageCache.object(forKey: profilePictureRef) != nil {
                                    let cachedImage = imageCache.object(forKey: profilePictureRef)! //fetch from cache
                                    self.profilePreviewVC.profilePic = cachedImage
                                }
                                else {
                                    cloudutil.downloadImage(ref: profilePictureRef as String)
                                }
                            }
                        }
                        else {
                            self.profilePreviewVC.pronouns = "Pronouns locked"
                            self.profilePreviewVC.bio = "Bio locked"
                            //if conversation doesn't exist, use the associated post image,
                            //if that doesn't exist, avatar-4
                            let postProfilePic = self.initPost?.posterImageName ?? "avatar-4"
                            let profileImageName = chatHandler.chatMetadata[self.chatID]?.recipient_image ?? postProfilePic
                            let profileImage = UIImage(named: profileImageName)!
                            self.profilePreviewVC.profilePic = profileImage
                        }
                        
                        self.profilePreviewVC.restaurants = innerDict["restaurants"] as! [String]
                        self.profilePreviewVC.interests = innerDict["interests"] as! [String]
                        self.profilePreviewVC.previewMode = false
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshProfileView"), object: nil)
                    }
                }
            }
        }
    }
    
    //MARK: view will disappear
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
        print("DEINIT")
        activeChatListener?.remove()
        messageListener?.remove()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if #available(iOS 13, *) {
            let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
            statusBar.backgroundColor = UIColor.init(red: 242/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
            UIApplication.shared.keyWindow?.addSubview(statusBar)
        }
        else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.init(red: 242/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        }
    }
    
    
    
    //=============================*** DELEGATE DATASOURCE METHODS ***===============================//
    
    //MARK :  Table View Delegate Methods:
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatHandler.messages[self.chatID]?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
        cell.ViewRight.widthAnchor.constraint(equalTo:cell.labRight.widthAnchor,constant: 20).isActive = true
        cell.labRight.topAnchor.constraint(equalTo:  cell.ViewRight.topAnchor, constant: 8).isActive = true
        cell.labRight.rightAnchor.constraint(equalTo:  cell.ViewRight.rightAnchor, constant: -8).isActive = true
        
        
        cell.Viewleft.topAnchor.constraint(equalTo:  cell.contentView.topAnchor, constant: 8).isActive = true
        
        cell.Viewleft.leftAnchor.constraint(equalTo:  cell.contentView.leftAnchor, constant: 20).isActive = true
        
        cell.labLeft.widthAnchor.constraint(lessThanOrEqualToConstant: maxWidth).isActive = true
        cell.Viewleft.widthAnchor.constraint(equalTo:cell.labLeft.widthAnchor,constant: 20).isActive = true
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

extension ChatsViewController: MessageInputBarDelegate {
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        // Use to send the message
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
        print(text)
        
        if !chatHandler.chatMetadata.keys.contains(chatID){ // if this is first reply, create new chat
            //clear the dummy, the new REAL messages (including the initial message) will come thru
            chatHandler.messages[self.chatID] = []
            
            //addChat creates new chat document and adds post and message to doc, and adds chatID to both poster and user's user_chats
            chatHandler.addChat(post: self.initPost!, message: text, attachment: nil, chatId: self.chatID)
            
            //log chat creation
            analytics.log_create_chat()
            
            //add metadata so we don't have to go through this again (next call with go straight into else)
            chatHandler.chatMetadata[chatID] = ChatMetadata(chatID: chatID, postID: initPost?.postID, isRead: true, isRevealed: false, latest_message: text, latestMessageTimestamp: Date(), recipient_image: initPost?.posterImageName, recipient_name: initPost?.posterAlias, recipient_uid: initPost?.posterUserID, timestamp: Date())
            
            //TODO: make sure chatList is up to date and now contains the new chatID
        }else {
            //if this is already a chat, no need to make a new coument or add to user_chats
            //simply add message to the chat document
            let recipientID = chatHandler.chatMetadata[self.chatID]!.recipient_uid!
            chatHandler.sendMessage(chatId: self.chatID, message: text, attachment: nil, recipientID: recipientID)
        }
        
        //call pulls from firebase, then refreshes tableview as callback
        //updateMessages()
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, textViewTextDidChangeTo text: String) {
        // Use to send a typing indicator
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didChangeIntrinsicContentTo size: CGSize) {
        // Use to change any other subview insets
    }
    
}


// MARK: - AttachmentManagerDelegate


// MARK: - AttachmentManagerDelegate Helper




// MARK: - AutocompleteManagerDelegate Helper



extension ChatsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        dismiss(animated: true, completion: {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
                /* let handled = self.attachmentManager.handleInput(of: pickedImage)
                 if !handled {
                 // throw error
                 }*/
            }
        })
    }
}


class ChatsbleViewCell: UITableViewCell {
    
    //the text
    let labRight = UILabel()
    let labLeft = UILabel()
    
    //the bubble
    let Viewleft = UIView()
    let ViewRight = UIView()
    
    
    var labLeftconstraints = [NSLayoutConstraint]()
    var labRightconstraints = [NSLayoutConstraint]()
    
    var Viewleftconstraints = [NSLayoutConstraint]()
    var ViewRightconstraints = [NSLayoutConstraint]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // for views:
        contentView.addSubview(ViewRight)
        ViewRight.backgroundColor = hexStringToUIColor(hex: "#E7EFFB")
        ViewRight.layer.cornerRadius = 17
      
        contentView.addSubview(Viewleft)
        Viewleft.backgroundColor = UIColor.init(red: 253/255.0, green: 242/255.0, blue: 220/255.0, alpha: 1)
        Viewleft.layer.cornerRadius = 17
        
        // FOR LABELS :
        ViewRight.addSubview(labRight)
        labRight.textColor = .black
        labRight.font = UIFont(name: "Apercu-Regular", size: 15)
        labRight.numberOfLines = 0
        labRight.textAlignment = .right
        labRight.clipsToBounds = true
        
        Viewleft.addSubview(labLeft)
        labLeft.textColor = .black
        labLeft.font = UIFont(name: "Apercu-Regular", size: 15)
        labLeft.textAlignment = .left
        labLeft.numberOfLines = 0
        labLeft.clipsToBounds = true
        labRight.lineBreakMode = .byWordWrapping
        labLeft.lineBreakMode = .byWordWrapping
        
        ViewRight.translatesAutoresizingMaskIntoConstraints = false
        Viewleft.translatesAutoresizingMaskIntoConstraints = false
        
        labRight.translatesAutoresizingMaskIntoConstraints = false
        labLeft.translatesAutoresizingMaskIntoConstraints = false
    
        contentView.layoutIfNeeded()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
extension String {
    var stringWidth: CGFloat {
        let constraintRect = CGSize(width: UIScreen.main.bounds.width, height: .greatestFiniteMagnitude)
        let boundingBox = self.trimmingCharacters(in: .whitespacesAndNewlines).boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: UIFont(name: "Apercu-Regular", size: 15)], context: nil)
        return boundingBox.width
    }
    
    var stringHeight: CGFloat {
        let constraintRect = CGSize(width: UIScreen.main.bounds.width, height: .greatestFiniteMagnitude)
        let boundingBox = self.trimmingCharacters(in: .whitespacesAndNewlines).boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: UIFont(name: "Apercu-Regular", size: 15)], context: nil)
        return boundingBox.height
    }
}

extension UITableView {
    func scrollToBottomRow() {
        DispatchQueue.main.async {
            guard self.numberOfSections > 0 else { return }
            
            // Make an attempt to use the bottom-most section with at least one row
            var section = max(self.numberOfSections - 1, 0)
            var row = max(self.numberOfRows(inSection: section) - 1, 0)
            var indexPath = IndexPath(row: row, section: section)
            
            // Ensure the index path is valid, otherwise use the section above (sections can
            // contain 0 rows which leads to an invalid index path)
            while !self.indexPathIsValid(indexPath) {
                section = max(section - 1, 0)
                row = max(self.numberOfRows(inSection: section) - 1, 0)
                indexPath = IndexPath(row: row, section: section)
                
                // If we're down to the last section, attempt to use the first row
                if indexPath.section == 0 {
                    indexPath = IndexPath(row: 0, section: 0)
                    break
                }
            }
            
            // In the case that [0, 0] is valid (perhaps no data source?), ensure we don't encounter an
            // exception here
            guard self.indexPathIsValid(indexPath) else { return }
            
            self.scrollToRow(at: indexPath, at: .bottom, animated: false)
        }
    }
    
    func indexPathIsValid(_ indexPath: IndexPath) -> Bool {
        let section = indexPath.section
        let row = indexPath.row
        return section < self.numberOfSections && row < self.numberOfRows(inSection: section)
    }
}
