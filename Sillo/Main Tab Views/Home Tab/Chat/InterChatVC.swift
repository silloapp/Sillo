//
//  InterChatVC.swift
//  WithoutStoryboard
//
//  Created by USER on 19/02/21.
//

import UIKit

class InterChatVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK :IBDeclarations:
    
    let screenSize = UIScreen.main.bounds
    let titleLabel = UILabel()
    let TopTable = UITableView()
    var stackView = UIStackView()
    
    var rightArr = [ "lorem ispum dollar sit","lorem ispum dollar sit"]
    
    var leftArr = [ "lorem fanyyyy dollar gromm lorem buzzz","lorem fanyyyy dollar gromm lorem buzzz"]
    
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
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        self.navigationController?.navigationBar.isTranslucent = true
        self.view.backgroundColor = ViewBgColor
        setNavBar()
        settingElemets()
        forStsBar()
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
    }
    
    @objc func chatPressed() {
//        let chatVC = ChatsViewController(messageInputBarStyle: .facebook)
//        let navigationController = UINavigationController(rootViewController: chatVC)
//        navigationController.modalPresentationStyle = .fullScreen
//        self.present(navigationController, animated: true, completion: nil)
        
        let chatVC = ChatsViewController(messageInputBarStyle: .facebook, chatID: "PLACEHOLDER_CHATID", post: nil)
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(chatVC, animated: true)
        
    }
    
    //=============================*** DELEGATE DATASOURCE METHODS ***===============================//
    

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatsbleViewCell
        cell.selectionStyle = .none
        print("cell for row")
        
        var Rightheight = CGFloat()
        var leftheight = CGFloat()
        
        var Rightwidth = CGFloat()
        var leftwidth = CGFloat()
        
  
        if indexPath.row % 2 == 0
        {
            cell.labLeft.isHidden = true
            cell.labRight.isHidden = false
            cell.labRight.text = rightArr[indexPath.row]
            cell.labRight.text = "lorem ispum"
            
            Rightheight = cell.labRight.text!.stringHeight + 30
            
            let RightW = cell.labRight.text!.stringWidth
            if RightW <= 200
            {
                Rightwidth = RightW + 30
            }
            else
            {
                Rightwidth = 200
            }
             
        }
        
        else {
            cell.labLeft.text = "lorem ispum dollar sit lorem ikspum loremm"
            
            cell.labLeft.isHidden = false
            cell.labRight.isHidden = true
            cell.labLeft.text = leftArr[indexPath.row]
            
            let leftW = cell.labLeft.text!.stringWidth + 30
            if leftW <= 200
            {
                leftwidth = leftW
            }
            else
            {
                leftwidth = 200
            }
            
        }
        
        
        print("Rightheight",Rightheight)
        print("leftheight",leftheight)
        

        cell.ViewRightconstraints = [
            cell.ViewRight.topAnchor.constraint(equalTo:  cell.contentView.topAnchor, constant: 8),
            cell.ViewRight.widthAnchor.constraint(equalToConstant: Rightwidth),
            cell.ViewRight.heightAnchor.constraint(equalToConstant: CGFloat(Rightheight)),
            cell.ViewRight.rightAnchor.constraint(equalTo:  cell.contentView.rightAnchor, constant: -20),
            cell.ViewRight.bottomAnchor.constraint(equalTo:  cell.contentView.bottomAnchor, constant: -8)
        ]
        
        
        cell.Viewleftconstraints = [
            cell.Viewleft.topAnchor.constraint(equalTo:  cell.contentView.topAnchor, constant: 8),
            cell.Viewleft.heightAnchor.constraint(equalToConstant: CGFloat(leftheight)),
            cell.Viewleft.widthAnchor.constraint(equalToConstant: leftwidth),
            cell.Viewleft.leftAnchor.constraint(equalTo:  cell.contentView.leftAnchor, constant: 20),
            cell.Viewleft.bottomAnchor.constraint(equalTo:  cell.contentView.bottomAnchor, constant: -8)
        ]
        
        NSLayoutConstraint.activate(cell.ViewRightconstraints)
        NSLayoutConstraint.activate(cell.Viewleftconstraints)
        
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
