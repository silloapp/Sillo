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
    
    var initialState: InitialState = .contracted
    var selectIndex = -1
    var visualEffectView = UIView()
    var mainView = UIView()
    var searchBoxContainerView = UIView()
    var searchSeparatorView = UIView()
    //{
    //        didSet {
    //           // searchSeparatorView.layer.cornerRadius = 4
    //        }
    //    }
    var firstPreviewView = UIView()
    var secondPreviewView = UIView()
    var tableView = UITableView()
    
    var initialPointOffset: CGFloat {
        switch initialState {
        //        case .contracted:
        //        return 150
        //
        //        case .expanded:
        //      return 600
        //
        
        case .contracted:
            print("contracted 1")
            
            return 120
            
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
    func dismiss()
    {
        
        NotificationCenter.default.post(name: Notification.Name("HideBlurNotificationIdentifier"), object: nil)
        // dismiss(animated: true, completion: nil)
        if let lastStickyPoint = pullUpControllerAllStickyPoints.last {
            pullUpControllerMoveToVisiblePoint(120, animated: true, completion: nil)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        print("bottom popup appeared")
        settingElemets()
    }
    
    //===================================*** SETTING CONSTRAINT ***=======================================//
    
    func settingElemets()
    {
        
        // FOR SCROLL :
        
        self.view.addSubview(visualEffectView)
        visualEffectView.backgroundColor = .clear
        
        let visualEffectViewconstraints = [
            visualEffectView.topAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            visualEffectView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            visualEffectView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            visualEffectView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0)
            
        ]
        //  visualEffectView.backgroundColor = UIColor.darkGray.withAlphaComponent(0.7)
        
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
        //              button2dismiss.clipsToBounds = true
        //              button2dismiss.layer.cornerRadius = 0
        
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
        
        //  button1dismiss.isUserInteractionEnabled = false
        //   button1dismiss.addTarget(self, action:#selector(button1dismissMethod), for: .touchUpInside)
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
        let vc = AddNewSpace()
        self.navigationController?.pushViewController(vc, animated: true)
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
        
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.selectionStyle = .none
        
        
        cell.labUserName.isHidden = false
        cell.imgUser2.isHidden = true
        
        
        cell.imgUser.layer.borderWidth = 3.5
        cell.imgUser.layer.borderColor = UIColor.gray.cgColor
        
        
        cell.labMessage.text = "Lorem Ispum dollar"
        cell.labMessage.textColor = .black
        cell.labMessage.font = UIFont(name: "Apercu-Bold", size: 17)
        
        cell.labUserName.text = "Lorem Ipsum"
        cell.labMessage.text = "3 Messages"
        cell.labMessage.font = UIFont(name: "Apercu-Regular", size: 15)
        
        if selectIndex == indexPath.row
        {
            cell.bgView.backgroundColor = UIColor.init(red: 242/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
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
        print("did select")
        
        selectIndex = indexPath.row
        self.tableView.reloadData()
        
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
        
        if point > 120.0
        {
            NotificationCenter.default.post(name: Notification.Name("ShowBlurNotificationIdentifier"), object: nil)
            //  self.mainView.isUserInteractionEnabled = false
        }
        else
        {
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
    
    override var pullUpControllerMiddleStickyPoints: [CGFloat] {
        
        
        // print(self.pullUpControllerMiddleStickyPoints)
        
        switch initialState {
        
        case .contracted:
            
            print("contracted")
            
            //  return [firstPreviewView.frame.maxY]
            
            // return [250,250]
            if UserDefaults.standard.bool(forKey: "didmissPuppup") == true
            {
                return [120, 120]
            }
            else
            {
                return [tableViewHeight + 220,tableViewHeight + 220]
            }
            
        case .expanded:
            print("expanded")
            
            return [searchBoxContainerView.frame.maxY + safeAreaAdditionalOffset, firstPreviewView.frame.maxY]
            
        /*  if UserDefaults.standard.bool(forKey: "didmissPuppup") == true
         {
         return [120,tableViewHeight + 120]
         }
         else
         {
         return [tableViewHeight + 220,tableViewHeight + 220]
         }*/
        
        
        
        
        }
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

// MARK: - UISearchBarDelegate

extension BottomSlideController: UISearchBarDelegate {
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if let lastStickyPoint = pullUpControllerAllStickyPoints.last {
            pullUpControllerMoveToVisiblePoint(lastStickyPoint, animated: true, completion: nil)
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
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
