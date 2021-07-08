//
//  QuestProgressVC.swift
//
//
//  Created by Angelica Pan on 3/21/21.
//

import UIKit
import Firebase

class QuestProgressVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    //MARK :IBDeclarations:
    
    let header : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.navBar
        return view
    }()
    
    //MARK: quest title
    let questTitle: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1;
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont(name:"Apercu-Bold", size: 17)
        label.text = "Quest Progress"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    //MARK: init description
    let descLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0;
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont(name:"Apercu-Bold", size: 15)
        label.text = "Complete your quest to claim a Sillo sticker!"
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    let progressBar = UIProgressView(progressViewStyle: .bar)
    var timer = Timer()
    
    let scrollView : UIScrollView = {
        let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let insideScrollVw : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let subtaskTableView = UITableView()
    
    let lockImage = UIImageView()
    let popupLbl = UILabel()
    
    let screenSize = UIScreen.main.bounds
    
    var StarsView = UIView()
    
    var bubbleImageView = UIImageView(image: #imageLiteral(resourceName: "bgStar"))
    
    //MARK: listener
    private var questListener: ListenerRegistration?
    
    deinit {
        questListener?.remove()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        quests.fetchNextSticker()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshTableView(note:)), name: Notification.Name("refreshQuestTableView"), object: nil)
        
        //MARK: attach listener
        let myUserID = Constants.FIREBASE_USERID ?? "ERROR"
        let reference = db.collection("quests").document(myUserID)
        questListener = reference.addSnapshotListener { documentSnapshot, error in
            guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
            }
            guard let data = document.data() else {
                print("Document data was empty.")
                quests.resetQuestPopup()
                return
            }
            
            print("Current data: \(data)")
            for (i, task) in ["subtask1", "subtask2", "subtask3"].enumerated() {
                let taskType = document.get(task) as! String
                let progress = document.get("\(task)_progress") as! [String:Int]
                let current = progress["current"]!
                let target = progress["target"]!
                quests.subtasks[i] = Quests.Subtask(title: quests.subtaskTitles[taskType] as! String, type: taskType , current: current, target: target)
                
            }
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshQuestTableView"), object: nil)
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: set up header
        self.navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white
        overrideUserInterfaceStyle = .light
        
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
        
        navigationController?.navigationBar.barTintColor = Color.headerBackground
        navigationController?.navigationBar.isTranslucent = false
        setupHeader()
        
        //MARK: scrollview
        self.view.addSubview(scrollView)
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.backgroundColor = .white
        scrollView.isUserInteractionEnabled = true
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.bounces = true
        let scrollViewconstraints = [
            scrollView.topAnchor.constraint(equalTo:  self.header.bottomAnchor, constant: 0),
            scrollView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            scrollView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ]
        NSLayoutConstraint.activate(scrollViewconstraints)
        
        //MARK: inside scrollview idk why we need this
        self.scrollView.addSubview(insideScrollVw)
        let screenWidth = screenSize.width
        insideScrollVw.backgroundColor = .clear
        insideScrollVw.translatesAutoresizingMaskIntoConstraints = false
        insideScrollVw.isUserInteractionEnabled = true
        let insideScrollViewconstraints = [
            insideScrollVw.topAnchor.constraint(equalTo:  self.scrollView.contentLayoutGuide.topAnchor, constant: 0),
            insideScrollVw.leftAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.leftAnchor, constant: 0),
            insideScrollVw.rightAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.rightAnchor, constant: 0),
            insideScrollVw.bottomAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.bottomAnchor, constant: 0),
            insideScrollVw.heightAnchor.constraint(equalToConstant: 800),
            insideScrollVw.widthAnchor.constraint(equalToConstant: screenWidth)
        ]
        NSLayoutConstraint.activate(insideScrollViewconstraints)
        
        
        //MARK: questTitle
        self.insideScrollVw.addSubview(questTitle)
        questTitle.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 20).isActive = true
        questTitle.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        
        
        //MARK: set up progress bar
        self.insideScrollVw.addSubview(progressBar)
        progressBar.setProgress(0.2, animated: true)
        progressBar.trackTintColor = .lightGray
        progressBar.tintColor = themeColor
        
        let progressBarConstraints = [
            progressBar.topAnchor.constraint(equalTo:  self.questTitle.bottomAnchor, constant: 20),
            progressBar.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            progressBar.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor),
            progressBar.heightAnchor.constraint(equalToConstant: 2)
        ]
        NSLayoutConstraint.activate(progressBarConstraints)
        progressBar.translatesAutoresizingMaskIntoConstraints = false
        
        //MARK: desc label
        self.insideScrollVw.addSubview(descLabel)
        descLabel.topAnchor.constraint(equalTo: progressBar.bottomAnchor, constant: 20).isActive = true
        descLabel.leadingAnchor.constraint(equalTo: questTitle.leadingAnchor).isActive = true
        descLabel.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 300/375).isActive = true
        
        
        //MARK: subtask tableview
        self.insideScrollVw.addSubview(subtaskTableView)
        self.subtaskTableView.delegate = self
        self.subtaskTableView.dataSource = self
        subtaskTableView.separatorStyle = .none
        subtaskTableView.backgroundColor = .clear
        subtaskTableView.bounces = true
        subtaskTableView.translatesAutoresizingMaskIntoConstraints = false
        subtaskTableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        let TopTableconstraints = [
            self.subtaskTableView.topAnchor.constraint(equalTo:  self.descLabel.bottomAnchor, constant: 10),
            self.subtaskTableView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15),
            self.subtaskTableView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -15),
            self.subtaskTableView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 230/815)
        ]
        NSLayoutConstraint.activate(TopTableconstraints)
        
        
        //MARK: lock image
        self.insideScrollVw.addSubview(lockImage)
        lockImage.image = UIImage(named:"blue lock")
        lockImage.translatesAutoresizingMaskIntoConstraints = false
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(claimStickerPressed(tapGestureRecognizer:)))
        lockImage.isUserInteractionEnabled = true
        lockImage.addGestureRecognizer(tapGestureRecognizer)
        let lockImageconstraints = [
            lockImage.topAnchor.constraint(equalTo:  self.subtaskTableView.bottomAnchor, constant: 15),
            lockImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            lockImage.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 135/815),
            lockImage.widthAnchor.constraint(equalTo: self.lockImage.heightAnchor)
        ]
        NSLayoutConstraint.activate(lockImageconstraints)
        
        
        //MARK: pop up label
        self.insideScrollVw.addSubview(popupLbl)
        popupLbl.text = "Claim"
        popupLbl.backgroundColor = UIColor.init(red: 253/255.0, green: 243/255, blue: 223/255.0, alpha: 1)
        popupLbl.textColor = UIColor.init(red: 0/255.0, green: 51/255, blue: 66/255.0, alpha: 1)
        popupLbl.font = UIFont(name: "Apercu-Regular", size: 16)
        popupLbl.textAlignment = .center
        popupLbl.clipsToBounds = true
        popupLbl.layer.cornerRadius = 10
        popupLbl.isUserInteractionEnabled = true
        popupLbl.addGestureRecognizer(tapGestureRecognizer)
        popupLbl.translatesAutoresizingMaskIntoConstraints = false
        let popupLblconstraints = [
            popupLbl.centerXAnchor.constraint(equalTo:  self.lockImage.centerXAnchor),
            popupLbl.topAnchor.constraint(equalTo: self.lockImage.bottomAnchor, constant: 10),
            popupLbl.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 123/375),
            popupLbl.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 40/815)
        ]
        NSLayoutConstraint.activate(popupLblconstraints)
        popupLbl.isHidden = true
        
        //MARK: stars animation
