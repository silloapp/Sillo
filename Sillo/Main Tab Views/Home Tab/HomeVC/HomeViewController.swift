//
//  HomeViewController.swift
//  Sillo
//
//  Created by Eashan Mathur on 1/28/21.
//

import UIKit
import Firebase
import FloatingPanel


class HomeViewController: UIViewController {
    
    var orgPickerPanel: FloatingPanelController!
    let cellID = "cellID"
    let stickerCellID = "stickerCellID"
    let gifCellID = "gifCellID"
    let postsTable : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        table.showsVerticalScrollIndicator = false
        table.separatorColor = .clear
        return table
    }()
    
    let clubName = UILabel()
    let teamPic = UIImageView()
    
    public let header : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.headerBackground
        return view
    }()
        
    let blurEffect = UIBlurEffect(style: .systemMaterialDark)
    var blurVw = UIVisualEffectView()
    
    //MARK: listener
    private var postListener: ListenerRegistration?
    
    deinit {
       postListener?.remove()
     }
    
    override func viewWillDisappear(_ animated: Bool) {
        postListener?.remove()
    }
    
    @objc func tabBarOpacityChange(note: NSNotification) {
        self.tabBarController?.tabBar.alpha = 1
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfHideBlur(notification:)), name: Notification.Name("HideBlurNotificationIdentifier"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfShowBlur(notification:)), name: Notification.Name("ShowBlurNotificationIdentifier"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshTableView(note:)), name: Notification.Name("refreshPostTableView"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.tabBarOpacityChange(note:)), name: Notification.Name("PopupDidAppear"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshOrganizationTitleLabel), name: Notification.Name(rawValue: "refreshOrgTitleLabel"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTeamPic), name: Notification.Name(rawValue: "refreshPicture"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(scrollToTop), name: Notification.Name(rawValue: "scrollToTopOfFeed"), object: nil)
        
        //MARK: attach listener
        let organizationID = organizationData.currOrganization ?? "ERROR"
        let reference = db.collection("organization_posts").document(organizationID).collection("posts").order(by: "timestamp", descending: true).limit(to: feed.postBatchSize)
        postListener = reference.addSnapshotListener { querySnapshot, error in
          guard let snapshot = querySnapshot else {
            
            print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
            return
          }
            //set most recent snapshot (like a bookmark)
            feed.snapshot = snapshot
            
            //handle document changes
            snapshot.documentChanges.forEach { change in
                self.handlePostDocumentChange(change)
            }
        }
        quests.coldStart()
        chatHandler.coldStart()
        localUser.setLastActiveTimestamp()
    }
    
    //notification callback for refreshing profile picture
    @objc func refreshTeamPic(_:UIImage) {
        if organizationData.currOrganization != nil { //there is a chance that this will get called while currOrg is still null
            let orgPicRef = "orgProfiles/\(organizationData.currOrganization!)\(Constants.image_extension)" as NSString
            if imageCache.object(forKey: orgPicRef)?.image != nil { //image in cache
                let cachedImageItem = imageCache.object(forKey: orgPicRef)! //fetch from cache
                self.teamPic.image = cachedImageItem.image
            }
            else {
                cloudutil.downloadImage(ref: orgPicRef as String)
            }
        }
    }
    
    @objc func refreshOrganizationTitleLabel(_:NSNotification) {
        self.clubName.text = organizationData.currOrganizationName ?? "My Organization"
    }
    
    //notification callback for scrolling to top
    @objc func scrollToTop() {
        self.postsTable.setContentOffset(.zero, animated: true)
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        overrideUserInterfaceStyle = .light
        setupHeader()
        setupTableView()
        
        orgPickerPanel = FloatingPanelController()
        orgPickerPanel.delegate = self
        
        orgPickerPanel.layout = MyFloatingPanelLayout()
        orgPickerPanel.behavior = MyFloatingPanelBehavior()
        orgPickerPanel.isRemovalInteractionEnabled = true
        orgPickerPanel.backdropView.dismissalTapGestureRecognizer.isEnabled = true
        
        let apperance = SurfaceAppearance()
        apperance.cornerRadius = 25
        orgPickerPanel.surfaceView.appearance = apperance
        let contentVC = OrganizationPickerViewController()
        orgPickerPanel.set(contentViewController: contentVC)
        orgPickerPanel.track(scrollView: contentVC.tableView)
        
    
        navigationController?.navigationBar.barTintColor = Color.headerBackground
        navigationController?.navigationBar.isTranslucent = false
        
//        addDismissPullUpController(animated: false)
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    
    func setupHeader() {
        view.addSubview(header)
        
        // MARK: Blur View Constraints
        
        blurVw = UIVisualEffectView(effect: blurEffect)
        //always fill the view
        blurVw.frame = self.view.bounds
        blurVw.alpha = 0.75
        blurVw.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(blurVw)
        
        let blurVwconstraints = [
            blurVw.topAnchor.constraint(equalTo: self.view.topAnchor),
            blurVw.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            blurVw.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            blurVw.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ]
        blurVw.isHidden = true
        
        NSLayoutConstraint.activate(blurVwconstraints)
        self.view.layoutIfNeeded()
        blurVw.translatesAutoresizingMaskIntoConstraints = false
        
        header.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        header.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        header.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 110/812).isActive = true
        
        //app logo and team name stack
        let logoTeamStack = setupPhotoTeamName()
        header.addSubview(logoTeamStack)
        
        logoTeamStack.leadingAnchor.constraint(equalTo: header.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        logoTeamStack.topAnchor.constraint(equalTo: header.safeAreaLayoutGuide.topAnchor).isActive = true
        logoTeamStack.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -15).isActive = true
        logoTeamStack.heightAnchor.constraint(equalToConstant: 40).isActive = true

        //team picture
        let orgPicRef = "orgProfiles/\(organizationData.currOrganization!)\(Constants.image_extension)" as NSString
        if imageCache.object(forKey: orgPicRef)?.image != nil { //image in cache
            let cachedImage = imageCache.object(forKey: orgPicRef)! //fetch from cache
            teamPic.image = cachedImage.image
        }
        else {
            cloudutil.downloadImage(ref: orgPicRef as String)
            teamPic.image = UIImage(named: "avatar-2")
        }
        teamPic.translatesAutoresizingMaskIntoConstraints = false
        //teamPic.contentMode = .scaleAspectFit
        teamPic.layer.masksToBounds = true
        teamPic.layer.borderWidth = 5.0
        teamPic.layer.borderColor = Color.gray.cgColor
        teamPic.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        teamPic.layer.cornerRadius = teamPic.frame.height / 2
        teamPic.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.profilePicTapped))
        teamPic.addGestureRecognizer(tap)
        header.addSubview(teamPic)
        
        teamPic.rightAnchor.constraint(equalTo: header.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        teamPic.centerYAnchor.constraint(equalTo: logoTeamStack.centerYAnchor).isActive = true
        teamPic.heightAnchor.constraint(equalToConstant: 45).isActive = true
        teamPic.widthAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.view.layoutIfNeeded()
    }
    
