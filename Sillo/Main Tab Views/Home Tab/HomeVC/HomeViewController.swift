//
//  HomeViewController.swift
//  Sillo
//
//  Created by Eashan Mathur on 1/28/21.
//

import UIKit
import Firebase


class HomeViewController: UIViewController {
    
    let cellID = "cellID"
    let postsTable : UITableView = {
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
        
    let blurVw = UIView()
    
    //MARK: listener
    private var postListener: ListenerRegistration?
    
    deinit {
       postListener?.remove()
     }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfHideBlur(notification:)), name: Notification.Name("HideBlurNotificationIdentifier"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfShowBlur(notification:)), name: Notification.Name("ShowBlurNotificationIdentifier"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshTableView(note:)), name: Notification.Name("refreshPostTableView"), object: nil)
        
        //MARK: attach listener
        let organizationID = organizationData.currOrganization ?? "ERROR"
        let reference = db.collection("organization_posts").document(organizationID).collection("posts")
        postListener = reference.addSnapshotListener { querySnapshot, error in
          guard let snapshot = querySnapshot else {
            print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
            return
          }
          snapshot.documentChanges.forEach { change in
            self.handlePostDocumentChange(change)
            }
        }
        

        navigationController?.isNavigationBarHidden = true
        feed.coldStart()
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        overrideUserInterfaceStyle = .light
        setupHeader()
        setupTableView()
        navigationController?.navigationBar.barTintColor = Color.headerBackground
        navigationController?.navigationBar.isTranslucent = false
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    
    func setupHeader() {
        view.addSubview(header)
        
        // MARK: Blur View Constraints
        
        view.addSubview(blurVw)
        blurVw.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
        
        let blurVwconstraints = [
            blurVw.topAnchor.constraint(equalTo: self.view.topAnchor),
            blurVw.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            blurVw.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            blurVw.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor)
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
        let teamPic = UIImageView()
        teamPic.image = UIImage(named: "avatar-2")
        teamPic.translatesAutoresizingMaskIntoConstraints = false
        teamPic.contentMode = .center
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
    
    @objc func blurTapped() {
        print("tapped")
        NotificationCenter.default.post(name: Notification.Name("DismissNotificationIdentifier"), object: nil)
    }
    
    @objc func profilePicTapped() {
        
        blurVw.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(blurTapped))
        blurVw.addGestureRecognizer(tap)
        addPullUpController(animated: true)
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
        
        let clubName = UILabel()
        clubName.text = organizationData.currOrganizationName ?? "My Organization"
        clubName.font = Font.bold(22)
        clubName.textColor = Color.teamHeader
        stack.addArrangedSubview(clubName)
        
        return stack
    }
    
    func setupTableView() {
        postsTable.delegate = self
        postsTable.dataSource = self
        self.view.addSubview(postsTable)
        view.sendSubviewToBack(postsTable)
        postsTable.rowHeight = UITableView.automaticDimension
        postsTable.estimatedRowHeight = 100
        postsTable.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        postsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        postsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        postsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        postsTable.register(HomePostTableViewCell.self, forCellReuseIdentifier: cellID)
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

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        tableView.backgroundView = nil
        let posts_count = feed.posts.count
        if posts_count > 0 {
            return posts_count
        }
        else {
            //MARK: set up fallback if table is empty
            let noPostsUIView : UIImageView = {
                let view = UIImageView()
                let scaling:CGFloat = 0.2
                view.frame = CGRect(x: 0, y: 0, width: scaling*(tableView.bounds.width), height: scaling*(tableView.frame.height))
                view.contentMode = .scaleAspectFit
                let image = UIImage(named:"no-posts")
                view.image = image
                return view
            }()
            tableView.backgroundView = noPostsUIView
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! HomePostTableViewCell
        
        cell.item = feed.sortedPosts[indexPath.row]
        cell.separatorInset = UIEdgeInsets.zero
        return cell
    }
  
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let interChatVC = InterChatVC()
        self.navigationController?.pushViewController(interChatVC, animated: true)
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
                            initialStickyPointOffset: pullUpController.initialPointOffset,
                            animated: animated)
    }
    
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
