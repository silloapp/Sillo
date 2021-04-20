//
//  TeamViewController.swift
//  Sillo
//
//  Created by Angelica Pan on 2/19/21.
//
import Firebase
import UIKit

struct ItemProperty {
    var title: String
    var backgroundImage: UIImage
}

class TeamViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate {
  
    let cellID = "cellID"
    let header : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.navBar
        return view
    }()
    
    
    private let menuItems = [
        MenuItem(name: "My Profile", nextVC: ProfileSetupViewController(), withArrow: false, fontSize: 22), //TODO: replace with actual VC
        //MenuItem(name: "My Connections", nextVC: MyConnectionsVC(), withArrow: false, fontSize: 22),
        MenuItem(name: "People", nextVC: PeopleVC(), withArrow: false, fontSize: 22),
        //MenuItem(name: "Engagement", nextVC: MyConnectionsVC(), withArrow: false, fontSize: 22),
        //MenuItem(name: "Notifications", nextVC: NotificationsViewController(), withArrow: false, fontSize: 22),
        //MenuItem(name: "Reports", nextVC: MyConnectionsVC(), withArrow: false, fontSize: 22),
        MenuItem(name: "Sign Out", nextVC: StartScreenViewController(), withArrow: false, fontSize: 22)
    ]
    
    private let itemProperties = [
        ItemProperty(title: "My Profile", backgroundImage: UIImage(named:"team-1")!),
        ItemProperty(title: "My Connections", backgroundImage: UIImage(named:"team-2")!),
        ItemProperty(title: "People", backgroundImage: UIImage(named:"team-5")!),
        ItemProperty(title: "Engagement", backgroundImage: UIImage(named:"team-3")!),
        ItemProperty(title: "Notifications", backgroundImage: UIImage(named:"team-4")!),
        ItemProperty(title: "Reports", backgroundImage: UIImage(named:"team-6")!),
        ItemProperty(title: "Sign Out", backgroundImage: UIImage(named:"team-7")!),
        
    ]
    
    let menuItemTableView = UITableView() // view
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        overrideUserInterfaceStyle = .light
        
        setupHeader()
        
        view.addSubview(menuItemTableView)
        self.menuItemTableView.tableFooterView = UIView() // remove separators at bottom of tableview
        menuItemTableView.translatesAutoresizingMaskIntoConstraints = false
        menuItemTableView.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        menuItemTableView.leftAnchor.constraint(equalTo:view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        menuItemTableView.rightAnchor.constraint(equalTo:view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        menuItemTableView.bottomAnchor.constraint(equalTo:view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        menuItemTableView.isScrollEnabled = true
        menuItemTableView.dataSource = self
        menuItemTableView.showsVerticalScrollIndicator = false
        menuItemTableView.delegate = self
        menuItemTableView.separatorColor = .clear
        menuItemTableView.register(ImageCell.self, forCellReuseIdentifier: cellID)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! ImageCell
        cell.properties = itemProperties[indexPath.row]
        cell.separatorInset = UIEdgeInsets.zero
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedMenuItem = menuItems[indexPath.row]
        switch selectedMenuItem.name {
        //MARK: pull in profile and allow editing
        case "My Profile":
            if let nextVC = (selectedMenuItem.nextVC as? ProfileSetupViewController) {
                //show loading vc while backend business
                let loadingVC = LoadingViewController()
                loadingVC.modalPresentationStyle = .overCurrentContext
                loadingVC.modalTransitionStyle = .crossDissolve
                self.present(loadingVC, animated: false, completion: nil)
                
                var profileDocumentName = "all_orgs"
                let userID = Constants.FIREBASE_USERID!
                
                
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
                                let profilePic = cloudutil.downloadImage(ref: "profiles/\(userID)\(Constants.image_extension)")
                                
                                nextVC.pronouns = innerDict["pronouns"] as! String
                                nextVC.bioText = innerDict["bio"] as! String
                                nextVC.restaurants = innerDict["restaurants"] as! [String]
                                nextVC.interests = innerDict["interests"] as! [String]
                                nextVC.useSeparateProfiles = use_separate_profiles
                                nextVC.profilePic = profilePic
                                nextVC.takingProfileSetupRole = false //this is a switcher value
                                
                                //log profile editing
                                analytics.log_edit_profile()
                                
                                //transition to next vc
                                self.navigationController?.pushViewController(nextVC, animated: true)
                            }
                            else {
                                //transition to next vc (blank, because organization-specific profile doesn't exist yet)
                                self.navigationController?.pushViewController(nextVC, animated: true)
                            }
                            //dismiss loading overlay
                            loadingVC.dismiss(animated: false, completion: nil)
                        }
                }
                    else {
                        //entire user document does not exist (VERY STRANGE)
                        print("Document does not exist, set dummy data in all_orgs")
                        upperUserRef.setData(["use_separate_profiles":false])
                        let userRef = db.collection("profiles").document(Constants.FIREBASE_USERID!).collection("org_profiles").document("all_orgs")
                        userRef.setData(["pronouns":"no pronouns specified","bio":"","interests":[],"restaurants":[]])
                        
                        self.navigationController?.pushViewController(nextVC, animated: true)
                        
                        //dismiss loading overlay
                        loadingVC.dismiss(animated: false, completion: nil)
                    }
            }
            }
          break
        case "Sign Out":
            localUser.signOut()
            if let nextVC = selectedMenuItem.nextVC {
                nextVC.modalPresentationStyle = .fullScreen
                self.present(nextVC, animated: true, completion: nil)
            }
            break
        default:
            print(menuItems[indexPath.row].name ?? ""  + " was clicked! Will not segway into next VC.. ")
            let vc = menuItems[indexPath.row].nextVC!
            vc.navigationController?.setNavigationBarHidden(false, animated: true)
            self.navigationController?.pushViewController(vc, animated: true)
            //TODO: add Segway into nextVC
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 110
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
        clubName.text = organizationData.currOrganizationName
        clubName.font = Font.bold(22)
        clubName.textColor = Color.teamHeader
        stack.addArrangedSubview(clubName)
        
        return stack
    }
    
    func setupHeader() {
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
        
        //team picture
        let settingsButton = UIImageView()
        settingsButton.image = UIImage(named: "Settings")
        settingsButton.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.contentMode = .scaleAspectFit
        settingsButton.layer.masksToBounds = true
        settingsButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        settingsButton.isUserInteractionEnabled = true
        settingsButton.addGestureRecognizer(tapGestureRecognizer)
        header.addSubview(settingsButton)

        settingsButton.rightAnchor.constraint(equalTo: header.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        settingsButton.centerYAnchor.constraint(equalTo: logoTeamStack.centerYAnchor).isActive = true
        settingsButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        settingsButton.widthAnchor.constraint(equalToConstant: 25).isActive = true
    }
    
    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("Clicked on Settings! Time to segway into settings VC... ")
        let nextVC = SettingsViewController()
//        let nextVC = ProfileVC()
        //nextVC.backingImage = self.navigationController?.view.asImage()
        nextVC.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
}

class ImageCell: UITableViewCell {

    var properties:ItemProperty? {
        didSet {
            guard let properties = properties else { return }
            nameLabel.text = properties.title
            bgImage.image = properties.backgroundImage
        }
    }
    
    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true // this will make sure its children do not go out of the boundary
        view.layer.backgroundColor = Color.russiandolphin.cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    let nameLabel:UILabel = {
        let label = UILabel()
        label.font = Font.medium(22)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    
    let bgImage: UIImageView = {
        let imageView = UIImageView(frame: CGRect(x: 0,y: 0,width: 24,height: 24))
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        containerView.addSubview(nameLabel)
        self.contentView.addSubview(containerView)
        self.contentView.addSubview(bgImage)
        

        containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 8).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -8).isActive = true
        containerView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:5).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-5).isActive = true
        
        nameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant: 20).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
        
        bgImage.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        bgImage.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor,constant: -10).isActive = true
        bgImage.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        bgImage.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
        bgImage.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 0.2).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
