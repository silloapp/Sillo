//
//  AnimationWaterBubbleVC.swift
//  WithoutStoryboard
//
//  Created by USER on 22/02/21.
//

import UIKit


class AnimationWaterBubbleVC: UIViewController {
    
    var parentVw = UIView()
    
    var BgimageVw = UIImageView()
    var RiseUpimageVw = UIImageView()
    var RiseUpimageVwTop = UIImageView()
    
    var UpperProfileImg = UIImageView()
    var lowerProfileImg = UIImageView()
    
    var titlelbl = UILabel()
//    var starImg = UIImageView()
    var starCountLbl = UILabel()
    var revealingNumberLbl = UILabel()
    
    var ContinueBtn = UIButton()
    
    var timer = Timer()
    var timerFluid = Timer()
    
    let screenSize = UIScreen.main.bounds
    var change:CGFloat = 0.01
    var wave: WaveAnimationView!
    
    let chatID: String
    
    //MARK: next button
    let nextButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.setTitle("Continue", for: .normal)
        button.titleLabel?.font = UIFont(name: "Apercu-Bold", size: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Color.buttonClickable
        button.addTarget(self, action: #selector(continuePressed), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.becomeFirstResponder()
        return button
    }()
    
    let saveChangesContainer: UIView = {
        let v = UIView()
        v.backgroundColor = .white
        v.translatesAutoresizingMaskIntoConstraints = false

        //set shadow
        v.layer.shadowRadius = 10
        v.layer.shadowOpacity = 0.25
        v.layer.shadowOffset = .zero
        v.layer.shadowColor = UIColor.black.cgColor
        v.layer.shadowPath = UIBezierPath(rect: v.layer.bounds.insetBy(dx: 4, dy: 4)).cgPath
        
        return v
    }()
    
    init(chatID: String) {
        self.chatID = chatID
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshProfilePicture), name: Notification.Name(rawValue: "refreshPicture"), object: nil)
        