//        self.view.addSubview(StarsView)
//        let StarsViewconstraints = [
//            StarsView.bottomAnchor.constraint(equalTo:  self.lockImage.topAnchor, constant: 0),
//            StarsView.rightAnchor.constraint(equalTo: self.subtaskTableView.rightAnchor, constant: 0),
//            StarsView.widthAnchor.constraint(equalToConstant: 70),
//            StarsView.heightAnchor.constraint(equalToConstant: 100)
//        ]
//        StarsView.isHidden = true
//        NSLayoutConstraint.activate(StarsViewconstraints)
//        StarsView.translatesAutoresizingMaskIntoConstraints = false
//
//        //MARK: 3 different star variations to be used in animation
//        let imgStar1 = UIImageView()
//        imgStar1.image = UIImage.init(named: "bgStar")
//        self.StarsView.addSubview(imgStar1)
//        let imgStar1constraints = [
//            imgStar1.topAnchor.constraint(equalTo:  self.StarsView.topAnchor, constant: 0),
//            imgStar1.rightAnchor.constraint(equalTo: self.StarsView.rightAnchor, constant: -5),
//            imgStar1.widthAnchor.constraint(equalToConstant: 40),
//            imgStar1.heightAnchor.constraint(equalToConstant: 40)
//        ]
//
//        let imgStar2 = UIImageView()
//        imgStar2.image = UIImage.init(named: "litstar")
//        self.StarsView.addSubview(imgStar2)
//        let imgStar2constraints = [
//            imgStar2.topAnchor.constraint(equalTo:  imgStar1.topAnchor, constant: 40),
//            imgStar2.leftAnchor.constraint(equalTo: self.StarsView.leftAnchor, constant: 0),
//            imgStar2.widthAnchor.constraint(equalToConstant: 25),
//            imgStar2.heightAnchor.constraint(equalToConstant: 25)
//        ]
//
//        let imgStar3 = UIImageView()
//        imgStar3.image = UIImage.init(named: "bgStar")
//        self.StarsView.addSubview(imgStar3)
//        let imgStar3constraints = [
//            imgStar3.bottomAnchor.constraint(equalTo:  self.StarsView.bottomAnchor, constant: 0),
//            imgStar3.rightAnchor.constraint(equalTo: self.StarsView.rightAnchor, constant: 0),
//            imgStar3.widthAnchor.constraint(equalToConstant: 30),
//            imgStar3.heightAnchor.constraint(equalToConstant: 30)
//        ]
//
//        NSLayoutConstraint.activate(imgStar1constraints)
//        NSLayoutConstraint.activate(imgStar2constraints)
//        NSLayoutConstraint.activate(imgStar3constraints)
//
//        imgStar1.translatesAutoresizingMaskIntoConstraints = false
//        imgStar2.translatesAutoresizingMaskIntoConstraints = false
//        imgStar3.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.layoutIfNeeded()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    
    //MARK : IBACTIONS:
    
    @objc func callMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //=============================*** DELEGATE DATASOURCE METHODS ***===============================//
    
    //MARK:  Table View Delegate Methods:
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quests.subtasks.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.selectionStyle = .none
        cell.bgView.backgroundColor = themeBgColor
        cell.labUserName.isHidden = false
        
        //award progress
        let taskType = quests.subtasks[indexPath.row].type
        
        if taskType == "newPost" {
            cell.imgUser.image = UIImage(named: "postQuestionTask")
        } else if taskType == "newConnection" {
            cell.imgUser.image = UIImage(named:"newConnectionsTask")
        } else if taskType == "replyToPost" {
            cell.imgUser.image = UIImage(named:"replyTask")
        } else {
            cell.imgUser.image = UIImage(named: "postQuestionTask")
        }
        
        //subtask title
        cell.labMessage.text = quests.subtasks[indexPath.row].title
        cell.labMessage.textColor = Color.matte
        cell.labMessage.font = UIFont(name: "Apercu-Medium", size: 17)
        
        //current progress
        cell.labUserName.text = ("\(quests.subtasks[indexPath.row].current)/\(quests.subtasks[indexPath.row].target)" )
        cell.labUserName.textColor = Color.matte
        cell.labUserName.font = UIFont(name: "Apercu-Medium", size: 17)
        cell.labUserName.textAlignment = .right
        
        //check mark
        cell.imgUser2.isHidden = true
        cell.imgUser2.image = UIImage.init(named: "check")
        
        cell.img1constraints = [
            cell.imgUser.centerYAnchor.constraint(equalTo:  cell.contentView.centerYAnchor, constant: 0),
            cell.imgUser.leftAnchor.constraint(equalTo:  cell.contentView.leftAnchor, constant: 30),
            cell.imgUser.widthAnchor.constraint(equalToConstant: 40),
            cell.imgUser.heightAnchor.constraint(equalToConstant: 40)
        ]
        NSLayoutConstraint.activate(cell.img1constraints)
        
        cell.TITLEconstraints = [
            cell.labUserName.centerYAnchor.constraint(equalTo:  cell.contentView.centerYAnchor, constant: 0),
            cell.labUserName.rightAnchor.constraint(equalTo:  cell.contentView.rightAnchor, constant: -20),
            cell.labUserName.heightAnchor.constraint(equalToConstant: 20)
        ]
        NSLayoutConstraint.activate(cell.TITLEconstraints)
        
        cell.Messageconstraints = [
            cell.labMessage.centerYAnchor.constraint(equalTo:  cell.contentView.centerYAnchor, constant: 0),
            cell.labMessage.leftAnchor.constraint(equalTo: cell.imgUser2.leftAnchor, constant: 10),
            cell.labMessage.widthAnchor.constraint(equalTo:  cell.contentView.widthAnchor, multiplier: 190/338),
            cell.labMessage.heightAnchor.constraint(equalToConstant: 20)
        ]
        NSLayoutConstraint.activate(cell.Messageconstraints)
        
        cell.contentView.layoutIfNeeded()
        
        //if cell is displaying completed subtask, hide progress and show checkmark for completion
        if quests.subtasks[indexPath.row].current >= quests.subtasks[indexPath.row].target {
            cell.labUserName.isHidden = true
            cell.checkImg.isHidden = false
        }else{
            cell.labUserName.isHidden = false
            cell.checkImg.isHidden = true
        }
        
        //if all tasks completed, user can click to unlock sticker
        if progressBar.progress  == 1.0 {
            StartFloatingStars()
            showPopupLbl()
        } else {
            hidePopupLbl()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select a subtask -- nothing happens :~)")
    }
    
    //=================================== *** SHOW ANIMATION *** ============================================//
    
    // MARK: - Opening lock with animation :
    
    func showPopupLbl() {
        UIView.transition(with: self.popupLbl,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.popupLbl.isHidden = false
                          }, completion: nil)
    }
    func hidePopupLbl() {
        UIView.transition(with: self.popupLbl,
                          duration: 0.25,
                          options: .transitionCrossDissolve,
                          animations: { [weak self] in
                            self?.popupLbl.isHidden = true
                          }, completion: nil)
    }
    func StartFloatingStars()
    {
//        self.timer = Timer.scheduledTimer(timeInterval: 0.8, target: self,   selector: (#selector(StarsAnimationStarts)), userInfo: nil, repeats: true)
    }
    func StopFloatingStars()
    {
        return //idk how to remove the stars
    }
    @objc func StarsAnimationStarts()
    {
        //----------------- For  Bubble :
        
        self.bubbleImageView = UIImageView(image: #imageLiteral(resourceName: "bgStar"))
        let size = randomFloatBetween(5, and: 30)
        bubbleImageView.frame = CGRect(x: ((lockImage.layer.presentation()?.frame.origin.x)!+80) , y: (lockImage.layer.presentation()?.frame.origin.y ?? 0) + 120, width: size, height: size)
        bubbleImageView.alpha = CGFloat(randomFloatBetween(0.1, and: 1))
        view.addSubview(bubbleImageView)
        
        let zigzagPath = UIBezierPath()
        let oX = bubbleImageView.frame.origin.x
        let oY = bubbleImageView.frame.origin.y
        let eX = oX
        let eY = oY - randomFloatBetween(50, and: 300)
        let t = randomFloatBetween(20, and: 100)
        let cp1 = CGPoint(x: oX - t, y: (oY + eY) / 2)
        let cp2 = CGPoint(x: oX + t, y: cp1.y)
        
        zigzagPath.move(to: CGPoint(x: oX, y: oY))
        zigzagPath.addCurve(to: CGPoint(x: eX, y: eY), controlPoint1: cp1, controlPoint2: cp2)
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            
            UIView.transition(
                with: self.bubbleImageView,
                duration: 0.2,
                options: .transitionCrossDissolve,
                animations: {
                    self.bubbleImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                }) { finished in
                self.bubbleImageView.removeFromSuperview()
            }
        })
        
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.duration = 5
        pathAnimation.path = zigzagPath.cgPath
        pathAnimation.fillMode = .forwards
        pathAnimation.isRemovedOnCompletion = false
        bubbleImageView.layer.add(pathAnimation, forKey: "movingAnimation")
        CATransaction.commit()
    }
    
    
    //MARK: refresh called
    @objc func refreshTableView(note: NSNotification) {
        //refresh the subtask table
        self.subtaskTableView.reloadData()
        
        //update progress bar
        let percentageCompleted = getPercentageCompleted(subtasks: quests.subtasks)
        print("percentage completed: \(percentageCompleted)")
        progressBar.setProgress(percentageCompleted , animated: true)
    }

    
    @objc func claimStickerPressed(tapGestureRecognizer: UITapGestureRecognizer) {
        //do not allow claiming if subtasks not complete
        if getPercentageCompleted(subtasks: quests.subtasks) < 1.0 {
            print("QUESTS NOT COMPLETED")
            return
        }
        //reset quest, fetch next sticker, update user's sticker collection
        quests.resetQuestPopup()
        quests.fetchNextSticker()
        quests.updateStickerList()
        //TODO: what happens if all stickers have been obtained?
        //displays alert
        let imageToDisplay = UIImage(named: quests.nextSticker)
        
        let alert = AlertView(headingText: "Kudos! You completed your quest and unlocked a new sticker!", messageText: "You can use this sticker in posts and messages.", action1Label: "Got it", action1Color: Color.burple, action1Completion: {
            self.dismiss(animated: true, completion: nil)
        }, action2Label: "Nil", action2Color: .gray, action2Completion: {
        }, withCancelBtn: false, image: imageToDisplay, withOnlyOneAction: true)
        alert.modalPresentationStyle = .overCurrentContext
        alert.modalTransitionStyle = .crossDissolve
        self.present(alert, animated: true, completion: nil)
        
        //stop stars animation
        StopFloatingStars()
    }
    
    func randomFloatBetween(_ smallNumber: CGFloat, and bigNumber: CGFloat) -> CGFloat {
        let diff = bigNumber - smallNumber
        _ = CGFloat(diff)
        let firstpart = CGFloat(arc4random() % (UInt32(RAND_MAX) + 1))
        let dividation = (firstpart) / CGFloat(RAND_MAX)
        let multiplication = (dividation * diff)
        return multiplication + smallNumber
        
    }
    
    //helper functions
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
        
        let tabName = UILabel()
        tabName.text = "Quests"
        tabName.font = UIFont(name:"Apercu-Bold", size: 22)
        tabName.textColor = Color.teamHeader
        stack.addArrangedSubview(tabName)
        
        return stack
    }
    
    func getPercentageCompleted(subtasks: [Quests.Subtask]) -> Float {
        var count = 0
        for task in subtasks {
            if ( task.current >= task.target){
                count+=1
            }
        }
        return (Float(count) / Float(subtasks.count))
    }
    
    func setupHeader() {
        
        //MARK: add header
        view.addSubview(header)
        
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
    }
}
