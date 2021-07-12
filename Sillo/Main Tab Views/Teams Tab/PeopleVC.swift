//
//  PeopleVC.swift
//  WithoutStoryboard
//
//  Created by William Loo & Ankit on 18/02/21.
//

import UIKit
import Firebase

@available(iOS 13.0, *)
class PeopleVC: UIViewController,UITableViewDelegate,UITableViewDataSource, UITextFieldDelegate {
    
    let TopTable = UITableView()
    let searchView = UIView()
    let searchTf = UITextField()
    let searchImg = UIImageView()
    
    var searchResultAdmins = organizationData.currOrganizationAdmins
    var searchResultMembers = organizationData.currOrganizationMembers
    
    var sections = ["Admins (\(organizationData.currOrganizationAdmins.count))","Members (\(organizationData.currOrganizationMembers.count))"]
    
    var tap: UIGestureRecognizer? = nil
    
    let appearance : UINavigationBarAppearance = {
        let appearance = UINavigationBarAppearance()
        appearance.shadowImage = nil
        appearance.shadowColor = nil
        appearance.backgroundColor = Color.headerBackground
        
        appearance.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor: Color.burple,
                NSAttributedString.Key.font: UIFont(name: "Apercu-Bold", size: 20)!]
        
        return appearance
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.standardAppearance = self.appearance
        tabBarController?.tabBar.isHidden = true
        
        //MARK: Allows swipe from left to go back (making it interactive caused issue with the header)
        let edgePan = UIScreenEdgePanGestureRecognizer(target: self, action: #selector(leftEdgeSwipe))
        edgePan.edges = .left
        view.addGestureRecognizer(edgePan)
        
        setConstraints()
        self.searchTf.delegate = self
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        tabBarController?.tabBar.isHidden = false
        self.navigationController?.isNavigationBarHidden = true
    }

