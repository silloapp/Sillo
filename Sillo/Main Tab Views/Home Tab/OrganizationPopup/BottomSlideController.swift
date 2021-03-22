//
//  BottomSlideController.swift
//  WithoutStoryboard
//
//  Created by USER on 20/02/21.
//

import UIKit
import PullUpController

class BottomSlideController:PullUpController,UITableViewDelegate,UITableViewDataSource {
    
    enum InitialState {
        case contracted
        case expanded
    }
    
    var initialState: InitialState = .expanded
    var selectIndex = -1
    var visualEffectView = UIView()
    var mainView = UIView()
    var searchBoxContainerView = UIView()
    var searchSeparatorView = UIView()
    var firstPreviewView = UIView()
    var secondPreviewView = UIView()
    var tableView = UITableView()
    
    var initialPointOffset: CGFloat {
        switch initialState {
        
        case .contracted:
            print("contracted 1")
            
            return 0
            
        case .expanded:
            print("expanded 1")
            print("tableViewHeight",tableViewHeight)
            return tableViewHeight + 220
        }
        
        
    }
    
    public var portraitSize: CGSize = .zero
    public var landscapeFrame: CGRect = .zero
    
    private var safeAreaAdditionalOffset: CGFloat {
        hasSafeArea ? 20 : 0
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        portraitSize = CGSize(width: min(UIScreen.main.bounds.width, UIScreen.main.bounds.height),
                              height: 300)
        landscapeFrame = CGRect(x: 5, y: 50, width: 280, height: 300)
        
        tableView.attach(to: self)
        setupDataSource()
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfDismissNotification(notification:)), name: Notification.Name("DismissNotificationIdentifier"), object: nil)
        
    }
    
    @objc func methodOfDismissNotification(notification: Notification) {
        print("Value of notification : ", notification.object ?? "")
        dismiss()
    }
    
    func dismiss() {
        NotificationCenter.default.post(name: Notification.Name("HideBlurNotificationIdentifier"), object: nil)
        if let lastStickyPoint = pullUpControllerAllStickyPoints.last {
            pullUpControllerMoveToVisiblePoint(0, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tableView.reloadData()
        settingElemets()
    }
    
    //===================================*** SETTING CONSTRAINT ***=======================================//
    
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
        
        
        
        let searchBoxContainerViewconstraints = [
            searchBoxContainerView.topAnchor.constraint(equalTo:  self.mainView.safeAreaLayoutGuide.topAnchor, constant: 10),
            searchBoxContainerView.leftAnchor.constraint(equalTo: self.mainView.safeAreaLayoutGuide.leftAnchor, constant: 0),
            searchBoxContainerView.rightAnchor.constraint(equalTo: self.mainView.safeAreaLayoutGuide.rightAnchor, constant: 0),
            searchBoxContainerView.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        mainView.clipsToBounds = true
        mainView.layer.cornerRadius = 16
        mainView.layer.masksToBounds = true
        mainView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        searchSeparatorView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.5)
        searchSeparatorView.clipsToBounds = true
        searchSeparatorView.layer.cornerRadius = 4
        
        let searchSeparatorViewconstraints = [
            searchSeparatorView.centerXAnchor.constraint(equalTo:  self.view.centerXAnchor, constant: 0),
            searchSeparatorView.topAnchor.constraint(equalTo: self.searchBoxContainerView.safeAreaLayoutGuide.topAnchor, constant: 8),
            searchSeparatorView.widthAnchor.constraint(equalToConstant: 70),
            searchSeparatorView.heightAnchor.constraint(equalToConstant: 8)
        ]
        
        
        
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
        tableView.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
        
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
        // buttonPlus.setTitleColor(UIColor.init(red: 242/255, green: 244/255, blue: 244/255, alpha: 1), for: .normal)
        
        buttonPlus.setTitleColor(.lightGray, for: .normal)
        buttonPlus.alpha = 0.6
        buttonPlus.isUserInteractionEnabled = true
        
        let buttonPlusconstraints = [
            buttonPlus.topAnchor.constraint(equalTo:  self.tableView.safeAreaLayoutGuide.topAnchor, constant: 300),
            buttonPlus.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 25),
            buttonPlus.widthAnchor.constraint(equalToConstant: 60),
            buttonPlus.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        
        let bottomlbl = UIButton()
        
        self.secondPreviewView.addSubview(bottomlbl)
        buttonPlus.backgroundColor = .clear
        
        bottomlbl.setTitle("Add a space", for: .normal)
        bottomlbl.setTitleColor(.black, for: .normal)
        bottomlbl.titleLabel?.font = Font.bold(17)
        bottomlbl.titleLabel?.textAlignment = .left
        bottomlbl.addTarget(self, action: #selector(addNewSpaceClicked), for: .touchUpInside)
        
        let bottomlblconstraints = [
            bottomlbl.centerYAnchor.constraint(equalTo:  buttonPlus.centerYAnchor, constant: 0),
            bottomlbl.leftAnchor.constraint(equalTo: buttonPlus.rightAnchor, constant: 15),
            bottomlbl.heightAnchor.constraint(equalToConstant: 60)
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
        NSLayoutConstraint.activate(searchBoxContainerViewconstraints)
        NSLayoutConstraint.activate(firstPreviewViewconstraints)
        NSLayoutConstraint.activate(secondPreviewViewconstraints)
        NSLayoutConstraint.activate(tableViewconstraints)
        NSLayoutConstraint.activate(searchSeparatorViewconstraints)
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
        bottomlbl.translatesAutoresizingMaskIntoConstraints = false
        
    }
    
    @objc func addNewSpaceClicked() {
        let vc = WelcomeToSilloViewController()
        let navC = UINavigationController(rootViewController: vc)
        navC.modalPresentationStyle = .fullScreen
        self.present(navC,animated: true, completion:nil)
    }
    
    @objc func button1dismissMethod() {
        
        print("called action")
        
        dismiss()
        
    }
    @objc func button2dismissMethod() {
        
        print("called 2 action")
        dismiss()
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
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.selectionStyle = .none
        
        let organization = organizationData.organizationList[indexPath.row]
        let organizationName = organizationData.idToName[organization] ?? "My Organization"
        
        cell.labUserName.isHidden = false
        cell.imgUser2.isHidden = true
        
        
        cell.imgUser.layer.borderWidth = 3.5
        cell.imgUser.layer.borderColor = UIColor.gray.cgColor
        
        cell.labMessage.text = organizationName
        cell.labMessage.textColor = .black
        cell.labMessage.font = UIFont(name: "Apercu-Bold", size: 17)
        
        cell.labUserName.text = organizationName
        cell.labMessage.text = "" //nothing here
        cell.labMessage.font = UIFont(name: "Apercu-Regular", size: 15)
        
        if organization == organizationData.currOrganization
        {
            cell.bgView.backgroundColor = UIColor.init(red: 242/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
            cell.isUserInteractionEnabled = false
        }
        else
        {
            cell.bgView.backgroundColor = .clear
        }
        
        cell.Messageconstraints = [
            cell.labMessage.centerYAnchor.constraint(equalTo:  cell.contentView.centerYAnchor, constant: 13),
            cell.labMessage.leftAnchor.constraint(equalTo:  cell.imgUser2.leftAnchor, constant: 15),
            cell.labMessage.rightAnchor.constraint(equalTo:  cell.contentView.rightAnchor, constant: 20),
            cell.labMessage.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        cell.TITLEconstraints = [
            cell.labUserName.centerYAnchor.constraint(equalTo:  cell.contentView.centerYAnchor, constant: -10),
            cell.labUserName.leftAnchor.constraint(equalTo:  cell.imgUser2.leftAnchor, constant: 15),
            cell.labUserName.rightAnchor.constraint(equalTo:  cell.contentView.rightAnchor, constant: 20),
            cell.labUserName.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        
        
        NSLayoutConstraint.activate(cell.Messageconstraints)
        NSLayoutConstraint.activate(cell.TITLEconstraints)
        
        return cell
        
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView.reloadData()
        
        selectIndex = indexPath.row
        let nextOrganization = organizationData.organizationList[selectIndex]
        organizationData.changeOrganization(dest: nextOrganization)
        UserDefaults.standard.setValue(nextOrganization, forKey: "defaultOrganization")
        
        let nextVC = prepareTabVC()
        nextVC.modalPresentationStyle = .fullScreen
        
        let navC = UINavigationController(rootViewController: nextVC)
        navC.modalPresentationStyle = .fullScreen
        navC.modalTransitionStyle = .crossDissolve
        navC.setNavigationBarHidden(true, animated: false)
        self.present(navC, animated: true, completion: nil)
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        view.layer.cornerRadius = 12
    }
    
    override func pullUpControllerWillMove(to stickyPoint: CGFloat) {
        print("will move to \(stickyPoint)")
        
    }
    
    override func pullUpControllerDidMove(to stickyPoint: CGFloat) {
        print("did move to \(stickyPoint)")
    }
    
    override func pullUpControllerDidDrag(to point: CGFloat) {
        print("did drag to \(point)")
        
        if point > 0 {
            NotificationCenter.default.post(name: Notification.Name("ShowBlurNotificationIdentifier"), object: nil)
        }
        else {
            NotificationCenter.default.post(name: Notification.Name("HideBlurNotificationIdentifier"), object: nil)
        }
        
    }
    
    private func setupDataSource() {
        
    }
    
    // MARK: - PullUpController
    
    override var pullUpControllerPreferredSize: CGSize {
        return portraitSize
    }
    
    override var pullUpControllerPreferredLandscapeFrame: CGRect {
        return landscapeFrame
    }
    
    var tableViewHeight: CGFloat {
        tableView.layoutIfNeeded()
        
        return tableView.contentSize.height
    }
    
    override var pullUpControllerBounceOffset: CGFloat {
        return 20
    }
    
    override func pullUpControllerAnimate(action: PullUpController.Action,
                                          withDuration duration: TimeInterval,
                                          animations: @escaping () -> Void,
                                          completion: ((Bool) -> Void)?) {
        switch action {
        case .move:
            UIView.animate(withDuration: 0.3,
                           delay: 0,
                           usingSpringWithDamping: 0.7,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: animations,
                           completion: completion)
            
            
        default:
            UIView.animate(withDuration: 0.3,
                           animations: animations,
                           completion: completion)
        }
    }
    
}


extension BottomSlideController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if let lastStickyPoint = pullUpControllerAllStickyPoints.last {
            pullUpControllerMoveToVisiblePoint(lastStickyPoint, animated: true, completion: nil)
        }
    }
}


extension UIViewController {
    
    var hasSafeArea: Bool {
        guard
            #available(iOS 11.0, tvOS 11.0, *)
        else {
            return false
        }
        return UIApplication.shared.delegate?.window??.safeAreaInsets.top ?? 0 > 20
    }
    
}

extension UIView {
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}
