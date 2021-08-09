//
//  OrganizationPickerViewController.swift
//  Sillo
//
//  Created by Eashan Mathur on 8/8/21.
//

import UIKit

class OrganizationPickerViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    
    var selectIndex = -1
    var visualEffectView = UIView()
    var mainView = UIView()
    var searchBoxContainerView = UIView()
    var searchSeparatorView = UIView()
    var firstPreviewView = UIView()
    var secondPreviewView = UIView()
    var tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }


    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        settingElemets()
    }

    func settingElemets() {
        
        // FOR SCROLL :
        
        self.view.addSubview(visualEffectView)
        visualEffectView.backgroundColor = .clear
        
        let visualEffectViewconstraints = [
            visualEffectView.topAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            visualEffectView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            visualEffectView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            visualEffectView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
            
        ]
        
        NSLayoutConstraint.activate(visualEffectViewconstraints)
        self.view.layoutIfNeeded()
        self.visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        
        self.visualEffectView.addSubview(mainView)
        
        let mainViewconstraints = [
            mainView.topAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            mainView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            mainView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            mainView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
        ]
        
        self.mainView.addSubview(searchBoxContainerView)
        self.mainView.backgroundColor = .white
        
        
        let button1dismiss = UIButton()
        
        self.mainView.addSubview(button1dismiss)
        button1dismiss.backgroundColor = .clear
        button1dismiss.setTitle("", for: .normal)
        button1dismiss.isUserInteractionEnabled = true
        
        let button1dismissconstraints = [
            button1dismiss.topAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            button1dismiss.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            button1dismiss.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            button1dismiss.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
        ]
        button1dismiss.addTarget(self, action:#selector(button1dismissMethod), for: .touchUpInside)
        
        
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = 16
        mainView.layer.masksToBounds = true
        mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        
        self.mainView.addSubview(firstPreviewView)
        
        let firstPreviewViewconstraints = [
            firstPreviewView.topAnchor.constraint(equalTo:  self.searchBoxContainerView.topAnchor, constant:20),
            firstPreviewView.leftAnchor.constraint(equalTo: self.mainView.safeAreaLayoutGuide.leftAnchor, constant: 0),
            firstPreviewView.rightAnchor.constraint(equalTo: self.mainView.safeAreaLayoutGuide.rightAnchor, constant: 0),
            firstPreviewView.heightAnchor.constraint(equalToConstant: 200)
        ]
        self.mainView.addSubview(secondPreviewView)
        
        let secondPreviewViewconstraints = [
            secondPreviewView.topAnchor.constraint(equalTo:  self.firstPreviewView.topAnchor, constant: 200),
            secondPreviewView.leftAnchor.constraint(equalTo: self.mainView.safeAreaLayoutGuide.leftAnchor, constant: 0),
            secondPreviewView.rightAnchor.constraint(equalTo: self.mainView.safeAreaLayoutGuide.rightAnchor, constant: 0),
            secondPreviewView.heightAnchor.constraint(equalToConstant: 400)
        ]
        
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        tableView.bounces = false
        tableView.register(OrganizationTableViewCell.self, forCellReuseIdentifier: "cell")
        
        self.mainView.addSubview(tableView)
        
        let tableViewconstraints = [
            tableView.topAnchor.constraint(equalTo:  self.searchBoxContainerView.safeAreaLayoutGuide.topAnchor, constant: 20),
            tableView.leftAnchor.constraint(equalTo: self.mainView.safeAreaLayoutGuide.leftAnchor, constant: 20),
            tableView.rightAnchor.constraint(equalTo: self.mainView.safeAreaLayoutGuide.rightAnchor, constant: -20),
            tableView.heightAnchor.constraint(equalToConstant: 300)
        ]
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        
        let buttonPlus = UIButton()
        
        self.secondPreviewView.addSubview(buttonPlus)
        buttonPlus.backgroundColor = .clear
        buttonPlus.setTitle("+", for: .normal)
        buttonPlus.titleLabel?.font = UIFont.init(name: "Apercu-Bold", size: 60)
        buttonPlus.addTarget(self, action: #selector(addNewSpaceClicked), for: .touchUpInside)
        buttonPlus.setTitleColor(hexStringToUIColor(hex: "E0E0E0"), for: .normal)
        buttonPlus.isUserInteractionEnabled = true
        
        let buttonPlusconstraints = [
            buttonPlus.topAnchor.constraint(equalTo:  self.tableView.bottomAnchor, constant: 5),
            buttonPlus.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 25),
            buttonPlus.widthAnchor.constraint(equalToConstant: 60),
            buttonPlus.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        
        let addSpaceButton = UIButton()
        
        self.secondPreviewView.addSubview(addSpaceButton)
        buttonPlus.backgroundColor = .clear
        
        addSpaceButton.setTitle("Add a space", for: .normal)
        addSpaceButton.setTitleColor(.black, for: .normal)
        addSpaceButton.titleLabel?.font = UIFont(name: "Apercu-Bold", size: 17)
        addSpaceButton.titleLabel?.textAlignment = .left
        addSpaceButton.addTarget(self, action: #selector(addNewSpaceClicked), for: .touchUpInside)
        
        let bottomlblconstraints = [
            addSpaceButton.centerYAnchor.constraint(equalTo:  buttonPlus.centerYAnchor, constant: 0),
            addSpaceButton.leftAnchor.constraint(equalTo: buttonPlus.rightAnchor, constant: 15),
            addSpaceButton.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        let button2dismiss = UIButton()
        
        self.view.addSubview(button2dismiss)
        button2dismiss.backgroundColor = .clear
        button2dismiss.setTitle("", for: .normal)
        
        self.searchBoxContainerView.addSubview(button2dismiss)
        button2dismiss.backgroundColor = .clear

        let button2dismissconstraints = [
            button2dismiss.centerXAnchor.constraint(equalTo:  self.view.centerXAnchor, constant: 0),
            button2dismiss.topAnchor.constraint(equalTo: self.searchBoxContainerView.safeAreaLayoutGuide.topAnchor, constant: 8),
            button2dismiss.widthAnchor.constraint(equalToConstant: 70),
            button2dismiss.heightAnchor.constraint(equalToConstant: 8)
        ]
        
        let seperatorlbl = UILabel()
        seperatorlbl.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        // seperatorlbl.clipsToBounds = true
        seperatorlbl.layer.cornerRadius = 4
        
        let seperatorlblconstraints = [
            seperatorlbl.centerXAnchor.constraint(equalTo:  self.view.centerXAnchor, constant: 0),
            seperatorlbl.topAnchor.constraint(equalTo: self.searchBoxContainerView.safeAreaLayoutGuide.topAnchor, constant: 8),
            seperatorlbl.widthAnchor.constraint(equalToConstant: 70),
            seperatorlbl.heightAnchor.constraint(equalToConstant: 8)
        ]
        
        self.searchBoxContainerView.addSubview(searchSeparatorView)
        
        button2dismiss.addTarget(self, action:#selector(button2dismissMethod), for: .touchUpInside)
        
        // NSLayoutConstraint.activate(visualEffectViewconstraints)
        NSLayoutConstraint.activate(mainViewconstraints)
//        NSLayoutConstraint.activate(searchBoxContainerViewconstraints)
        NSLayoutConstraint.activate(firstPreviewViewconstraints)
        NSLayoutConstraint.activate(secondPreviewViewconstraints)
        NSLayoutConstraint.activate(tableViewconstraints)
//        NSLayoutConstraint.activate(searchSeparatorViewconstraints)
        NSLayoutConstraint.activate(button1dismissconstraints)
        NSLayoutConstraint.activate(button2dismissconstraints)
        NSLayoutConstraint.activate(buttonPlusconstraints)
        NSLayoutConstraint.activate(bottomlblconstraints)
        
        self.view.layoutIfNeeded()
        
        //  self.visualEffectView.translatesAutoresizingMaskIntoConstraints = false
        self.searchBoxContainerView.translatesAutoresizingMaskIntoConstraints = false
        self.mainView.translatesAutoresizingMaskIntoConstraints = false
        self.firstPreviewView.translatesAutoresizingMaskIntoConstraints = false
        self.secondPreviewView.translatesAutoresizingMaskIntoConstraints = false
        self.tableView.translatesAutoresizingMaskIntoConstraints = false
        searchSeparatorView.translatesAutoresizingMaskIntoConstraints = false
        button1dismiss.translatesAutoresizingMaskIntoConstraints = false
        button2dismiss.translatesAutoresizingMaskIntoConstraints = false
        buttonPlus.translatesAutoresizingMaskIntoConstraints = false
        addSpaceButton.translatesAutoresizingMaskIntoConstraints = false
        
    }

    @objc func addNewSpaceClicked() {
        

        let nextVC = WelcomeToSilloViewController()
        let navC = UINavigationController(rootViewController: nextVC)
        navC.modalPresentationStyle = .fullScreen
        self.present(navC,animated: true, completion:nil)
    }

    @objc func button1dismissMethod() {
        
        print("called action")
        
//        dismiss()
        
    }
    @objc func button2dismissMethod() {
        
        print("called 2 action")
//        dismiss()
    }

    //=============================*** DELEGATE DATASOURCE METHODS ***===============================//

    // MARK: - Tableview methods:

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 95
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return organizationData.organizationList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! OrganizationTableViewCell
        cell.selectionStyle = .none
        
        let organization = organizationData.organizationList[indexPath.row]
        let organizationName = organizationData.idToName[organization] ?? "My Organization"
        let orgPicRef = "orgProfiles/\(organization)\(Constants.image_extension)" as NSString
        if imageCache.object(forKey: orgPicRef)?.image != nil { //image in cache
            let cachedImageItem = imageCache.object(forKey: orgPicRef)! //fetch from cache
            cell.orgImage.image = cachedImageItem.image
        }
        else {
            cloudutil.downloadImage(ref: orgPicRef as String)
            cell.orgImage.image = UIImage(named:"avatar-2")
        }
        
        
        cell.orgName.text = organizationName

        
        if organization == organizationData.currOrganization {
            cell.bcg.backgroundColor = UIColor.init(red: 242/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
            cell.isUserInteractionEnabled = false
        }
        else {
            cell.bcg.backgroundColor = .clear
        }
        

        return cell
        
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.reloadData()
        
        //haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.prepare()
        
        selectIndex = indexPath.row
        let nextOrganization = organizationData.organizationList[selectIndex]
        organizationData.changeOrganization(dest: nextOrganization)
        
        let nextVC = prepareTabVC()
        nextVC.modalPresentationStyle = .fullScreen
        
        let navC = UINavigationController(rootViewController: nextVC)
        navC.modalPresentationStyle = .fullScreen
        navC.modalTransitionStyle = .crossDissolve
        navC.setNavigationBarHidden(true, animated: false)
        self.present(navC, animated: true, completion: nil)
        generator.impactOccurred()
        
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.layer.cornerRadius = 12
    }

    
}