//    MARK: Detect blur tap
    
    @objc func blurTapped() {
        print("tapped")
        NotificationCenter.default.post(name: Notification.Name("DismissNotificationIdentifier"), object: nil)
    }
    
    @objc func profilePicTapped() {
        self.present(orgPickerPanel, animated: true, completion: nil)
    }
    
    
    
    
    func setupPhotoTeamName() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 11
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let silloLogo = UIImageView()
        silloLogo.image = UIImage(named: "sillo-logo-small")
        silloLogo.contentMode = .scaleAspectFit
        stack.addArrangedSubview(silloLogo)
        
        self.clubName.text = organizationData.currOrganizationName ?? "My Organization"
        self.clubName.font = UIFont(name:"Apercu-Bold", size: 22)
        self.clubName.textColor = Color.teamHeader
        stack.addArrangedSubview(self.clubName)
        
        return stack
    }
    
    func setupTableView() {
        postsTable.delegate = self
        postsTable.dataSource = self
        self.view.addSubview(postsTable)
        view.sendSubviewToBack(postsTable)
        postsTable.rowHeight = UITableView.automaticDimension
        postsTable.estimatedRowHeight = 200
        postsTable.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        postsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        postsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        postsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        postsTable.register(HomePostTableViewCell.self, forCellReuseIdentifier: cellID)
        postsTable.register(HomePostTableViewCellSticker.self, forCellReuseIdentifier: stickerCellID)
        postsTable.register(HomePostTableViewCellGIF.self, forCellReuseIdentifier: gifCellID)
    }
    
    //MARK: handle document changes
    private func handlePostDocumentChange(_ change: DocumentChange) {
      switch change.type {
      case .added:
        feed.handleNewPost(id: change.document.documentID, data: change.document.data())
      case .removed:
        feed.handleDeletePost(id: change.document.documentID, data: change.document.data())
      default:
        break
      }
    }
    
    //MARK: refresh called
    @objc func refreshTableView(note: NSNotification) {
        feed.sortedPosts = feed.sortPosts()
        self.postsTable.reloadData()
    }
}


