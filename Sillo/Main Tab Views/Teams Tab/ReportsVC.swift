//
//  ReportsVC.swift
//  Sillo
//
//  Created by William Loo on 5/23/21.
//

import UIKit
import Firebase

@available(iOS 13.0, *)
class ReportsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK :IBDeclarations:
    var cameFrom = ""
    
    let screenSize = UIScreen.main.bounds
    
    var InfoStr = ["Information bubble text","here once the icon is","clicked."]
    
    let titleLabel = UILabel()
    let titleLabel2 = UILabel()
    let titleLabel3 = UILabel()
    // let scrollView = UIScrollView(frame: UIScreen.main.bounds)
    
    let scrollView = UIScrollView()
    let insideScrollVw = UIView()
    
    
    let DescLabel = UILabel()
    let DescLabel2 = UILabel()
    
    let Line1 = UILabel()
    
    let TopTable = UITableView()
    let MidTable = UITableView()
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.standardAppearance = self.appearance
        
        //MARK: Allows swipe from left to go back (making it interactive caused issue with the header)
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(leftEdgeSwipe))
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
        
        self.TopTable.flashScrollIndicators()
        self.MidTable.flashScrollIndicators()
    }
    
    //MARK: function for left swipe gesture
    @objc func leftEdgeSwipe(_ recognizer: UIScreenEdgePanGestureRecognizer) {
       if recognizer.state == .recognized {
          self.navigationController?.popViewController(animated: true)
       }
    }
    
    @objc func Addinfo(){
        NotificationCenter.default.post(name: Notification.Name("dismissAction"), object: nil)
    }
    
    
    let appearance : UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Color.burple,
                NSAttributedString.Key.font: UIFont(name: "Apercu-Bold", size: 20)!]
        
        appearance.backgroundColor = Color.headerBackground
        return appearance
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        settingElemets()
        setNavBar()
        //attach notification listeners
        NotificationCenter.default.addObserver(self, selector: #selector(self.didFinishLoadingReportedMembers(note:)), name: Notification.Name("finishLoadingReportedMembers"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didFinishLoadingReportedPosts(note:)), name: Notification.Name("finishLoadingReportedPosts"), object: nil)
        
        reportedMembers = []
        reportedPosts = []
        
        self.getReports()
    }
    
    //struct for user reports
    struct UserReport{
        var id:String
        var name:String
        var count:Int
    }
    
    //struct for post reports
    struct PostReport{
        var id:String
        var text:String
        var count:Int
        var date:Date
    }
    
    var reportedMembers:[UserReport] = [] //sorted in order of severity
    var reportedPosts: [PostReport] = [] //sorted in order of severity
    
    func getReports() {
        
        //grab reported users first
        db.collection("reports").document(organizationData.currOrganization!).collection("reported_users").order(by: "count").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let count = document.get("count") as! Int
                    let userID = document.documentID
                    
                    //pull user data and name, and then refresh table
                    db.collection("users").document(userID).getDocument() { (query, err) in
                        if let query = query {
                            if query.exists {
                                let username = query.get("username") as! String
                                let report = UserReport(id: userID, name: username, count: count)
                                self.reportedMembers.append(report)
                                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "finishLoadingReportedMembers"), object: nil)
                            }
                        }
                    }
                }
            }
        }
        
        //grab reported posts second
        db.collection("reports").document(organizationData.currOrganization!).collection("reported_posts").order(by: "count").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    let count = document.get("count") as! Int
                    let postID = document.documentID
                    
                    if feed.posts.keys.contains(postID) {
                        let post = feed.posts[postID]
                        let text = post?.message
                        let postingDate = post?.date
                        let report = PostReport(id: postID, text: text!, count: count, date: postingDate!)
                        self.reportedPosts.append(report)
                        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "finishLoadingReportedPosts"), object: nil)
                    }
                    else {
                        //post dun exist, download
                        db.collection("organization_posts").document(organizationData.currOrganization!).collection("posts").document(postID).getDocument() { (query, err) in
                            if let query = query {
                                if query.exists {
                                    //pass to internal struct for future reads
                                    let data = query.data()!
                                    feed.handleNewPost(id: postID, data: data)
                                    
                                    //create report struct
                                    let postText = query.get("message") as! String
                                    let timestamp = query.get("timestamp") as! Timestamp
                                    let date = Date(timeIntervalSince1970: TimeInterval(timestamp.seconds))
                                    let report = PostReport(id: postID, text: postText, count: count, date: date)
                                    self.reportedPosts.append(report)
                                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "finishLoadingReportedPosts"), object: nil)
                                }
                            }
                        }
                        
                        
                    }
                    
                }
            }
        }
    }
    
    @objc func didFinishLoadingReportedMembers(note:NSNotification) {
        reportedMembers.sort {$0.count > $1.count}
        TopTable.reloadData()
    }
    
    //sort by count first, and then most recent on top
    @objc func didFinishLoadingReportedPosts(note:NSNotification) {
        reportedPosts.sort {
            if $0.count != $1.count {
                return $0.count > $1.count
            }
            else {
                return $0.date > $1.date
            }
        }
        MidTable.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    func setNavBar()
    {
        self.title = "Reports"
        self.view.backgroundColor = ViewBgColor
        tabBarController?.tabBar.isHidden = true
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = ViewBgColor
        navigationController?.navigationBar.isTranslucent = false
        
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action:#selector(callMethod), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItems = [barButton]
        
    }
    @objc func callMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //===================================*** SETTING CONSTRAINT ***=======================================//
    
    
    func settingElemets()
    {
        
        // FOR SCROLL :
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.isUserInteractionEnabled = true
        insideScrollVw.isUserInteractionEnabled = true
        TopTable.isUserInteractionEnabled = true
        MidTable.isUserInteractionEnabled = true
        scrollView.bounces = true
        TopTable.bounces = true
        TopTable.showsVerticalScrollIndicator = true
        MidTable.bounces = true
        MidTable.showsVerticalScrollIndicator = true
        
        self.view.addSubview(scrollView)
        
        
        let scrollViewconstraints = [
            scrollView.topAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            scrollView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            scrollView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
        ]
        
        self.scrollView.addSubview(insideScrollVw)
        
        let screenWidth = screenSize.width
        
        
        let insideScrollViewconstraints = [
            insideScrollVw.topAnchor.constraint(equalTo:  self.scrollView.contentLayoutGuide.topAnchor, constant: 0),
            insideScrollVw.leftAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.leftAnchor, constant: 0),
            insideScrollVw.rightAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.rightAnchor, constant: 0),
            insideScrollVw.bottomAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.bottomAnchor, constant: 0),
            
            insideScrollVw.heightAnchor.constraint(equalToConstant: 1000),
            insideScrollVw.widthAnchor.constraint(equalToConstant: screenWidth)
            
        ]
        
        
        // FOR TITLE :
        
        self.insideScrollVw.addSubview(titleLabel)
        titleLabel.text = "Reported members"
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "Apercu-Bold", size: 22)
        titleLabel.textAlignment = .left
        
        let TITLEconstraints = [
            titleLabel.topAnchor.constraint(equalTo:  self.insideScrollVw.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 30),
            titleLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 25),
            titleLabel.heightAnchor.constraint(equalToConstant: 25)
            
        ]
        
        //for desclabel1
        self.insideScrollVw.addSubview(DescLabel)
        DescLabel.text = "We noticed these members may have had inappropriate conversations. Please ensure the safety of your members, please keep these members accountable."
        DescLabel.backgroundColor = .clear
        DescLabel.textColor = .black
        DescLabel.font = UIFont(name: "Apercu", size: 17)
        DescLabel.textAlignment = .left
        DescLabel.numberOfLines = 0
        
        let Desc1Constraints = [
            DescLabel.topAnchor.constraint(equalTo:  titleLabel.topAnchor, constant: 30),
            DescLabel.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor, constant: 0),
            DescLabel.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor, constant: -25),
            DescLabel.heightAnchor.constraint(equalToConstant: 100),
            DescLabel.widthAnchor.constraint(equalTo: self.insideScrollVw.widthAnchor, multiplier: 0.9)
        ]
        
        
        // FOR LINE  :
        
        Line1.backgroundColor = themeBgColor
        self.insideScrollVw.addSubview(Line1)
        
        let line1constraints = [
            Line1.topAnchor.constraint(equalTo:  TopTable.topAnchor, constant: 320),
            Line1.leftAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            Line1.rightAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            Line1.heightAnchor.constraint(equalToConstant: 2),
        ]
        
        // FOR  TITLE2:
        
        self.insideScrollVw.addSubview(titleLabel2)
        titleLabel2.text = "Posts for review"
        titleLabel2.backgroundColor = .clear
        titleLabel2.textColor = .black
        titleLabel2.font = UIFont(name: "Apercu-Bold", size: 22)
        titleLabel2.textAlignment = .left
        
        let TITLE2constraints = [
            titleLabel2.topAnchor.constraint(equalTo:  self.Line1.topAnchor, constant: 20),
            titleLabel2.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor, constant: 0),
            titleLabel2.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor, constant: 0),
            titleLabel2.heightAnchor.constraint(equalToConstant: 25)
        ]
        
        // FOR  desclBL:
        
        self.insideScrollVw.addSubview(DescLabel2)
        DescLabel2.text = "The following posts have been flagged by members of your team. To ensure their safety, please manage these posts."
        DescLabel2.backgroundColor = .clear
        DescLabel2.textColor = .black
        DescLabel2.font = UIFont(name: "Apercu", size: 17)
        DescLabel2.textAlignment = .left
        DescLabel2.numberOfLines = 0
        
        let Desc2Constraints = [
            DescLabel2.topAnchor.constraint(equalTo:  self.titleLabel2.topAnchor, constant: 30),
            DescLabel2.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor, constant: 0),
            DescLabel2.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor, constant: -25),
            DescLabel2.heightAnchor.constraint(equalToConstant: 100),
            DescLabel2.widthAnchor.constraint(equalTo: self.insideScrollVw.widthAnchor, multiplier: 0.9)
        ]
        
        
        //------------------------------------ FOR TABLE VIEWS--------------------------------------------------//
        
        // FOR TOP TABLE  :
        
        TopTable.separatorStyle = .none
        TopTable.backgroundColor = .clear
        TopTable.register(ReportCell.self, forCellReuseIdentifier: "reportCell")
        
        let TopTableconstraints = [
            TopTable.topAnchor.constraint(equalTo:  DescLabel.topAnchor, constant: 100),
            TopTable.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0),
            TopTable.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -25),
            TopTable.heightAnchor.constraint(equalToConstant: 300),
            TopTable.widthAnchor.constraint(equalTo: self.insideScrollVw.widthAnchor, multiplier: 0.9)
        ]
        self.insideScrollVw.addSubview(TopTable)
        
        self.TopTable.delegate = self
        self.TopTable.dataSource = self
        
        // FOR Middle TABLE  :
        
        MidTable.separatorStyle = .none
        MidTable.backgroundColor = .clear
        MidTable.register(ReportCell.self, forCellReuseIdentifier: "reportCell")
        
        let MidTableconstraints = [
            MidTable.topAnchor.constraint(equalTo:  DescLabel2.topAnchor, constant: 100),  MidTable.leftAnchor.constraint(equalTo: DescLabel2.leftAnchor, constant: 0),
            MidTable.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -25),
            MidTable.heightAnchor.constraint(equalToConstant: 300),
            MidTable.widthAnchor.constraint(equalTo: self.insideScrollVw.widthAnchor, multiplier: 0.9)
        ]
        self.insideScrollVw.addSubview(MidTable)
        
        self.MidTable.delegate = self
        self.MidTable.dataSource = self

        // LAYOUT VIEW:
        
        NSLayoutConstraint.activate(scrollViewconstraints)
        NSLayoutConstraint.activate(insideScrollViewconstraints)
        
        
        NSLayoutConstraint.activate(TITLEconstraints)
        NSLayoutConstraint.activate(TopTableconstraints)
        NSLayoutConstraint.activate(line1constraints)
        NSLayoutConstraint.activate(TITLE2constraints)
        NSLayoutConstraint.activate(Desc1Constraints)
        NSLayoutConstraint.activate(Desc2Constraints)
        NSLayoutConstraint.activate(MidTableconstraints)
        
        self.view.layoutIfNeeded()
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        TopTable.translatesAutoresizingMaskIntoConstraints = false
        Line1.translatesAutoresizingMaskIntoConstraints = false
        titleLabel2.translatesAutoresizingMaskIntoConstraints = false
        DescLabel.translatesAutoresizingMaskIntoConstraints = false
        DescLabel2.translatesAutoresizingMaskIntoConstraints = false
        MidTable.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        insideScrollVw.translatesAutoresizingMaskIntoConstraints = false
        titleLabel3.translatesAutoresizingMaskIntoConstraints = false
        
        
        
    }

    //=============================*** DELEGATE DATASOURCE METHODS ***===============================//
    
    //MARK :   Table View Delegate Methods:
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            return 100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == self.TopTable {
            return self.reportedMembers.count
        }
        else {
            return self.reportedPosts.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "reportCell", for: indexPath) as! ReportCell
        cell.selectionStyle = .none
        
        cell.labUserName.isHidden = false
        cell.imgUser2.isHidden = false
        
        
        if tableView == self.TopTable {
            let userReport = self.reportedMembers[indexPath.row]
            cell.labUserName.text = userReport.name
            if userReport.count > 1 {
                cell.labMessage.text = "\(userReport.count) flags"
            }
            else {
                cell.labMessage.text = "\(userReport.count) flag"
            }
        }
        else {
            let postReport = self.reportedPosts[indexPath.row]
            cell.labUserName.text = postReport.text
            if postReport.count > 1 {
                cell.labMessage.text = "\(postReport.count) flags"
            }
            else {
                cell.labMessage.text = "\(postReport.count) flag"
            }
        }
        
        
        return cell
        
    }

    func dismissPostReport(reportID: String) {
        db.collection("reports").document(organizationData.currOrganization!).collection("reported_posts").document(reportID).delete() { err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Report successfully removed!")
                if let removeIndex = self.reportedPosts.firstIndex(where: {$0.id == reportID}) {
                    self.reportedPosts.remove(at: removeIndex)
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "finishLoadingReportedPosts"), object: nil)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if tableView == self.TopTable {
            let nextVC = ManageUserViewController()
            let reportedUser = self.reportedMembers[indexPath.row]
            let userID = reportedUser.id
            let imageRef = "profiles/\(userID)\(Constants.image_extension)"
            if imageCache.object(forKey: imageRef as! NSString) == nil {
                cloudutil.downloadImage(ref: imageRef, useCache: true)
            }
            else {
                nextVC.profilePic = imageCache.object(forKey: imageRef as NSString)?.image ?? UIImage(named:"avatar-4")!
            }
            nextVC.username = "username goes here"
            nextVC.email = "no email provided."
        
            nextVC.userID = userID
            
            db.collection("users").document(userID).getDocument() { (query, err) in
            if let query = query {
                if query.exists {
                    nextVC.username = query.get("username") as! String
                    if (query.get("email") != nil) {
                        nextVC.email = query.get("email") as! String
                    }
                    self.navigationController?.pushViewController(nextVC, animated: true)
                }
                else {
                    //document does not exist
                    DispatchQueue.main.async {
                        let alert = AlertView(headingText: "User does not exist!", messageText: "This user may have ben removed from your organization.", action1Label: "Okay", action1Color: Color.burple, action1Completion: {
                            self.dismiss(animated: true, completion: nil)
                        }, action2Label: "Nil", action2Color: .gray, action2Completion: {
                        }, withCancelBtn: false, image: nil, withOnlyOneAction: true)
                        alert.modalPresentationStyle = .overCurrentContext
                        alert.modalTransitionStyle = .crossDissolve
                        self.present(alert, animated: true, completion: nil)
                    }
                    return
                }
            }
        }
        }
        else {
            // Create Date Formatter
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateStyle = .long
            dateFormatter.timeStyle = .short
            
            let postReport = self.reportedPosts[indexPath.row]
            let postID = postReport.id
            let postText = postReport.text
            let postDate = postReport.date
            let formattedDate = dateFormatter.string(from: postDate)
            
            DispatchQueue.main.async {
                let alert = AlertView(headingText: "posted on: \(formattedDate)", messageText: postText, action1Label: "Okay", action1Color: Color.burple, action1Completion: {
                    self.dismiss(animated: true, completion: nil)
                }, action2Label: "Delete", action2Color: Color.salmon, action2Completion: {self.dismiss(animated: false, completion: nil);feed.deletePost(postID: postID);self.dismissPostReport(reportID: postID)
                }, withCancelBtn: false, image: nil, withOnlyOneAction: false)
                alert.modalPresentationStyle = .overCurrentContext
                alert.modalTransitionStyle = .crossDissolve
                self.present(alert, animated: true, completion: nil)
            }
        }
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
}
class ReportCell: UITableViewCell {
    