        RiseUpimageVw.contentMode = .scaleToFill
        RiseUpimageVw.backgroundColor = .white
        RiseUpimageVw.backgroundColor = .clear
        RiseUpimageVw.frame = CGRect(x: 0, y:  self.view.frame.height, width: self.view.frame.width, height: 5)
        self.view.addSubview(RiseUpimageVw)
        RiseUpimageVwTop.contentMode = .scaleToFill
        RiseUpimageVwTop.backgroundColor = .white
        RiseUpimageVwTop.frame = CGRect(x: 0, y:  0, width: self.view.frame.width, height: self.view.frame.height+5)
        self.view.addSubview(RiseUpimageVwTop)
        view.sendSubviewToBack(RiseUpimageVw)
        

        
        upRiseup()
        settingElemets()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        //MARK: next button container
        view.addSubview(saveChangesContainer)
        saveChangesContainer.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        saveChangesContainer.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        saveChangesContainer.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 90/812).isActive = true
        saveChangesContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        saveChangesContainer.isHidden = true
        saveChangesContainer.alpha = 0
        view.bringSubviewToFront(saveChangesContainer)
        
        //MARK: next button
        saveChangesContainer.addSubview(nextButton)
        nextButton.centerXAnchor.constraint(equalTo: saveChangesContainer.centerXAnchor).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: saveChangesContainer.centerYAnchor, constant: -5).isActive = true
        nextButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 50/812).isActive = true
        nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true

        
        UIView.animate(withDuration: 0.5, delay: 1.5, options: UIView.AnimationOptions.curveEaseInOut, animations: {
            self.saveChangesContainer.isHidden = false
            self.saveChangesContainer.alpha = 100
        })
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        timer.invalidate()
        wave.stopAnimation()
    }
    
    // MARK: -============================= Fluid animation ===============================
    
    
    
    @objc func continuePressed() {
        let chatVC = ChatsViewController(messageInputBarStyle: .facebook, chatID: self.chatID , post: nil)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(chatVC, animated: true)
    }
    
    //notification callback for refreshing profile picture
    @objc func refreshProfilePicture(_:UIImage) {
        
        //for person you're talking to
        let profilePictureRef = "profiles/\(chatHandler.chatMetadata[self.chatID]!.recipient_uid!)\(Constants.image_extension)"
        if let cachedImage = imageCache.object(forKey: profilePictureRef as NSString)?.image ?? UIImage(named:"avatar-4") {
            self.UpperProfileImg.image = cachedImage
        }
        else {
            cloudutil.downloadImage(ref: profilePictureRef)
        }
        
        //for yourself
        let myprofilePictureRef = "profiles/\(Constants.FIREBASE_USERID!)\(Constants.image_extension)"
        if let mycachedImage = imageCache.object(forKey: myprofilePictureRef as NSString)?.image ?? UIImage(named:"avatar-2") {
            self.lowerProfileImg.image = mycachedImage
        }
        else {
            cloudutil.downloadImage(ref: myprofilePictureRef)
        }
    }

    
    func settingElemets() {
        
        // MARK: -=============================== SETTING CONSTRAINTS============================================
        
        self.view.addSubview(BgimageVw)
        BgimageVw.contentMode = .scaleToFill
        
        let BgimageVwconstraints = [
            BgimageVw.topAnchor.constraint(equalTo:  self.view.topAnchor, constant: 0),
            BgimageVw.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            BgimageVw.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            BgimageVw.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ]
        
        
        self.view.addSubview(UpperProfileImg)
        UpperProfileImg.contentMode = .scaleAspectFill
        UpperProfileImg.image = UIImage(named: "avatar-1")
        UpperProfileImg.clipsToBounds = true
        UpperProfileImg.layer.cornerRadius = 18
        let picRef:NSString = "profiles/\(chatHandler.chatMetadata[self.chatID]!.recipient_uid!)\(Constants.image_extension)" as NSString
        var firebaseImage = UIImage(named:"avatar-10")
        if (imageCache.object(forKey: picRef)?.image != nil) {
            firebaseImage = imageCache.object(forKey: picRef)?.image
        }
        else {
            cloudutil.downloadImage(ref: "profiles/\(chatHandler.chatMetadata[self.chatID]!.recipient_uid!)\(Constants.image_extension)")
        }
        UpperProfileImg.image = firebaseImage!
        
        let UpperProfileImgconstraints = [
            UpperProfileImg.topAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.topAnchor, constant: 30),
            UpperProfileImg.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 25),
            UpperProfileImg.widthAnchor.constraint(equalToConstant: 100),
            UpperProfileImg.heightAnchor.constraint(equalToConstant: 100)
        ]
        
        self.BgimageVw.addSubview(lowerProfileImg)
        lowerProfileImg.image = UIImage(named:"avatar-2")
        
        let mypicRef:NSString = "profiles/\(Constants.FIREBASE_USERID!)\(Constants.image_extension)" as NSString
        var myfirebaseImage = UIImage(named:"avatar-10")
        if (imageCache.object(forKey: mypicRef)?.image != nil) {
            myfirebaseImage = imageCache.object(forKey: mypicRef)?.image
        }
        else {
            cloudutil.downloadImage(ref: "profiles/\(Constants.FIREBASE_USERID!)\(Constants.image_extension)")
        }
        lowerProfileImg.contentMode = .scaleAspectFill
        lowerProfileImg.image = myfirebaseImage!
        
        lowerProfileImg.clipsToBounds = true
        lowerProfileImg.layer.cornerRadius = 25
        
        let lowerProfileImgconstraints = [
            lowerProfileImg.bottomAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.bottomAnchor, constant: -120),
            lowerProfileImg.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -25),
            lowerProfileImg.widthAnchor.constraint(equalToConstant: 50),
            lowerProfileImg.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        
        starCountLbl.text = "+25" //TODO: replace this
        starCountLbl.textColor = .black
        starCountLbl.font = UIFont.init(name: "Apercu-Medium", size: 16)
        starCountLbl.numberOfLines = 1
        
        let starCountLblconstraints = [
            starCountLbl.topAnchor.constraint(equalTo:  self.lowerProfileImg.bottomAnchor, constant: 15),
            starCountLbl.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            starCountLbl.widthAnchor.constraint(equalToConstant: 60),
            starCountLbl.heightAnchor.constraint(equalToConstant: 16)
        ]
        self.BgimageVw.addSubview(revealingNumberLbl)
        self.BgimageVw.addSubview(starCountLbl)

        revealingNumberLbl.text = "" //TODO: replace this once connections are implemented
        revealingNumberLbl.textColor = .white
        revealingNumberLbl.font = UIFont.init(name: "Apercu-Bold", size: 300)
        revealingNumberLbl.numberOfLines = 1
        
        let revealingNumberLblconstraints = [
            revealingNumberLbl.topAnchor.constraint(equalTo:  self.titlelbl.bottomAnchor, constant: 40 ),
            revealingNumberLbl.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor, constant: 50),
            revealingNumberLbl.widthAnchor.constraint(equalToConstant: 200),
            revealingNumberLbl.heightAnchor.constraint(equalToConstant: 240)
        ]
        
        