extension HomeViewController: FloatingPanelControllerDelegate {
    
    func floatingPanelDidMove(_ vc: FloatingPanelController) {
        if vc.isAttracting == false {
            let loc = vc.surfaceLocation
            let minY = vc.surfaceLocation(for: .half).y
            let maxY = vc.surfaceLocation(for: .half).y + 600.0
            vc.surfaceLocation = CGPoint(x: loc.x, y: min(max(loc.y, minY), maxY))
        }
    }
    
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = nil
        let posts_count = feed.posts.count
        if posts_count > 0 {
            return posts_count
        }
        else {
            //MARK: set up fallback if table is empty
            
            let noPostsUIView: UIView = {
                let bigView = UIView()
                
                
                let imageView : UIImageView = {
                    let view = UIImageView()
                    let scaling:CGFloat = 0.2
                    view.frame = CGRect(x: 0, y: 0, width: scaling*(tableView.bounds.width), height: scaling*(tableView.frame.height))
                    view.clipsToBounds = true
                    view.contentMode = .scaleAspectFit
                    let image = UIImage(named:"no-posts")
                    view.image = image
                    view.translatesAutoresizingMaskIntoConstraints = false
                    return view
                }()
                bigView.addSubview(imageView)
                imageView.centerXAnchor.constraint(equalTo: bigView.centerXAnchor).isActive = true
                imageView.centerYAnchor.constraint(equalTo: bigView.centerYAnchor, constant: -50).isActive = true
                return bigView
            }()
            

            tableView.backgroundView = noPostsUIView
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row + 5 == feed.posts.count {
            //we're almost at the end, pull more posts
            feed.getNextBatch()
        }
        let post = feed.sortedPosts[indexPath.row]
        if post.attachment == "" {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! HomePostTableViewCell
            cell.item = post
            cell.separatorInset = UIEdgeInsets.zero
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(optionsTapped(tapGestureRecognizer:)))
            cell.optionsButton.addGestureRecognizer(tapGestureRecognizer)
            return cell
        }
        else if post.attachment!.contains("Sticker") {
            let cell = tableView.dequeueReusableCell(withIdentifier: stickerCellID, for: indexPath) as! HomePostTableViewCellSticker
            cell.item = post
            cell.separatorInset = UIEdgeInsets.zero
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(optionsTapped(tapGestureRecognizer:)))
            cell.optionsButton.addGestureRecognizer(tapGestureRecognizer)
            return cell
        }
        else { //gif cell
            let cell = tableView.dequeueReusableCell(withIdentifier: gifCellID, for: indexPath) as! HomePostTableViewCellGIF
            cell.item = post
            cell.separatorInset = UIEdgeInsets.zero
            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(optionsTapped(tapGestureRecognizer:)))
            cell.optionsButton.addGestureRecognizer(tapGestureRecognizer)
            return cell
        }
    }
    @objc func optionsTapped(tapGestureRecognizer:UITapGestureRecognizer) {
        let sender = tapGestureRecognizer.view as! ReportButton
        let post = sender.post!
        
        //cannot report oneself, but can delete post
        if post.posterUserID! == Constants.FIREBASE_USERID! {
            DispatchQueue.main.async {
                let alert = AlertView(headingText: "My Post Options", messageText: "", action1Label: "Cancel", action1Color: Color.buttonClickableUnselected, action1Completion: {
                    self.dismiss(animated: true, completion: nil)
                }, action2Label: "Delete Post", action2Color: Color.burple, action2Completion: {
                    self.dismiss(animated: false, completion: nil);self.confirmDeletePost(postID: post.postID!)
                }, withCancelBtn: false, image: nil, withOnlyOneAction: false)
                alert.modalPresentationStyle = .overCurrentContext
                alert.modalTransitionStyle = .crossDissolve
                self.present(alert, animated: true, completion: nil)
            }
        }
        else { //report this post
            //haptic feedback
            let generator = UIImpactFeedbackGenerator(style: .light)
            generator.prepare()
            generator.impactOccurred()
            
            DispatchQueue.main.async {
                let alert = AlertView(headingText: "Flag this post as inappropriate?", messageText: "Your space's admin will be notified.", action1Label: "Cancel", action1Color: Color.buttonClickableUnselected, action1Completion: {
                    self.dismiss(animated: true, completion: nil)
                }, action2Label: "Report", action2Color: Color.burple, action2Completion: {
                    self.dismiss(animated: true, completion: nil); self.reportPost(post: post)
                }, withCancelBtn: false, image: UIImage(named:"reported post"), withOnlyOneAction: false)
                alert.modalPresentationStyle = .overCurrentContext
                alert.modalTransitionStyle = .crossDissolve
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    func confirmDeletePost(postID: String) { //confirm delete
        //haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred()
        
        DispatchQueue.main.async {
            let alert = AlertView(headingText: "Delete this post?", messageText: "This cannot be undone.", action1Label: "Cancel", action1Color: Color.buttonClickableUnselected, action1Completion: {
                self.dismiss(animated: true, completion: nil)
            }, action2Label: "Delete", action2Color: Color.salmon, action2Completion: {
                self.dismiss(animated: true, completion: nil); feed.deletePost(postID: postID)
            }, withCancelBtn: false, image: UIImage(named:"reported post"), withOnlyOneAction: false)
            alert.modalPresentationStyle = .overCurrentContext
            alert.modalTransitionStyle = .crossDissolve
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    //MARK: report post
    func reportPost(post:Post) {
        let postID = post.postID ?? "ERROR"
        let posterID = post.posterUserID ?? "ERROR"
        let reporterID = Constants.FIREBASE_USERID!
        //update reported posts entry
        let reportPostRef = db.collection("reports").document(organizationData.currOrganization!).collection("reported_posts").document(postID)
        reportPostRef.getDocument() { (query, err) in
            if query != nil && query!.exists {
                let reporters = query?.get("reporters") as! [String]
                if !reporters.contains(reporterID) {
                    reportPostRef.updateData(["count":FieldValue.increment(1 as Int64), "reporters": FieldValue.arrayUnion([reporterID])])
                    self.reportUser(posterID:posterID)
                }
            }
            else {
                reportPostRef.setData(["count":1,"reporters":[reporterID]])
                self.reportUser(posterID:posterID)
            }
        }
    }
    //MARK: report user
    func reportUser(posterID:String) {
        let reporterID = Constants.FIREBASE_USERID!
        
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
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var chatId = "ERROR_THIS_SHOULD_BE_REPLACED"
        let post = feed.sortedPosts[indexPath.row]
        
        //haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        
        //if user is replying to their own post, display alertview
        if post.posterUserID == Constants.FIREBASE_USERID {
            
            //haptic feedback
            generator.notificationOccurred(.error)
            let alert = AlertView(headingText: "Woops, you can't reply to a post you wrote yoursef!", messageText: "", action1Label: "Okay", action1Color: Color.burple, action1Completion: {
                self.dismiss(animated: true, completion: nil);tableView.deselectRow(at: indexPath, animated: true)
            }, action2Label: "Delete Post", action2Color: Color.salmon, action2Completion: {
                self.dismiss(animated: false, completion: nil);self.confirmDeletePost(postID: post.postID!);tableView.deselectRow(at: indexPath, animated: false)
            }, withCancelBtn: false, image: UIImage(named:"warning"), withOnlyOneAction: false)
            alert.modalPresentationStyle = .overCurrentContext
            alert.modalTransitionStyle = .crossDissolve
            self.present(alert, animated: true, completion: nil)
        } else {
            let postID = post.postID!
            //existing chat, will be in active chats.
            if chatHandler.postToChat[postID] != nil {
                chatId = chatHandler.postToChat[postID]!
                print("post already mapped to existing chatid.")
                
            }else{ //new chat, generate new chat UUID
                chatId = UUID.init().uuidString
                chatHandler.postToChat[postID] = chatId
                print("mapped post to new chatId")
            }
            
            let chatVC = ChatsViewController(messageInputBarStyle: .facebook, chatID: chatId, post: post)
            self.navigationController?.isNavigationBarHidden = false
            self.navigationController?.pushViewController(chatVC, animated: true)
        }
        
        
        
    }

}

extension HomeViewController {
    
    @objc func methodOfHideBlur(notification: Notification) {
        hideBlur()
    }
    
    @objc func methodOfShowBlur(notification: Notification) {
        blurVw.isHidden = false
    }
    
    func hideBlur() {
        blurVw.isHidden = true
    }
    
//      MARK: Makes and adds the Pullup controller to the view
    
    private func makePullupViewControllerIfNeeded() -> BottomSlideController {
        
        UserDefaults.standard.set(false, forKey: "didmissPuppup")
        
        let currentPullUpController = children
            .filter({ $0 is BottomSlideController })
            .first as? BottomSlideController
        let pullUpController: BottomSlideController = currentPullUpController ?? BottomSlideController()
        
        // pullUpController.initialState = .expanded
        
        return pullUpController
    }
    
    private func addPullUpController(animated: Bool) {
        let pullUpController = makePullupViewControllerIfNeeded()
        _ = pullUpController.view // call pullUpController.viewDidLoad()
        addPullUpController(pullUpController,
                            initialStickyPointOffset: 500,
                            animated: true)
    }
    
//    MARK: Dismissing the Pull Up Controller
    
    private func makeDismissViewControllerIfNeeded() -> BottomSlideController {
        
        UserDefaults.standard.set(true, forKey: "didmissPuppup")
        
        let currentPullUpController = children
            .filter({ $0 is BottomSlideController })
            .first as? BottomSlideController
        let pullUpController: BottomSlideController = currentPullUpController ?? BottomSlideController()
        
        pullUpController.initialState = .contracted
        
        return pullUpController
    }
    
 
    private func addDismissPullUpController(animated: Bool) {
        let pullUpController = makeDismissViewControllerIfNeeded()
        _ = pullUpController.view // call pullUpController.viewDidLoad()
        addPullUpController(pullUpController,
                            initialStickyPointOffset: pullUpController.initialPointOffset,
                            animated: animated)
    }
    
}