    let bgView = UIView()
    let imgUser = UIImageView()
    let imgUser2 = UIImageView()
    let checkImg = UIImageView()
    
    let labUserName = UILabel()
    let labMessage = UILabel()
    
    var TITLEconstraints = [NSLayoutConstraint]()
    var Messageconstraints = [NSLayoutConstraint]()
    var img1constraints = [NSLayoutConstraint]()
    var img2constraints = [NSLayoutConstraint]()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        // FOR bg :
        
        contentView.addSubview(bgView)
        
        let bgOconstraints = [
            bgView.topAnchor.constraint(equalTo:  contentView.topAnchor, constant: 8),
            bgView.leftAnchor.constraint(equalTo:  contentView.leftAnchor, constant: 5),
            bgView.rightAnchor.constraint(equalTo:  contentView.rightAnchor, constant: -5),
            bgView.bottomAnchor.constraint(equalTo:  contentView.bottomAnchor, constant: -8),
            
        ]
        
        bgView.backgroundColor = hexStringToUIColor(hex: "#F2F4F4")
        bgView.layer.cornerRadius = 10
        bgView.clipsToBounds = true
         
        // for images :
        
        contentView.addSubview(imgUser)
        imgUser.image = UIImage.init(named: "anon-4")
        
        img1constraints = [
            imgUser.centerYAnchor.constraint(equalTo:  contentView.centerYAnchor, constant: 0),
            imgUser.leftAnchor.constraint(equalTo:  contentView.leftAnchor, constant: 15),
            imgUser.widthAnchor.constraint(equalToConstant: 40),
            imgUser.heightAnchor.constraint(equalToConstant: 40)
        ]
        imgUser.layer.cornerRadius = 20
        imgUser.clipsToBounds = true
        