    //MARK: function for left swipe gesture
    @objc func leftEdgeSwipe(_ recognizer: UIScreenEdgePanGestureRecognizer) {
       if recognizer.state == .recognized {
          self.navigationController?.popViewController(animated: true)
       }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = ViewBgColor
        setNavBar()
        
        //attach notification listeners
        NotificationCenter.default.addObserver(self, selector: #selector(self.didFinishLoadingRoster(note:)), name: Notification.Name("finishLoadingRoster"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didFinishLoadingAdmin(note:)), name: Notification.Name("finishLoadingAdmin"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.didFinishLoadingMember(note:)), name: Notification.Name("finishLoadingMember"), object: nil)
        
        organizationData.getRoster() //pull roster
    }
    
    @objc func didFinishLoadingRoster(note:NSNotification) {
        searchResultAdmins = organizationData.currOrganizationAdmins
        searchResultMembers = organizationData.currOrganizationMembers
        TopTable.reloadData()
        updateSectionHeaders()
    }

    @objc func didFinishLoadingAdmin(note:NSNotification) {
        searchResultAdmins = organizationData.currOrganizationAdmins
        searchResultMembers = organizationData.currOrganizationMembers
        TopTable.reloadData()
        updateSectionHeaders()
    }
    
    @objc func didFinishLoadingMember(note:NSNotification) {
        searchResultAdmins = organizationData.currOrganizationAdmins
        searchResultMembers = organizationData.currOrganizationMembers
        
        TopTable.reloadData()
        updateSectionHeaders()
    }
    
    func updateSectionHeaders() {
        sections = ["Admins (\(searchResultAdmins.count))","Members (\(searchResultMembers.count))"]
    }
    
   
    
    func setNavBar() {
        tabBarController?.tabBar.isHidden = true
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 242/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        
        self.title = "People"
        let textAttributes = [NSAttributedString.Key.foregroundColor:Color.burple]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        
        //Setting Buttons :
        
        let backbutton = UIButton(type: UIButton.ButtonType.custom)
        backbutton.setImage(UIImage(named: "back"), for: .normal)
        backbutton.addTarget(self, action:#selector(callMethod), for: .touchUpInside)
        backbutton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let barbackbutton = UIBarButtonItem(customView: backbutton)
        self.navigationItem.leftBarButtonItems = [barbackbutton]
        
        //MARK: invitation button (ADMIN STATUS ONLY)
        if organizationData.adminStatusMap[organizationData.currOrganization!] == true {
            let inviteButton = UIButton(type: UIButton.ButtonType.custom)
            inviteButton.setTitle("Invite", for: .normal)
            inviteButton.titleLabel?.font = UIFont(name: "Apercu-Bold", size: 17)
            inviteButton.backgroundColor = Color.buttonClickable
            inviteButton.addTarget(self, action:#selector(addbtnMethod), for: .touchUpInside)
            inviteButton.frame = CGRect(x: 0, y: 0, width: 80, height: 20)
            inviteButton.cornerRadius = 12
            
            let barImagebutton = UIBarButtonItem(customView: inviteButton)
            self.navigationItem.rightBarButtonItems = [barImagebutton]
        }
        
    }
    //==============================   *** BUTTON ACTIONS ***  ===============================//
    
    @objc func callMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //=============================*** SETTING CONSTRAINTS ***===============================//
    
    func setConstraints()
    
    {
        //------------------------------------ FOR TABLE VIEW--------------------------------------------------//
        
        // FOR SEARCH BAR :
        
        searchView.backgroundColor = UIColor.init(red: 242/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        let searchViewconstraints = [
            searchView.leftAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.leftAnchor, constant: 30),
            searchView.topAnchor.constraint(equalTo:self.view.safeAreaLayoutGuide.topAnchor, constant: 20),
            searchView.heightAnchor.constraint(equalToConstant: 45),
            searchView.rightAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.rightAnchor, constant: -30)
        ]
        
        self.view.addSubview(searchView)
        searchView.clipsToBounds = true
        searchView.layer.cornerRadius = 12
        
        self.searchView.addSubview(searchTf)
        searchTf.attributedPlaceholder = NSAttributedString(string: "Search Name", attributes: [
            .foregroundColor: UIColor.lightGray,
            .font: UIFont(name: "Apercu-Regular", size: 17)
        ])
        searchTf.addTarget(self, action: #selector(self.searchTextFieldDidChange), for: .editingChanged)
        searchTf.placeholder = "Search name"
        searchTf.textColor = .darkGray
        searchTf.tintColor = themeColor
        searchTf.font = UIFont(name: "Apercu-Regular", size: 14)
        
        let searchTfconstraints = [
            searchTf.leftAnchor.constraint(equalTo:self.searchView.leftAnchor, constant: 60),
            searchTf.rightAnchor.constraint(equalTo:self.searchView.rightAnchor, constant: -20),
            searchTf.heightAnchor.constraint(equalToConstant: 30),
            searchTf.centerYAnchor.constraint(equalTo:self.searchView.centerYAnchor, constant: 0)
        ]
        
        
        self.searchView.addSubview(searchImg)
        self.searchImg.image = UIImage.init(named: "search")
        
        let searchImgconstraints = [
            searchImg.leftAnchor.constraint(equalTo:self.searchView.leftAnchor, constant: 15),
            searchImg.heightAnchor.constraint(equalToConstant: 25),
            searchImg.widthAnchor.constraint(equalToConstant: 25),
            searchImg.centerYAnchor.constraint(equalTo:self.searchView.centerYAnchor, constant: 0)
        ]
        
        
        
        // FOR TOP TABLE  :
        
        TopTable.separatorStyle = .singleLine
        TopTable.showsVerticalScrollIndicator = false
        TopTable.backgroundColor = .clear
        TopTable.bounces = true
        
        self.TopTable.register(HederCell.self,
                               forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
        self.TopTable.register(NameCell.self, forCellReuseIdentifier: "nameCell")
        
        let TopTableconstraints = [
            TopTable.topAnchor.constraint(equalTo:   self.view.safeAreaLayoutGuide.topAnchor, constant: 80),
            TopTable.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            TopTable.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            TopTable.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ]
        
        
        self.view.addSubview(TopTable)
        self.TopTable.delegate = self
        self.TopTable.dataSource = self
        
        
        NSLayoutConstraint.activate(TopTableconstraints)
        NSLayoutConstraint.activate(searchViewconstraints)
        NSLayoutConstraint.activate(searchTfconstraints)
        NSLayoutConstraint.activate(searchImgconstraints)
        
        
        self.TopTable.translatesAutoresizingMaskIntoConstraints = false
        self.searchView.translatesAutoresizingMaskIntoConstraints = false
        self.searchTf.translatesAutoresizingMaskIntoConstraints = false
        self.searchImg.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.layoutIfNeeded()
        
    }
    
    //MARK: EXECUTE SEARCH
    //adapted search from: https://stackoverflow.com/questions/30828074/check-if-array-contains-part-of-a-string-in-swift/57767333
    @objc func searchTextFieldDidChange() {
        //reset if empty query
        let filteredSearchQuery = searchTf.text!.filter {$0 != " "}
        if filteredSearchQuery == "" || filteredSearchQuery.count == 0 {
            searchResultAdmins = organizationData.currOrganizationAdmins
            searchResultMembers = organizationData.currOrganizationMembers
        }
        else { //execute search
            let searchQuery = searchTf.text!
            searchResultAdmins = organizationData.currOrganizationAdmins.filter({$0.value.lowercased().range(of: searchQuery.lowercased()) != nil})
            searchResultMembers = organizationData.currOrganizationMembers.filter({$0.value.lowercased().range(of: searchQuery.lowercased()) != nil})
        }
        
        updateSectionHeaders()
        TopTable.reloadData()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        view.addGestureRecognizer(tap!)
    }
    
    //MARK: hide keyboard
    @objc func hideKeyboard() {
        searchTf.resignFirstResponder()
        view.removeGestureRecognizer(self.tap!)
    }
    
    
    //=============================*** DELEGATE DATASOURCE METHODS ***===============================//
    
    //MARK:  Table View Delegate Methods:
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                                                                "sectionHeader") as! HederCell
        tableView.register(NameCell.self, forCellReuseIdentifier: "nameCell")
        view.titlelbl.text = sections[section]
        
        //view.morebtn.addTarget(self, action:#selector(morebtnMethod), for: .touchUpInside)
        //view.addbtn.addTarget(self, action:#selector(addbtnMethod), for: .touchUpInside)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0
        {
            return searchResultAdmins.count
        }
        else
        {
            return searchResultMembers.count
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !organizationData.adminStatusMap[organizationData.currOrganization!]! {
            return
        }
        let cell = tableView.cellForRow(at: indexPath) as! NameCell
            let userID = cell.ID ?? "NO_ID"
        
            let nextVC = ManageUserViewController()
            let imageRef = "profiles/\(userID)\(Constants.image_extension)"
            if imageCache.object(forKey: imageRef as! NSString) == nil {
                cloudutil.downloadImage(ref: imageRef, useCache: true)
            }
            else {
                nextVC.profilePic = imageCache.object(forKey: imageRef as NSString)?.image! ?? UIImage(named:"avatar-4")!
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath) as! NameCell
            
            cell.ID = Array(searchResultAdmins.keys)[indexPath.row]
            cell.name = Array(searchResultAdmins.values)[indexPath.row]
            
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            cell.textLabel?.font = UIFont.init(name: "Apercu-Regular", size: 15)
            cell.textLabel?.textColor = .darkGray
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = cell.name
            

            
            return cell
            
        }
        else
        {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "nameCell", for: indexPath) as! NameCell
            
            cell.ID = Array(searchResultMembers.keys)[indexPath.row]
            cell.name = Array(searchResultMembers.values)[indexPath.row]
            
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            cell.textLabel?.font = UIFont.init(name: "Apercu-Regular", size: 15)
            cell.textLabel?.textColor = .darkGray
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = cell.name
            
            return cell
        }
    }
    @objc func morebtnMethod(sender:UIButton)
    {
        print("more button clicked")
        TopTable.setEditing(!TopTable.isEditing, animated: true)
      
    }
    @objc func addbtnMethod(sender:UIButton)
    {
        print("add button clicked")
        let nextVC = AddPeopleToSpaceViewController()
        nextVC.orgNameString = organizationData.currOrganizationName
        nextVC.orgImage = UIImage(named: "avatar-2") //TODO: handle pictures
        nextVC.onboardingMode = false
        self.navigationController?.pushViewController(nextVC, animated: true)
        
    }
    
}

//MARK: namecell
//quickie override to add attributes
class NameCell: UITableViewCell {
    var name: String? = ""
    var ID: String? = ""
}

class HederCell: UITableViewHeaderFooterView {
    
