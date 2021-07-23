//
//  WelcomeToSilloViewController.swift
//  Sillo
//
//  Created by William Loo on 3/20/21.
//

import Firebase
import UIKit
import SafariServices
import MessageUI

@available(iOS 13.0, *)
class WelcomeToSilloViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,MFMailComposeViewControllerDelegate {
    
    // MARK: - IBDeclarations :
    var origin = "home" //either "home" or "teams"
    let scrollView = UIScrollView()
    let insideScrollVw = UIView()
    let titleLabel = UILabel()
    let inviteCodeButton = UIButton(type: UIButton.ButtonType.custom)
    let screenSize = UIScreen.main.bounds
    let TopTable = UITableView()
    
    //MARK: listener
    private var inviteListener: ListenerRegistration?
    
    deinit {
       inviteListener?.remove()
     }
    
    //MARK: init exit button
    let exitButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "closeButton"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var selectedIndx = -1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        //MARK: Allows swipe from left to go back (making it interactive caused issue with the header) but only if the view was from teams menu
        if self.origin == "teams" {
            let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(leftEdgeSwipe))
            edgePan.edges = .left
            view.addGestureRecognizer(edgePan)
        }
    }
    
    //MARK: function for left swipe gesture
    @objc func leftEdgeSwipe(_ recognizer: UIScreenEdgePanGestureRecognizer) {
       if recognizer.state == .recognized {
          self.navigationController?.popViewController(animated: true)
       }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshInvitesList(note:)), name: Notification.Name("InvitationsReady"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.inviteAccepted(note:)), name: Notification.Name("ColdOrgChangeComplete"), object: nil)
        
        self.view.backgroundColor = ViewBgColor
        self.navigationController?.navigationBar.isHidden = true
        tabBarController?.tabBar.isHidden = true
        settingElemets()
        
        localUser.invites = [] //must clear otherwise invites will appear more than once
        //MARK: attach listener
        let email = Constants.EMAIL ?? ""
        let reference = db.collection("invites").document(email).collection("user_invites").order(by: "timestamp", descending: true).limit(to: localUser.inviteBatchSize)
        inviteListener = reference.addSnapshotListener { querySnapshot, error in
          guard let snapshot = querySnapshot else {
            
            print("Error listening for channel updates: \(error?.localizedDescription ?? "No error")")
            return
          }
            //set most recent snapshot (like a bookmark)
            //feed.snapshot = snapshot
            
            //handle document changes
            snapshot.documentChanges.forEach { change in
                self.handleInviteChanges(change)
            }
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.isHidden = false
        navigationController?.navigationBar.isHidden = false
    }
    
    //MARK: handle document changes
    private func handleInviteChanges(_ change: DocumentChange) {
      switch change.type {
      case .added:
        localUser.handleNewInvite(id: change.document.documentID, data: change.document.data())
      case .removed:
        localUser.handleDeleteInvite(id: change.document.documentID, data: change.document.data())
      default:
        break
      }
    }
    
    //MARK: refresh called
    @objc func refreshInvitesList(note: NSNotification) {
        self.TopTable.reloadData()
    }
    
    //===================================*** SETTING CONSTRAINT ***=======================================//
    
    
    func settingElemets() {
        
        // FOR SCROLL :
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.isUserInteractionEnabled = true
        insideScrollVw.isUserInteractionEnabled = true
        scrollView.bounces = true
        scrollView.isScrollEnabled = false
        self.view.addSubview(scrollView)
        
        
        let scrollViewconstraints = [
            scrollView.topAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            scrollView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            scrollView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ]
        
        self.scrollView.addSubview(insideScrollVw)
        let screenWidth = screenSize.width
        
        
        // FOR TITLE :
        
        self.scrollView.addSubview(titleLabel)
        titleLabel.text = "Invites"
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = Color.burple
        titleLabel.font = UIFont(name: "Apercu-Bold", size: 24)
        titleLabel.textAlignment = .left
        titleLabel.textAlignment = .center
        
        let TITLEconstraints = [
            titleLabel.topAnchor.constraint(equalTo:  self.view.topAnchor, constant: 80),
            titleLabel.leftAnchor.constraint(equalTo: exitButton.leftAnchor, constant: 0),
            titleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 184/375),
            titleLabel.heightAnchor.constraint(equalToConstant: 25)
            
        ]
        
        // FOR INVITE CODE BUTTON :
        self.scrollView.addSubview(inviteCodeButton)
        inviteCodeButton.setTitle("Enter Code", for: .normal)
        inviteCodeButton.titleLabel?.font = UIFont(name: "Apercu-Bold", size: 15)
        inviteCodeButton.backgroundColor = Color.buttonClickableUnselected
        inviteCodeButton.addTarget(self, action:#selector(inviteCodeButtonPressed), for: .touchUpInside)
        inviteCodeButton.frame = CGRect(x: 0, y: 0, width: 80, height: 20)
        inviteCodeButton.cornerRadius = 12
        
        let inviteCodeButtonConstraints = [
            inviteCodeButton.topAnchor.constraint(equalTo:  self.view.topAnchor, constant: 80),
            inviteCodeButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -30),
            inviteCodeButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 100/375),
            inviteCodeButton.heightAnchor.constraint(equalToConstant: 25)
        ]
        
        // FOR EXIT BUTTON :
        self.view.addSubview(exitButton)
        exitButton.centerYAnchor.constraint(equalTo: titleLabel.centerYAnchor).isActive = true
        exitButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        exitButton.addTarget(self, action: #selector(exitPressed), for: .touchUpInside)
        
        
        // FOR secondTITLE :
        
        let sectitleLabel = UILabel()
        self.scrollView.addSubview(sectitleLabel)
        sectitleLabel.text = Constants.EMAIL ?? "your email"
        sectitleLabel.backgroundColor = .clear
        sectitleLabel.textColor = Color.darkerRussianDolphinGray
        sectitleLabel.font = UIFont(name: "Apercu-Regular", size: 18)
        sectitleLabel.textAlignment = .left
        sectitleLabel.numberOfLines = 0
        sectitleLabel.lineBreakMode = .byWordWrapping
        
        let sectitleLabelconstraints = [
            sectitleLabel.topAnchor.constraint(equalTo:  self.titleLabel.topAnchor, constant: 50),
            sectitleLabel.leftAnchor.constraint(equalTo: exitButton.leftAnchor, constant: 0),
            sectitleLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -25),
            sectitleLabel.heightAnchor.constraint(equalToConstant: 70)
        ]
        
        // FOR INSIDE SCROLL VIEW :
        
        let insideScrollViewconstraints = [
            insideScrollVw.topAnchor.constraint(equalTo:  sectitleLabel.bottomAnchor),
            insideScrollVw.widthAnchor.constraint(equalTo: sectitleLabel.widthAnchor),
            insideScrollVw.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            insideScrollVw.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 272/812)
        ]
        
        //MARK: or divider
        let divider: UIImageView = {
            let imageView = UIImageView()
            let image = UIImage(named: "or-divider")
            imageView.image = image
            return imageView
        }()
        self.scrollView.addSubview(divider)

        let dividerConstraints = [
            divider.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -150),
            divider.widthAnchor.constraint(equalToConstant: 305),
            divider.heightAnchor.constraint(equalToConstant: 22),
            divider.centerXAnchor.constraint(equalTo: self.scrollView.centerXAnchor)
        ]
        
        // FOR BOTTOM secondTITLE :
        
        let bottomSectitleLabel = UILabel()
        self.scrollView.addSubview(bottomSectitleLabel)
        bottomSectitleLabel.text = "Looking to create your own space?"
        bottomSectitleLabel.backgroundColor = .clear
        bottomSectitleLabel.textColor = Color.matte
        bottomSectitleLabel.font = UIFont(name: "Apercu-Regular", size: 18)
        bottomSectitleLabel.textAlignment = .center
        bottomSectitleLabel.numberOfLines = 0
        bottomSectitleLabel.lineBreakMode = .byWordWrapping
        
        let bottomSectitleLabelconstraints = [
            bottomSectitleLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -90),
            bottomSectitleLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            bottomSectitleLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 305/375),
            bottomSectitleLabel.heightAnchor.constraint(equalToConstant: 50)
            
        ]
        
        // FOR BOTTOM BUTTON :
        
        let BottomButton = UIButton()
        self.scrollView.addSubview(BottomButton)
        BottomButton.backgroundColor = Color.buttonClickable
        BottomButton.setTitle("Create a Sillo Space", for: .normal)
        BottomButton.titleLabel?.font = UIFont(name: "Apercu-Bold", size: 16)
        BottomButton.setTitleColor(.white, for: .normal)
        BottomButton.clipsToBounds = true
        BottomButton.cornerRadius = 7
        
        
        let BottomButtonconstraints = [
            BottomButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -35),
            BottomButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            BottomButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 305/375),
            BottomButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        BottomButton.addTarget(self, action:#selector(BottomButtonMethod), for: .touchUpInside)
        
        
        //------------------------------------ FOR TABLE VIEWS--------------------------------------------------//
        
        // FOR TOP TABLE  :
        
        TopTable.separatorStyle = .none
        TopTable.backgroundColor = .clear
        TopTable.bounces = true
        TopTable.register(CustomTableViewCell.self, forCellReuseIdentifier: "inviteCell")
        
        let TopTableconstraints = [
            TopTable.topAnchor.constraint(equalTo:  sectitleLabel.topAnchor, constant: 75),
            TopTable.leftAnchor.constraint(equalTo: exitButton.leftAnchor, constant: 0),
            TopTable.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -25),
            TopTable.heightAnchor.constraint(equalToConstant: 300)
        ]
        self.insideScrollVw.addSubview(TopTable)
        
        self.TopTable.delegate = self
        self.TopTable.dataSource = self
        
        
        
        //-----------for aqctivating constraints:
        
        NSLayoutConstraint.activate(scrollViewconstraints)
        NSLayoutConstraint.activate(insideScrollViewconstraints)
        NSLayoutConstraint.activate(TITLEconstraints)
        NSLayoutConstraint.activate(inviteCodeButtonConstraints)
        NSLayoutConstraint.activate(sectitleLabelconstraints)
        NSLayoutConstraint.activate(TopTableconstraints)
        NSLayoutConstraint.activate(dividerConstraints)
        NSLayoutConstraint.activate(bottomSectitleLabelconstraints)
        NSLayoutConstraint.activate(BottomButtonconstraints)
        
        
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.insideScrollVw.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.inviteCodeButton.translatesAutoresizingMaskIntoConstraints = false
        sectitleLabel.translatesAutoresizingMaskIntoConstraints = false
        TopTable.translatesAutoresizingMaskIntoConstraints = false
        divider.translatesAutoresizingMaskIntoConstraints = false
        bottomSectitleLabel.translatesAutoresizingMaskIntoConstraints = false
        BottomButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.layoutIfNeeded()
        
        
    }
    
    @objc func inviteCodeButtonPressed(sender:UIButton) {
        let nextVC = InviteCodeViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
    @objc func exitPressed() {
        if organizationData.organizationList.isEmpty {
            localUser.signOut()
            let nextVC = StartScreenViewController()
            nextVC.modalPresentationStyle = .fullScreen
            nextVC.modalTransitionStyle = .crossDissolve
            
            self.present(nextVC, animated: true, completion: nil)
        }
        else {
            //signed in user, now determine where the original screen was that led here
            if origin == "teams" {
                //from teams menu view, simple pop
                self.navigationController?.popViewController(animated: true)
                return
            }
            //otherwise, create a new navigation vc (the previous one was deleted)
            let nextVC:UITabBarController = prepareTabVC() as! UITabBarController
            nextVC.modalPresentationStyle = .fullScreen
            nextVC.modalTransitionStyle = .crossDissolve
                

                self.present(nextVC, animated: true)
        }
    }
    
    @objc func BottomButtonMethod() {
        //haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        
        //prevent too many orgs
        if organizationData.adminStatusMap.keys.count >= Constants.MAX_ORG_COUNT {
            generator.notificationOccurred(.error)
            DispatchQueue.main.async {
                let alert = AlertView(headingText: "Cannot Create Space!", messageText: "You have already joined the maximum of 10 spaces.", action1Label: "Okay", action1Color: Color.burple, action1Completion: {
                    self.dismiss(animated: true, completion: nil)
                }, action2Label: "Nil", action2Color: .gray, action2Completion: {
                }, withCancelBtn: false, image: nil, withOnlyOneAction: true)
                alert.modalPresentationStyle = .overCurrentContext
                alert.modalTransitionStyle = .crossDissolve
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        
        let nextVC = SetupOrganizationViewController()
        nextVC.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //=============================*** DELEGATE DATASOURCE METHODS ***===============================//
    
    //MARK :  Table View Delegate Methods:
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        TopTable.backgroundView = nil
        if localUser.invites.count > 0 {
            return localUser.invites.count
        }
        else {
            //MARK: set up fallback if table is empty
            let noOrganizationUIImageView : UIImageView = {
                let view = UIImageView()
                view.frame = CGRect(x: 0, y: 0, width: TopTable.bounds.width, height: TopTable.frame.height)
                view.contentMode = .scaleAspectFit
                let image = UIImage(named:"no-associated-spaces")
                view.image = image
                return view
            }()
            TopTable.backgroundView = noOrganizationUIImageView
            return 0
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row + 2 == localUser.invites.count {
            //we're almost at the end, pull more invites
            localUser.getNextInvites()
        }
        let cell =  tableView.dequeueReusableCell(withIdentifier: "inviteCell", for: indexPath) as! CustomTableViewCell
        cell.selectionStyle = .none
        
        
        cell.bgView.backgroundColor = hexStringToUIColor(hex: "#F2F4F4")
        cell.labUserName.isHidden = true
        cell.imgUser2.isHidden = true
        
        cell.imgUser.borderWidth = 3.5
        cell.imgUser.borderColor = .gray
        
        let orgID : String = localUser.invites[indexPath.row]
        cell.labMessage.text = organizationData.idToName["invite-"+orgID] ?? "ERROR"
        cell.labMessage.textColor = .black
        cell.labMessage.font = UIFont(name: "Apercu-Bold", size: 17)
        
        cell.img1constraints = [
            cell.imgUser.centerYAnchor.constraint(equalTo:  cell.contentView.centerYAnchor, constant: 0),
            cell.imgUser.leftAnchor.constraint(equalTo:  cell.contentView.leftAnchor, constant: 30),
            cell.imgUser.widthAnchor.constraint(equalToConstant: 60),
            cell.imgUser.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        cell.Messageconstraints = [
            cell.labMessage.centerYAnchor.constraint(equalTo:  cell.contentView.centerYAnchor, constant: 0),
            cell.labMessage.leftAnchor.constraint(equalTo:  cell.imgUser2.leftAnchor, constant: 10),
            cell.labMessage.rightAnchor.constraint(equalTo:  cell.contentView.rightAnchor, constant: 20),
            cell.labMessage.heightAnchor.constraint(equalToConstant: 20)
        ]
        cell.imgUser.clipsToBounds = true
        cell.imgUser.cornerRadius = 20
        
        
        NSLayoutConstraint.activate(cell.Messageconstraints)
        NSLayoutConstraint.activate(cell.img1constraints)
        
        cell.contentView.layoutIfNeeded()
        
        
        if selectedIndx == indexPath.row
        {
            cell.bgView.backgroundColor = UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
            cell.bgView.addTopShadow(shadowColor: UIColor.lightGray, shadowOpacity: 0.5, shadowRadius: 5, offset: CGSize(width: 3.0, height : 3.0))
        }
        else
        {
            cell.bgView.backgroundColor = hexStringToUIColor(hex: "#F2F4F4")
            cell.bgView.addTopShadow(shadowColor: .clear, shadowOpacity: 0, shadowRadius: 0, offset: CGSize(width: 0.0, height : 0.0))
        }
        return cell
        
        
    }
    
    //debouncing mechanism
    let DEBOUNCE_LIMIT = 0.9
    var latestButtonPressTimestamp = Date()
    
    //MARK: selected the cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //prevents duplicated taps
        let requestThrottled: Bool = -self.latestButtonPressTimestamp.timeIntervalSinceNow < self.DEBOUNCE_LIMIT
        if requestThrottled {
            return
        }
        latestButtonPressTimestamp = Date()
        
        //haptic feedback
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        
        //prevent too many orgs
        if organizationData.adminStatusMap.keys.count >= Constants.MAX_ORG_COUNT {
            generator.notificationOccurred(.error)
            DispatchQueue.main.async {
                let alert = AlertView(headingText: "Max Spaces Reached!", messageText: "You have already joined the maximum of 10 spaces.", action1Label: "Okay", action1Color: Color.burple, action1Completion: {
                    self.dismiss(animated: true, completion: nil)
                }, action2Label: "Nil", action2Color: .gray, action2Completion: {
                }, withCancelBtn: false, image: nil, withOnlyOneAction: true)
                alert.modalPresentationStyle = .overCurrentContext
                alert.modalTransitionStyle = .crossDissolve
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        
        selectedIndx = indexPath.row
        self.TopTable.reloadData()
        let orgID : String = localUser.invites[selectedIndx]
        // do not allow joining an organization you're already a part of
        // switch organizations for the user, and take them to home screen.
        if organizationData.idToName.keys.contains(orgID) {
            generator.notificationOccurred(.error)
            DispatchQueue.main.async {
                let alert = AlertView(headingText: "Organization Already Joined!", messageText: "You have already joined this organization.", action1Label: "Okay", action1Color: Color.burple, action1Completion: {
                    self.dismiss(animated: true, completion: nil);organizationData.changeOrganization(dest: orgID);
                    do {let nextVC = prepareTabVC()
                        nextVC.modalPresentationStyle = .fullScreen
                        
                        let navC = UINavigationController(rootViewController: nextVC)
                        navC.modalPresentationStyle = .fullScreen
                        navC.modalTransitionStyle = .crossDissolve
                        navC.setNavigationBarHidden(true, animated: false)
                        self.present(navC, animated: true, completion: nil)
                        
                    }
                }, action2Label: "Nil", action2Color: .gray, action2Completion: {
                }, withCancelBtn: false, image: nil, withOnlyOneAction: true)
                alert.modalPresentationStyle = .overCurrentContext
                alert.modalTransitionStyle = .crossDissolve
                self.present(alert, animated: true, completion: nil)
            }
            DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
                //delete invite on firebase
                db.collection("invites").document(Constants.EMAIL!).collection("user_invites").document(orgID).delete() {err in
                    if err != nil {
                        print("could not accept invite, invite document not deleted")
                    }
                    else {
                        print("delete invite successful")
                    }
                }
            }
            return
        }
        //MARK: accept invite
        //move temporary dictionary mapping to a more permanent one
        //this temporary invite will be deleted in acceptInvite
        let temporary = organizationData.idToName["invite-"+orgID]
        organizationData.idToName[orgID] = temporary
        
        localUser.acceptInvite(organizationID: orgID)
        
        generator.notificationOccurred(.success)
    }
    
    //debouncing mechanism 2
    var latestCallbackTimestamp = Date()
    
    @objc func inviteAccepted(note:NSNotification) {
        
        //prevents duplicated callbacks
        let requestThrottled: Bool = -self.latestCallbackTimestamp.timeIntervalSinceNow < self.DEBOUNCE_LIMIT
        if requestThrottled {
            return
        }
        latestCallbackTimestamp = Date()
        
        let nextVC = ProfilePromptViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

}