        contentView.addSubview(imgUser2)
        imgUser2.image = UIImage.init(named: "anon-4")
        
        img2constraints = [
            imgUser2.centerYAnchor.constraint(equalTo:  contentView.centerYAnchor, constant: 0),
            imgUser2.leftAnchor.constraint(equalTo:  contentView.leftAnchor, constant: 65),
            imgUser2.widthAnchor.constraint(equalToConstant: 40),
            imgUser2.heightAnchor.constraint(equalToConstant: 40)
        ]
        imgUser2.layer.cornerRadius = 20
        imgUser2.clipsToBounds = true
        
        // for checkmark :
        
        contentView.addSubview(checkImg)
        checkImg.image = UIImage.init(named: "check")
        
        let checkImgconstraints = [
            checkImg.centerYAnchor.constraint(equalTo:  contentView.centerYAnchor, constant: 0),
            checkImg.rightAnchor.constraint(equalTo:  contentView.rightAnchor, constant: -20),
            checkImg.widthAnchor.constraint(equalToConstant: 25),
            checkImg.heightAnchor.constraint(equalToConstant: 25)
        ]
        checkImg.isHidden = true
        
        
        
        
        // FOR LABELS :
        
        contentView.addSubview(labUserName)
        labUserName.text = "Full Name"
        labUserName.backgroundColor = .clear
        labUserName.textColor = .black
        labUserName.font = UIFont(name: "Apercu-Bold", size: 17)
        labUserName.textAlignment = .left
        