    let titlelbl = UILabel()
    let morebtn = UIButton()
    let addbtn = UIButton()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        
        self.backgroundColor = .clear
        contentView.backgroundColor = UIColor.init(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1)
        
        var myCustomView = UIView()
        
        myCustomView.backgroundColor = .clear
        let myCustomViewconstraints = [
            myCustomView.leftAnchor.constraint(equalTo: contentView.layoutMarginsGuide.leftAnchor, constant: 0),
            myCustomView.topAnchor.constraint(equalTo: contentView.layoutMarginsGuide.topAnchor, constant: 0),
            myCustomView.bottomAnchor.constraint(equalTo:  contentView.layoutMarginsGuide.bottomAnchor, constant: 0),
            myCustomView.rightAnchor.constraint(equalTo:  contentView.layoutMarginsGuide.rightAnchor, constant: 0)
        ]
        
        contentView.addSubview(myCustomView)
        
        myCustomView.addSubview(titlelbl)
        titlelbl.text = "Not initialized"
        titlelbl.textColor = .black
        titlelbl.font = UIFont(name: "Apercu-Bold", size: 17)
        
        let titlelblconstraints = [
            titlelbl.leftAnchor.constraint(equalTo:myCustomView.leftAnchor, constant: 5),
            titlelbl.heightAnchor.constraint(equalToConstant: 25),
            titlelbl.centerYAnchor.constraint(equalTo:myCustomView.centerYAnchor, constant: 0)
        ]
        