//        self.BgimageVw.addSubview(starImg)
//        starImg.image = UIImage(named:"bgStar")
//        starImg.contentMode = .scaleAspectFit
//
//        let starImgconstraints = [
//            starImg.topAnchor.constraint(equalTo:  self.starCountLbl.topAnchor, constant: 0),
//            starImg.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -65),
//            starImg.widthAnchor.constraint(equalToConstant: 16),
//            starImg.heightAnchor.constraint(equalToConstant: 16)
//        ]
        
        self.view.addSubview(titlelbl)
        let recipientName = chatHandler.chatMetadata[chatID]?.recipient_name ?? "a new friend"
        titlelbl.text = "Kudos! Here's to a connection with \(recipientName)! 🎉 "
        titlelbl.textColor = themeColor
        titlelbl.font = UIFont.init(name: "Apercu-Bold", size:32)
        titlelbl.numberOfLines = 0
        
        let titlelblconstraints = [
            titlelbl.topAnchor.constraint(equalTo:  self.UpperProfileImg.bottomAnchor, constant: 12),
            titlelbl.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 25),
            titlelbl.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -40),
            titlelbl.heightAnchor.constraint(equalToConstant: 150)
        ]
        
        
        //MARK: - FOR ACTIVATING CONSTARTINS:
        
        NSLayoutConstraint.activate(BgimageVwconstraints)
        NSLayoutConstraint.activate(UpperProfileImgconstraints)
        NSLayoutConstraint.activate(titlelblconstraints)
        NSLayoutConstraint.activate(lowerProfileImgconstraints)
        NSLayoutConstraint.activate(starCountLblconstraints)
//        NSLayoutConstraint.activate(starImgconstraints)
        NSLayoutConstraint.activate(revealingNumberLblconstraints)
        
        self.view.layoutIfNeeded()
        
        self.BgimageVw.translatesAutoresizingMaskIntoConstraints = false
        self.UpperProfileImg.translatesAutoresizingMaskIntoConstraints = false
        self.titlelbl.translatesAutoresizingMaskIntoConstraints = false
        self.lowerProfileImg.translatesAutoresizingMaskIntoConstraints = false
        self.starCountLbl.translatesAutoresizingMaskIntoConstraints = false