        TITLEconstraints = [
            labUserName.centerYAnchor.constraint(equalTo:  contentView.centerYAnchor, constant: -10),
            labUserName.leftAnchor.constraint(equalTo:  contentView.leftAnchor, constant: 70),
            labUserName.rightAnchor.constraint(equalTo:  contentView.rightAnchor, constant: 20),
            labUserName.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        contentView.addSubview(labMessage)
        labMessage.text = "Level 5"
        labMessage.backgroundColor = .clear
        labMessage.textColor = .black
        labMessage.font = UIFont(name: "Apercu-Regular", size: 12)
        labMessage.textAlignment = .left
        
        Messageconstraints = [
            labMessage.centerYAnchor.constraint(equalTo:  contentView.centerYAnchor, constant: 13),
            labMessage.leftAnchor.constraint(equalTo:  contentView.leftAnchor, constant: 70),
            labMessage.rightAnchor.constraint(equalTo:  contentView.rightAnchor, constant: 20),
            labMessage.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        
        
        // LAYOUT VIEW:
        
        NSLayoutConstraint.activate(bgOconstraints)
        NSLayoutConstraint.activate(img1constraints)
        NSLayoutConstraint.activate(img2constraints)
        NSLayoutConstraint.activate(TITLEconstraints)
        NSLayoutConstraint.activate(Messageconstraints)
        NSLayoutConstraint.activate(checkImgconstraints)
        
        bgView.translatesAutoresizingMaskIntoConstraints = false
        imgUser.translatesAutoresizingMaskIntoConstraints = false
        imgUser2.translatesAutoresizingMaskIntoConstraints = false
        labUserName.translatesAutoresizingMaskIntoConstraints = false
        labMessage.translatesAutoresizingMaskIntoConstraints = false
        checkImg.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.layoutIfNeeded()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}