        let moreImg = UIImageView()
        //myCustomView.addSubview(moreImg)
        moreImg.image = UIImage.init(named: "more")
        moreImg.isUserInteractionEnabled = false
        
        let moreImgconstraints = [
            moreImg.rightAnchor.constraint(equalTo:myCustomView.rightAnchor, constant: -20),
            moreImg.heightAnchor.constraint(equalToConstant: 28),
            moreImg.widthAnchor.constraint(equalToConstant: 28),
            moreImg.centerYAnchor.constraint(equalTo:myCustomView.centerYAnchor, constant: 0)
        ]
        
        let addImg = UIImageView()
        //myCustomView.addSubview(addImg)
        addImg.image = UIImage.init(named: "add")
        moreImg.isUserInteractionEnabled = false
        
        
        let addImgconstraints = [
            addImg.rightAnchor.constraint(equalTo:myCustomView.rightAnchor, constant: -70),
            addImg.heightAnchor.constraint(equalToConstant: 28),
            addImg.widthAnchor.constraint(equalToConstant: 28),
            addImg.centerYAnchor.constraint(equalTo:myCustomView.centerYAnchor, constant: 0)
        ]
        
        
        //myCustomView.addSubview(morebtn)
        //morebtn.backgroundColor = .clear
        
        let morebtnconstraints = [
            morebtn.rightAnchor.constraint(equalTo:myCustomView.rightAnchor, constant: -20),
            morebtn.heightAnchor.constraint(equalToConstant: 28),
            morebtn.widthAnchor.constraint(equalToConstant: 28),
            morebtn.centerYAnchor.constraint(equalTo:myCustomView.centerYAnchor, constant: 0)
        ]
        
        
        //myCustomView.addSubview(addbtn)
        //addbtn.backgroundColor = .clear
        
        let addbtnconstraints = [
            addbtn.rightAnchor.constraint(equalTo:myCustomView.rightAnchor, constant: -70),
            addbtn.heightAnchor.constraint(equalToConstant: 28),
            addbtn.widthAnchor.constraint(equalToConstant: 28),
            addbtn.centerYAnchor.constraint(equalTo:myCustomView.centerYAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(myCustomViewconstraints)
        NSLayoutConstraint.activate(titlelblconstraints)
        //NSLayoutConstraint.activate(moreImgconstraints)
        //NSLayoutConstraint.activate(addImgconstraints)
        //NSLayoutConstraint.activate(morebtnconstraints)
        //NSLayoutConstraint.activate(addbtnconstraints)
        
        myCustomView.translatesAutoresizingMaskIntoConstraints = false
        titlelbl.translatesAutoresizingMaskIntoConstraints = false
        moreImg.translatesAutoresizingMaskIntoConstraints = false
        addImg.translatesAutoresizingMaskIntoConstraints = false
        morebtn.translatesAutoresizingMaskIntoConstraints = false
        addbtn.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.layoutIfNeeded()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}


