//
//  PeopleVC.swift
//  WithoutStoryboard
//
//  Created by USER on 18/02/21.
//

import UIKit

@available(iOS 13.0, *)
class PeopleVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    let TopTable = UITableView()
    let searchView = UIView()
    let searchTf = UITextField()
    let searchImg = UIImageView()
    var sections = ["Admins (\(organizationData.currOrganizationAdmins.count))","Members (\(organizationData.currOrganizationMembers.count))"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        setConstraints()
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
        TopTable.reloadData()
        updateSectionHeaders()
    }

    @objc func didFinishLoadingAdmin(note:NSNotification) {
        TopTable.reloadData()
        updateSectionHeaders()
    }
    
    @objc func didFinishLoadingMember(note:NSNotification) {
        TopTable.reloadData()
        updateSectionHeaders()
    }
    
    func updateSectionHeaders() {
        sections = ["Admins (\(organizationData.currOrganizationAdmins.count))","Members (\(organizationData.currOrganizationMembers.count))"]
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    func setNavBar() {
        
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 242/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        self.title = "People"
        
        //Setting Buttons :
        
        let backbutton = UIButton(type: UIButton.ButtonType.custom)
        backbutton.setImage(UIImage(named: "back"), for: .normal)
        backbutton.addTarget(self, action:#selector(callMethod), for: .touchUpInside)
        backbutton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let barbackbutton = UIBarButtonItem(customView: backbutton)
        self.navigationItem.leftBarButtonItems = [barbackbutton]
        
        let Imagebutton = UIButton(type: UIButton.ButtonType.custom)
        Imagebutton.setImage(UIImage(named: "Nathan"), for: .normal)
        Imagebutton.addTarget(self, action:#selector(callMethod), for: .touchUpInside)
        Imagebutton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        Imagebutton.imageView?.contentMode = .scaleAspectFill
        Imagebutton.imageView?.borderWidth = 2
        Imagebutton.imageView?.borderColor = UIColor.init(red: 222/255.0, green: 222/255.0, blue: 222/255.0, alpha: 1)
        Imagebutton.imageView?.clipsToBounds = true
        Imagebutton.imageView?.layer.cornerRadius = 12
        
        let barImagebutton = UIBarButtonItem(customView: Imagebutton)
        self.navigationItem.rightBarButtonItems = [barImagebutton]
        
        
    }
    //==============================   *** BUTTON ACTIONS ***  ===============================//
    
    @objc func callMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    @objc func menuMethod() {
        
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
        searchTf.attributedPlaceholder = NSAttributedString(string: "Search Name",
                                                            attributes: [NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        
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
        TopTable.backgroundColor = .clear
        TopTable.bounces = true
        
        self.TopTable.register(HederCell.self,
                               forHeaderFooterViewReuseIdentifier: "sectionHeader")
        
        self.TopTable.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
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
    
    
    //=============================*** DELEGATE DATASOURCE METHODS ***===============================//
    
    //MARK :  Table View Delegate Methods:
    
    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                                                                "sectionHeader") as! HederCell
        view.titlelbl.text = sections[section]
        
        view.morebtn.addTarget(self, action:#selector(morebtnMethod), for: .touchUpInside)
        view.addbtn.addTarget(self, action:#selector(addbtnMethod), for: .touchUpInside)
        
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
            return organizationData.currOrganizationAdmins.count
        }
        else
        {
            return organizationData.currOrganizationMembers.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0
        {
            let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            cell.textLabel?.font = UIFont.init(name: "Apercu-Regular", size: 15)
            cell.textLabel?.textColor = .darkGray
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = Array(organizationData.currOrganizationAdmins.values)[indexPath.row]
            
            return cell
            
        }
        else
        {
            print(indexPath.row)
            let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            cell.backgroundColor = .clear
            cell.selectionStyle = .none
            
            cell.textLabel?.font = UIFont.init(name: "Apercu-Regular", size: 15)
            cell.textLabel?.textColor = .darkGray
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.text = Array(organizationData.currOrganizationMembers.values)[indexPath.row]
            
            return cell
        }

        
    }
    @objc func morebtnMethod(sender:UIButton)
    {
        print("more button clicked")
      
    }
    @objc func addbtnMethod(sender:UIButton)
    {
        print("add button clicked")
        
    }
    
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
        myCustomView.addSubview(moreImg)
        moreImg.image = UIImage.init(named: "more")
        moreImg.isUserInteractionEnabled = false
        
        let moreImgconstraints = [
            moreImg.rightAnchor.constraint(equalTo:myCustomView.rightAnchor, constant: -20),
            moreImg.heightAnchor.constraint(equalToConstant: 28),
            moreImg.widthAnchor.constraint(equalToConstant: 28),
            moreImg.centerYAnchor.constraint(equalTo:myCustomView.centerYAnchor, constant: 0)
        ]
        
        let addImg = UIImageView()
        myCustomView.addSubview(addImg)
        addImg.image = UIImage.init(named: "add")
        moreImg.isUserInteractionEnabled = false
        
        
        let addImgconstraints = [
            addImg.rightAnchor.constraint(equalTo:myCustomView.rightAnchor, constant: -70),
            addImg.heightAnchor.constraint(equalToConstant: 28),
            addImg.widthAnchor.constraint(equalToConstant: 28),
            addImg.centerYAnchor.constraint(equalTo:myCustomView.centerYAnchor, constant: 0)
        ]
        
        
        myCustomView.addSubview(morebtn)
        morebtn.backgroundColor = .clear
        
        let morebtnconstraints = [
            morebtn.rightAnchor.constraint(equalTo:myCustomView.rightAnchor, constant: -20),
            morebtn.heightAnchor.constraint(equalToConstant: 28),
            morebtn.widthAnchor.constraint(equalToConstant: 28),
            morebtn.centerYAnchor.constraint(equalTo:myCustomView.centerYAnchor, constant: 0)
        ]
        
        
        myCustomView.addSubview(addbtn)
        addbtn.backgroundColor = .clear
        
        let addbtnconstraints = [
            addbtn.rightAnchor.constraint(equalTo:myCustomView.rightAnchor, constant: -70),
            addbtn.heightAnchor.constraint(equalToConstant: 28),
            addbtn.widthAnchor.constraint(equalToConstant: 28),
            addbtn.centerYAnchor.constraint(equalTo:myCustomView.centerYAnchor, constant: 0)
        ]
        
        NSLayoutConstraint.activate(myCustomViewconstraints)
        NSLayoutConstraint.activate(titlelblconstraints)
        NSLayoutConstraint.activate(moreImgconstraints)
        NSLayoutConstraint.activate(addImgconstraints)
        NSLayoutConstraint.activate(morebtnconstraints)
        NSLayoutConstraint.activate(addbtnconstraints)
        
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