//        self.starImg.translatesAutoresizingMaskIntoConstraints = false
        self.ContinueBtn.translatesAutoresizingMaskIntoConstraints = false
        self.revealingNumberLbl.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func upRiseup() {
        //
        wave = WaveAnimationView(frame: CGRect(origin: .zero, size: RiseUpimageVw.bounds.size), color: UIColor.blue.withAlphaComponent(0.5))
        //   wave = WaveAnimationView(frame: CGRect(x: 0, y:  self.view.frame.height/2 , width: self.view.frame.width, height: self.view.frame.height/2), color: UIColor.white.withAlphaComponent(0.5))
        self.RiseUpimageVw.addSubview(wave)
        wave.startAnimation()
        wave.frontColor = UIColor.white.withAlphaComponent(0.8)
        wave.backColor = UIColor.white.withAlphaComponent(0.8)
        wave.waveHeight = 5
        self.wave.setProgress(1.0)
        
        
        
        self.RiseUpimageVw.layer.borderColor = UIColor.white.cgColor
        UIView.animate(withDuration: 3) { [self] in
            self.RiseUpimageVw.transform = CGAffineTransform(translationX:0 , y: -(screenSize.height+screenSize.height))
            self.RiseUpimageVwTop.transform = CGAffineTransform(translationX:0 , y: -(screenSize.height+screenSize.height))
            self.view.backgroundColor = UIColor.init(red: 223/255.0, green: 234/255.0, blue: 251/255.0, alpha: 1)
        }
        
        self.timerFluid = Timer.scheduledTimer(timeInterval: 5.0, target: self,   selector: (#selector(ShowElements)), userInfo: nil, repeats: false)
        
    }
    
    @objc func ShowElements() {
        self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self,   selector: (#selector(StarsAnimationStarts)), userInfo: nil, repeats: true)
    }
    
    @objc func StarsAnimationStarts() {
        //----------------- For  Bubble :
        
        let bubbleImageView = UIImageView(image: UIImage(named:"bgStar"))
        let size = randomFloatBetween(5, and: 30)
        bubbleImageView.frame = CGRect(x: (lowerProfileImg.layer.presentation()?.frame.origin.x ?? 0) , y: (lowerProfileImg.layer.presentation()?.frame.origin.y ?? 0) + 80, width: size, height: size)
        bubbleImageView.alpha = CGFloat(randomFloatBetween(0.1, and: 1))
        view.addSubview(bubbleImageView)
        
        let zigzagPath = UIBezierPath()
        let oX = bubbleImageView.frame.origin.x
        let oY = bubbleImageView.frame.origin.y
        let eX = oX
        let eY = oY - randomFloatBetween(50, and: 500)
        let t = randomFloatBetween(20, and: 100)
        let cp1 = CGPoint(x: oX - t, y: (oY + eY) / 2)
        let cp2 = CGPoint(x: oX + t, y: cp1.y)
        
        zigzagPath.move(to: CGPoint(x: oX, y: oY))
        zigzagPath.addCurve(to: CGPoint(x: eX, y: eY), controlPoint1: cp1, controlPoint2: cp2)
        CATransaction.begin()
        CATransaction.setCompletionBlock({
            
            UIView.transition(
                with: bubbleImageView,
                duration: 0.1,
                options: .transitionCrossDissolve,
                animations: {
                    bubbleImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                }) { finished in
                bubbleImageView.removeFromSuperview()
            }
        })
        
        let pathAnimation = CAKeyframeAnimation(keyPath: "position")
        pathAnimation.duration = 5
        pathAnimation.path = zigzagPath.cgPath
        pathAnimation.fillMode = .forwards
        pathAnimation.isRemovedOnCompletion = false
        bubbleImageView.layer.add(pathAnimation, forKey: "movingAnimation")
        CATransaction.commit()
        
        self.RiseUpimageVw.isHidden = true
    }
    
    func randomFloatBetween(_ smallNumber: CGFloat, and bigNumber: CGFloat) -> CGFloat {
        let diff = bigNumber - smallNumber
        let differnece = CGFloat(diff)
        let firstpart = CGFloat(arc4random() % (UInt32(RAND_MAX) + 1))
        let dividation = (firstpart) / CGFloat(RAND_MAX)
        let multiplication = (dividation * diff)
        return multiplication + smallNumber
        
    }
    
}


