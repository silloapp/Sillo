//
//  WelcomeToSilloViewController.swift
//  Sillo
//
//  Created by William Loo on 3/20/21.
//

import Firebase
import UIKit

@available(iOS 13.0, *)
class WelcomeToSilloViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    // MARK: - IBDeclarations :
    
    let scrollView = UIScrollView()
    let insideScrollVw = UIView()
    let titleLabel = UILabel()
    let screenSize = UIScreen.main.bounds
    let TopTable = UITableView()
    
    //MARK: init exit button
    let exitButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "back"), for: .normal)
        btn.imageView?.contentMode = .scaleAspectFit
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var selectedIndx = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.refreshInvitesList(note:)), name: Notification.Name("InvitationsReady"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.inviteAccepted(note:)), name: Notification.Name("ColdOrgChangeComplete"), object: nil)
        
        localUser.getInvites()
        self.view.backgroundColor = ViewBgColor
        self.navigationController?.navigationBar.isHidden = true
        settingElemets()
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
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ]
        
        self.scrollView.addSubview(insideScrollVw)
        let screenWidth = screenSize.width
        
        
        // FOR EXIT BUTTON :
        view.addSubview(exitButton)
        exitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        exitButton.addTarget(self, action: #selector(exitPressed), for: .touchUpInside)
        
        // FOR TITLE :
        
        self.insideScrollVw.addSubview(titleLabel)
        titleLabel.text = "Welcome to Sillo"
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = Color.burple
        titleLabel.font = UIFont(name: "Apercu-Bold", size: 22)
        titleLabel.textAlignment = .left
        
        let TITLEconstraints = [
            titleLabel.topAnchor.constraint(equalTo:  view.safeAreaLayoutGuide.topAnchor, constant: 20),
            titleLabel.leftAnchor.constraint(equalTo: exitButton.rightAnchor, constant: 20),
            titleLabel.centerYAnchor.constraint(equalTo: exitButton.centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 25)
        ]
        
        // FOR secondTITLE :
        
        let sectitleLabel = UILabel()
        self.insideScrollVw.addSubview(sectitleLabel)
        sectitleLabel.text = "These are spaces you've been invited to. Select the spaces you would like to join. You can always sign in to more later."
        sectitleLabel.backgroundColor = .clear
        sectitleLabel.textColor = .black
        sectitleLabel.font = UIFont(name: "Apercu-Regular", size: 16)
        sectitleLabel.textAlignment = .left
        sectitleLabel.numberOfLines = 0
        sectitleLabel.lineBreakMode = .byWordWrapping
        
        let sectitleLabelconstraints = [
            sectitleLabel.topAnchor.constraint(equalTo:  self.titleLabel.topAnchor, constant: 50),
            sectitleLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            sectitleLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -25),
            sectitleLabel.heightAnchor.constraint(equalToConstant: 70)
        ]
        
        // FOR BOTTOM TITLE :
        
        let bottomtitleLabel = UILabel()
        self.insideScrollVw.addSubview(bottomtitleLabel)
        bottomtitleLabel.text = "This is a list of all your teams associated with \(Constants.EMAIL ?? "your email")."
        bottomtitleLabel.backgroundColor = .clear
        bottomtitleLabel.textColor = .black
        bottomtitleLabel.font = UIFont(name: "Apercu-Regular", size: 16)
        bottomtitleLabel.textAlignment = .left
        bottomtitleLabel.numberOfLines = 0
        bottomtitleLabel.lineBreakMode = .byWordWrapping
        
        let bottomtitleconstraints = [
            bottomtitleLabel.topAnchor.constraint(equalTo:  self.insideScrollVw.bottomAnchor, constant: 40),
            bottomtitleLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            bottomtitleLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -25),
            bottomtitleLabel.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        let insideScrollViewconstraints = [
            insideScrollVw.topAnchor.constraint(equalTo:  titleLabel.bottomAnchor, constant: 100),
            insideScrollVw.leftAnchor.constraint(equalTo: view.leftAnchor),
            insideScrollVw.rightAnchor.constraint(equalTo: view.rightAnchor),
            insideScrollVw.heightAnchor.constraint(equalToConstant: 300),
            insideScrollVw.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor)
        ]
        
        // FOR BOTTOM secondTITLE :
        
        let bottomSectitleLabel = UILabel()
        self.insideScrollVw.addSubview(bottomSectitleLabel)
        bottomSectitleLabel.text = "Don't see what you're looking for? Make sure you've been invited by your team leader."
        bottomSectitleLabel.backgroundColor = .clear
        bottomSectitleLabel.textColor = Color.burple
        bottomSectitleLabel.font = UIFont(name: "Apercu-Regular", size: 16)
        bottomSectitleLabel.textAlignment = .left
        bottomSectitleLabel.numberOfLines = 0
        bottomSectitleLabel.lineBreakMode = .byWordWrapping
        
        let bottomSectitleLabelconstraints = [
            bottomSectitleLabel.topAnchor.constraint(equalTo:  bottomtitleLabel.topAnchor, constant: 75),
            bottomSectitleLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            bottomSectitleLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -25),
            bottomSectitleLabel.heightAnchor.constraint(equalToConstant: 50)
            
        ]
        
        // FOR BOTTOM BUTTON :
        
        let BottomButton = UIButton()
        self.insideScrollVw.addSubview(BottomButton)
        BottomButton.backgroundColor = Color.buttonClickable
        BottomButton.setTitle("Create New Space", for: .normal)
        BottomButton.titleLabel?.font = UIFont(name: "Apercu-Bold", size: 16)
        BottomButton.setTitleColor(.white, for: .normal)
        BottomButton.clipsToBounds = true
        BottomButton.cornerRadius = 7
        
        
        let BottomButtonconstraints = [
            BottomButton.topAnchor.constraint(equalTo:  bottomSectitleLabel.topAnchor, constant: 95),
            BottomButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            BottomButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -25),
            BottomButton.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        BottomButton.addTarget(self, action:#selector(BottomButtonMethod), for: .touchUpInside)
        
        
        //------------------------------------ FOR TABLE VIEWS--------------------------------------------------//
        
        // FOR TOP TABLE  :
        
        TopTable.separatorStyle = .none
        TopTable.backgroundColor = .clear
        TopTable.bounces = true
        TopTable.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        
        let TopTableconstraints = [
            TopTable.topAnchor.constraint(equalTo:  sectitleLabel.topAnchor, constant: 75),
            TopTable.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            TopTable.widthAnchor.constraint(equalTo: sectitleLabel.widthAnchor, constant: 20),
            TopTable.heightAnchor.constraint(equalToConstant: 300)
        ]
        self.insideScrollVw.addSubview(TopTable)
        
        self.TopTable.delegate = self
        self.TopTable.dataSource = self
        
        
        
        //-----------for activating constraints:
        
        NSLayoutConstraint.activate(scrollViewconstraints)
        NSLayoutConstraint.activate(insideScrollViewconstraints)
        NSLayoutConstraint.activate(TITLEconstraints)
        NSLayoutConstraint.activate(sectitleLabelconstraints)
        NSLayoutConstraint.activate(TopTableconstraints)
        NSLayoutConstraint.activate(bottomtitleconstraints)
        NSLayoutConstraint.activate(bottomSectitleLabelconstraints)
        NSLayoutConstraint.activate(BottomButtonconstraints)
        
        
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.insideScrollVw.translatesAutoresizingMaskIntoConstraints = false
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        sectitleLabel.translatesAutoresizingMaskIntoConstraints = false
        TopTable.translatesAutoresizingMaskIntoConstraints = false
        bottomtitleLabel.translatesAutoresizingMaskIntoConstraints = false
        bottomSectitleLabel.translatesAutoresizingMaskIntoConstraints = false
        BottomButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.layoutIfNeeded()
        
        
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
            let nextVC = prepareTabVC()
            nextVC.modalPresentationStyle = .fullScreen
            nextVC.modalTransitionStyle = .crossDissolve
            self.present(nextVC, animated: true)
        }
    }
    
    @objc func BottomButtonMethod() {
        let nextVC = SetupOrganizationViewController()
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
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.selectionStyle = .none
        
        
        cell.bgView.backgroundColor = hexStringToUIColor(hex: "#F2F4F4")
        cell.labUserName.isHidden = true
        cell.imgUser2.isHidden = true
        
        cell.imgUser.borderWidth = 3.5
        cell.imgUser.borderColor = .gray
        
        let orgID : String = localUser.invites[indexPath.row]
        cell.labMessage.text = localUser.invitesMapping[orgID] ?? "ERROR"
        cell.labMessage.textColor = .black
        cell.labMessage.font = UIFont(name: "Apercu-Bold", size: 22)
        
        cell.img1constraints = [
            cell.imgUser.centerYAnchor.constraint(equalTo:  cell.centerYAnchor),
            cell.imgUser.leftAnchor.constraint(equalTo:  cell.leftAnchor, constant: 40),
            cell.imgUser.widthAnchor.constraint(equalToConstant: 60),
            cell.imgUser.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        cell.Messageconstraints = [
            cell.labMessage.centerYAnchor.constraint(equalTo:  cell.centerYAnchor),
            cell.labMessage.leftAnchor.constraint(equalTo:  cell.leftAnchor, constant: 110),
            cell.labMessage.rightAnchor.constraint(equalTo:  cell.rightAnchor, constant: 20),
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
    
    //MARK: selected the cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedIndx = indexPath.row
        self.TopTable.reloadData()
        let orgID : String = localUser.invites[selectedIndx]
        
        localUser.acceptInvite(organizationID: orgID)
    }
    
    @objc func inviteAccepted(note:NSNotification) {
        let nextVC = ProfilePromptViewController()
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
