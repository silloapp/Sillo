//
//  HomeVC.swift
//  WithoutStoryboard
//
//  Created by USER on 15/02/21.
//

import UIKit

@available(iOS 13.0, *)
class MyConnectionsVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    //MARK :IBDeclarations:
    var cameFrom = ""
    
    let screenSize = UIScreen.main.bounds
    
    var InfoStr = ["Information bubble text","here once the icon is","clicked."]
    
    let titleLabel = UILabel()
    let titleLabel2 = UILabel()
    let titleLabel3 = UILabel()
    // let scrollView = UIScrollView(frame: UIScreen.main.bounds)
    
    let scrollView = UIScrollView()
    let insideScrollVw = UIView()
    
    
    let DescLabel = UILabel()
    
    
    let infoButton = UIButton()
    let infoButton2 = UIButton()
    
    let Line1 = UILabel()
    let Line2 = UILabel()
    
    
    let TopTable = UITableView()
    let MidTable = UITableView()
    let BottomTable = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @objc func Addinfo(){
        NotificationCenter.default.post(name: Notification.Name("dismissAction"), object: nil)
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        settingElemets()
        setNavBar()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    func setNavBar()
    {
        
        self.title = "A title here"
        self.view.backgroundColor = ViewBgColor
        navigationController?.navigationBar.barTintColor = ViewBgColor
        navigationController?.navigationBar.isTranslucent = false
        
        let button = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "back"), for: .normal)
        button.addTarget(self, action:#selector(callMethod), for: .touchUpInside)
        button.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItems = [barButton]
        
    }
    @objc func callMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //===================================*** SETTING CONSTRAINT ***=======================================//
    
    
    func settingElemets()
    {
        
        // FOR SCROLL :
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.isUserInteractionEnabled = true
        insideScrollVw.isUserInteractionEnabled = true
        TopTable.isUserInteractionEnabled = true
        MidTable.isUserInteractionEnabled = true
        BottomTable.isUserInteractionEnabled = true
        scrollView.bounces = true
        TopTable.bounces = true
        MidTable.bounces = true
        BottomTable.bounces = true
        
        self.view.addSubview(scrollView)
        
        
        let scrollViewconstraints = [
            scrollView.topAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.topAnchor, constant: 0),
            scrollView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            scrollView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
            
        ]
        
        self.scrollView.addSubview(insideScrollVw)
        
        let screenWidth = screenSize.width
        
        
        let insideScrollViewconstraints = [
            insideScrollVw.topAnchor.constraint(equalTo:  self.scrollView.contentLayoutGuide.topAnchor, constant: 0),
            insideScrollVw.leftAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.leftAnchor, constant: 0),
            insideScrollVw.rightAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.rightAnchor, constant: 0),
            insideScrollVw.bottomAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.bottomAnchor, constant: 0),
            
            insideScrollVw.heightAnchor.constraint(equalToConstant: 1100),
            insideScrollVw.widthAnchor.constraint(equalToConstant: screenWidth)
            
        ]
        
        
        // FOR TITLE :
        
        self.insideScrollVw.addSubview(titleLabel)
        titleLabel.text = "A title here"
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = .black
        titleLabel.font = UIFont(name: "Apercu-Bold", size: 22)
        titleLabel.textAlignment = .left
        
        let TITLEconstraints = [
            titleLabel.topAnchor.constraint(equalTo:  self.insideScrollVw.safeAreaLayoutGuide.topAnchor, constant: 30),
            titleLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 30),
            titleLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 25),
            titleLabel.heightAnchor.constraint(equalToConstant: 25)
            
        ]
        
        // FOR INFO BUTTON :
        infoButton.backgroundColor = .clear
        self.insideScrollVw.addSubview(infoButton)
        infoButton.setImage(UIImage.init(named: "information"), for: .normal)
        
        let iNFOconstraints = [
            infoButton.topAnchor.constraint(equalTo:  titleLabel.topAnchor, constant: 0),
            infoButton.leftAnchor.constraint(equalTo:  titleLabel.leftAnchor, constant: 120),
            infoButton.heightAnchor.constraint(equalToConstant: 26),
            infoButton.widthAnchor.constraint(equalToConstant: 26)
        ]
        infoButton.addTarget(self, action: #selector(infoAction(_:)), for: .touchUpInside)
        
        
        // FOR LINE  :
        
        Line1.backgroundColor = themeBgColor
        self.insideScrollVw.addSubview(Line1)
        
        let line1constraints = [
            Line1.topAnchor.constraint(equalTo:  TopTable.topAnchor, constant: 320),
            Line1.leftAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            Line1.rightAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            Line1.heightAnchor.constraint(equalToConstant: 2),
        ]
        
        // FOR  TITLE2:
        
        self.insideScrollVw.addSubview(titleLabel2)
        titleLabel2.text = "Title here"
        titleLabel2.backgroundColor = .clear
        titleLabel2.textColor = .black
        titleLabel2.font = UIFont(name: "Apercu-Bold", size: 22)
        titleLabel2.textAlignment = .left
        
        let TITLE2constraints = [
            titleLabel2.topAnchor.constraint(equalTo:  self.Line1.topAnchor, constant: 20),
            titleLabel2.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor, constant: 0),
            titleLabel2.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor, constant: 0),
            titleLabel2.heightAnchor.constraint(equalToConstant: 25)
        ]
        
        // FOR INFO BUTTON 2:
        
        infoButton2.backgroundColor = .clear
        self.insideScrollVw.addSubview(infoButton2)
        infoButton2.setImage(UIImage.init(named: "information"), for: .normal)
        
        let iNFO2constraints = [
            infoButton2.topAnchor.constraint(equalTo:  titleLabel2.topAnchor, constant: 0),
            infoButton2.leftAnchor.constraint(equalTo:  titleLabel2.leftAnchor, constant: 110),
            infoButton2.heightAnchor.constraint(equalToConstant: 26),
            infoButton2.widthAnchor.constraint(equalToConstant: 26)
        ]
        
        infoButton2.addTarget(self, action: #selector(info2Action(_:)), for: .touchUpInside)
        
        
        
        // FOR  desclBL:
        
        self.insideScrollVw.addSubview(DescLabel)
        DescLabel.text = "Lorem ispum dollar lorem ispum dollar lorem ispum dollar lorem"
        DescLabel.backgroundColor = .clear
        DescLabel.textColor = .black
        DescLabel.font = UIFont(name: "Apercu-Medium", size: 17)
        DescLabel.textAlignment = .left
        DescLabel.numberOfLines = 0
        
        let DescConstraints = [
            DescLabel.topAnchor.constraint(equalTo:  self.infoButton2.topAnchor, constant: 30),
            DescLabel.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor, constant: 0),
            DescLabel.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor, constant: -25),
            DescLabel.heightAnchor.constraint(equalToConstant: 50)
        ]
        
        // FOR LINE2  :
        
        Line2.backgroundColor = themeBgColor
        self.insideScrollVw.addSubview(Line2)
        
        let line2constraints = [
            Line2.topAnchor.constraint(equalTo:  MidTable.topAnchor, constant: 280),
            Line2.leftAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            Line2.rightAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            Line2.heightAnchor.constraint(equalToConstant: 2),
        ]
        
        // FOR  TITLE3:
        
        self.insideScrollVw.addSubview(titleLabel3)
        titleLabel3.text = "A Title here"
        titleLabel3.backgroundColor = .clear
        titleLabel3.textColor = .black
        titleLabel3.font = UIFont(name: "Apercu-Bold", size: 22)
        titleLabel3.textAlignment = .left
        
        let TITLE3constraints = [
            titleLabel3.topAnchor.constraint(equalTo:  self.Line2.topAnchor, constant: 20),
            titleLabel3.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor, constant: 0),
            titleLabel3.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor, constant: 0),
            titleLabel3.heightAnchor.constraint(equalToConstant: 25)
        ]
        
        
        //------------------------------------ FOR TABLE VIEWS--------------------------------------------------//
        
        // FOR TOP TABLE  :
        
        TopTable.separatorStyle = .none
        TopTable.backgroundColor = .clear
        TopTable.register(ConnectionCell.self, forCellReuseIdentifier: "cell")
        
        let TopTableconstraints = [
            TopTable.topAnchor.constraint(equalTo:  infoButton.topAnchor, constant: 40),  TopTable.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0),
            TopTable.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -25),
            TopTable.heightAnchor.constraint(equalToConstant: 300)
        ]
        self.insideScrollVw.addSubview(TopTable)
        
        self.TopTable.delegate = self
        self.TopTable.dataSource = self
        
        // FOR Middle TABLE  :
        
        MidTable.separatorStyle = .none
        MidTable.backgroundColor = .clear
        MidTable.register(ConnectionCell.self, forCellReuseIdentifier: "cell")
        
        let MidTableconstraints = [
            MidTable.topAnchor.constraint(equalTo:  DescLabel.topAnchor, constant: 60),  MidTable.leftAnchor.constraint(equalTo: DescLabel.leftAnchor, constant: 0),
            MidTable.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -25),
            //   MidTable.bottomAnchor.constraint(equalTo: self.scrollView.safeAreaLayoutGuide.bottomAnchor, constant: -25),
            MidTable.heightAnchor.constraint(equalToConstant: 265)
        ]
        self.insideScrollVw.addSubview(MidTable)
        
        self.MidTable.delegate = self
        self.MidTable.dataSource = self
        
        
        // FOR Bottom TABLE  :
        
        BottomTable.separatorStyle = .none
        BottomTable.backgroundColor = .clear
        BottomTable.register(ConnectionCell.self, forCellReuseIdentifier: "cell")
        
        let BottomTableconstraints = [
            BottomTable.topAnchor.constraint(equalTo:  titleLabel3.topAnchor, constant: 40),  BottomTable.leftAnchor.constraint(equalTo: DescLabel.leftAnchor, constant: 0),
            BottomTable.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -25),
            BottomTable.bottomAnchor.constraint(equalTo: self.insideScrollVw.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            BottomTable.heightAnchor.constraint(equalToConstant: 300)
        ]
        self.insideScrollVw.addSubview(BottomTable)
        
        self.BottomTable.delegate = self
        self.BottomTable.dataSource = self
        
        
        
        
        
        // LAYOUT VIEW:
        
        NSLayoutConstraint.activate(scrollViewconstraints)
        NSLayoutConstraint.activate(insideScrollViewconstraints)
        
        
        NSLayoutConstraint.activate(TITLEconstraints)
        NSLayoutConstraint.activate(iNFOconstraints)
        NSLayoutConstraint.activate(TopTableconstraints)
        NSLayoutConstraint.activate(line1constraints)
        NSLayoutConstraint.activate(TITLE2constraints)
        NSLayoutConstraint.activate(iNFO2constraints)
        NSLayoutConstraint.activate(DescConstraints)
        NSLayoutConstraint.activate(MidTableconstraints)
        NSLayoutConstraint.activate(line2constraints)
        NSLayoutConstraint.activate(TITLE3constraints)
        NSLayoutConstraint.activate(BottomTableconstraints)
        
        self.view.layoutIfNeeded()
        
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        infoButton.translatesAutoresizingMaskIntoConstraints = false
        TopTable.translatesAutoresizingMaskIntoConstraints = false
        Line1.translatesAutoresizingMaskIntoConstraints = false
        titleLabel2.translatesAutoresizingMaskIntoConstraints = false
        infoButton2.translatesAutoresizingMaskIntoConstraints = false
        DescLabel.translatesAutoresizingMaskIntoConstraints = false
        MidTable.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        insideScrollVw.translatesAutoresizingMaskIntoConstraints = false
        Line2.translatesAutoresizingMaskIntoConstraints = false
        titleLabel3.translatesAutoresizingMaskIntoConstraints = false
        BottomTable.translatesAutoresizingMaskIntoConstraints = false
        
        
        
    }
    //=============================*** BUTTON ACTIONS ***===============================//
    
    @objc func infoAction(_ sender: UIButton) {
        var timer = Timer.scheduledTimer(timeInterval: 2, target: self,   selector: (#selector(Addinfo)), userInfo: nil, repeats: false)
        print("info")
        let controller = ArrayChoiceTableViewController(self.InfoStr, onSelect:  { (direction) in
            
        })
        controller.preferredContentSize = CGSize(width: 280, height: 80)
        showPopup(controller, sourceView: sender)
        
    }
    
    @objc func info2Action(_ sender: UIButton) {
        var timer = Timer.scheduledTimer(timeInterval: 2, target: self,   selector: (#selector(Addinfo)), userInfo: nil, repeats: false)
        print("info 2")
        let controller = ArrayChoiceTableViewController(self.InfoStr, onSelect:  { (direction) in
            
        })
        controller.preferredContentSize = CGSize(width: 280, height: 80)
        showPopup(controller, sourceView: sender)
        
    }
    
    private func showPopup(_ controller: UIViewController, sourceView: UIView) {
        let presentationController = AlwaysPresentAsPopover.configurePresentation(forController: controller)
        presentationController.sourceView = sourceView
        presentationController.sourceRect = sourceView.bounds
        presentationController.permittedArrowDirections = [.right, .left]
        self.present(controller, animated: true)
    }
    
    
    
    
    //=============================*** DELEGATE DATASOURCE METHODS ***===============================//
    
    //MARK :   Table View Delegate Methods:
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == BottomTable || tableView == MidTable
        {
            return 70
        }
        else
        {
            return 100
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == MidTable || tableView == TopTable
        {
            return 4
        }
        else
        {
            return 4
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ConnectionCell
        cell.selectionStyle = .none
        
        if tableView == MidTable
        {
            cell.bgView.backgroundColor = .clear
            cell.labUserName.isHidden = true
            cell.imgUser2.isHidden = true
            
            
            cell.labMessage.text = "Fist Name Last Name"
            
            cell.img1constraints = [
                cell.imgUser.centerYAnchor.constraint(equalTo:  cell.contentView.centerYAnchor, constant: 0),
                cell.imgUser.leftAnchor.constraint(equalTo:  cell.contentView.leftAnchor, constant: 5),
                cell.imgUser.widthAnchor.constraint(equalToConstant: 40),
                cell.imgUser.heightAnchor.constraint(equalToConstant: 40)
            ]
            
            cell.Messageconstraints = [
                cell.labMessage.centerYAnchor.constraint(equalTo:  cell.contentView.centerYAnchor, constant: 0),
                cell.labMessage.leftAnchor.constraint(equalTo:  cell.imgUser2.leftAnchor, constant: 0),
                cell.labMessage.rightAnchor.constraint(equalTo:  cell.contentView.rightAnchor, constant: 20),
                cell.labMessage.heightAnchor.constraint(equalToConstant: 20)
            ]
            
            NSLayoutConstraint.activate(cell.Messageconstraints)
            NSLayoutConstraint.activate(cell.img1constraints)
            
            cell.contentView.layoutIfNeeded()
            return cell
            
        }
        
        else if tableView == BottomTable
        {
            cell.bgView.backgroundColor = .clear
            cell.labUserName.isHidden = true
            cell.imgUser2.isHidden = true
            cell.imgUser.layer.cornerRadius = 0
            cell.imgUser.clipsToBounds = true
            
            cell.img1constraints = [
                cell.imgUser.centerYAnchor.constraint(equalTo:  cell.contentView.centerYAnchor, constant: 0),
                cell.imgUser.leftAnchor.constraint(equalTo:  cell.contentView.leftAnchor, constant: 5),
                cell.imgUser.widthAnchor.constraint(equalToConstant: 30),
                cell.imgUser.heightAnchor.constraint(equalToConstant: 30)
            ]
            
            if indexPath.row == 0
            {
                cell.imgUser.image = UIImage.init(named: "hand")
            }
            else if indexPath.row == 1
            {
                cell.imgUser.image = UIImage.init(named: "msg")
            }
            else if indexPath.row == 2 || indexPath.row == 4
            {
                cell.imgUser.image = UIImage.init(named: "ship")
            }
            
            cell.labMessage.text = "Lorem ispum dolar sit samee"
            
            cell.Messageconstraints = [
                cell.labMessage.centerYAnchor.constraint(equalTo:  cell.contentView.centerYAnchor, constant: 0),
                cell.labMessage.leftAnchor.constraint(equalTo:  cell.imgUser2.leftAnchor, constant: -12),
                cell.labMessage.rightAnchor.constraint(equalTo:  cell.contentView.rightAnchor, constant: 20),
                cell.labMessage.heightAnchor.constraint(equalToConstant: 20)
            ]
            
            NSLayoutConstraint.activate(cell.Messageconstraints)
            NSLayoutConstraint.activate(cell.img1constraints)
            
            cell.contentView.layoutIfNeeded()
            
            return cell
            
        }
        
        else
        {
            cell.labUserName.isHidden = false
            cell.imgUser2.isHidden = false
            
            cell.labUserName.text = "Full Name"
            cell.labMessage.text = "Level \(indexPath.row)"
            return cell
        }
        return cell
        
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select")
        
        
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
    
}
class ConnectionCell: UITableViewCell {
    
    let bgView = UIView()
    let imgUser = UIImageView()
    let imgUser2 = UIImageView()
    let checkImg = UIImageView()
    
    let labUserName = UILabel()
    let labMessage = UILabel()
    
    var TITLEconstraints = [NSLayoutConstraint]()
    var Messageconstraints = [NSLayoutConstraint]()
    var img1constraints = [NSLayoutConstraint]()
    var img2constraints = [NSLayoutConstraint]()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // FOR bg :
        
        contentView.addSubview(bgView)
        
        let bgOconstraints = [
            bgView.topAnchor.constraint(equalTo:  contentView.topAnchor, constant: 8),
            bgView.leftAnchor.constraint(equalTo:  contentView.leftAnchor, constant: 5),
            bgView.rightAnchor.constraint(equalTo:  contentView.rightAnchor, constant: -5),
            bgView.bottomAnchor.constraint(equalTo:  contentView.bottomAnchor, constant: -8),
            
        ]
        
        bgView.backgroundColor = hexStringToUIColor(hex: "#F2F4F4")
        bgView.layer.cornerRadius = 10
        bgView.clipsToBounds = true
        
        // for images :
        
        contentView.addSubview(imgUser)
        imgUser.image = UIImage.init(named: "profile")
        
        img1constraints = [
            imgUser.centerYAnchor.constraint(equalTo:  contentView.centerYAnchor, constant: 0),
            imgUser.leftAnchor.constraint(equalTo:  contentView.leftAnchor, constant: 15),
            imgUser.widthAnchor.constraint(equalToConstant: 40),
            imgUser.heightAnchor.constraint(equalToConstant: 40)
        ]
        imgUser.layer.cornerRadius = 20
        imgUser.clipsToBounds = true
        
        contentView.addSubview(imgUser2)
        imgUser2.image = UIImage.init(named: "smiley")
        
        img2constraints = [
            imgUser2.centerYAnchor.constraint(equalTo:  contentView.centerYAnchor, constant: 0),
            imgUser2.leftAnchor.constraint(equalTo:  contentView.leftAnchor, constant: 65),
            imgUser2.widthAnchor.constraint(equalToConstant: 40),
            imgUser2.heightAnchor.constraint(equalToConstant: 40)
        ]
        imgUser2.layer.cornerRadius = 20
        imgUser2.clipsToBounds = true
        
        // for checkmark :
        
        contentView.addSubview(checkImg)
        checkImg.image = UIImage.init(named: "check")
        
        let checkImgconstraints = [
            checkImg.centerYAnchor.constraint(equalTo:  contentView.centerYAnchor, constant: 0),
            checkImg.rightAnchor.constraint(equalTo:  contentView.rightAnchor, constant: -20),
            checkImg.widthAnchor.constraint(equalToConstant: 25),
            checkImg.heightAnchor.constraint(equalToConstant: 25)
        ]
        checkImg.isHidden = true
        
        
        
        
        // FOR LABELS :
        
        contentView.addSubview(labUserName)
        labUserName.text = "Full Name"
        labUserName.backgroundColor = .clear
        labUserName.textColor = .black
        labUserName.font = UIFont(name: "Apercu-Bold", size: 17)
        labUserName.textAlignment = .left
        
        TITLEconstraints = [
            labUserName.centerYAnchor.constraint(equalTo:  contentView.centerYAnchor, constant: -10),
            labUserName.leftAnchor.constraint(equalTo:  imgUser2.leftAnchor, constant: 70),
            labUserName.rightAnchor.constraint(equalTo:  contentView.rightAnchor, constant: 20),
            labUserName.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        contentView.addSubview(labMessage)
        labMessage.text = "Level 5"
        labMessage.backgroundColor = .clear
        labMessage.textColor = .black
        labMessage.font = UIFont(name: "Apercu-Regular", size: 12)
        labMessage.textAlignment = .left
        
        Messageconstraints = [
            labMessage.centerYAnchor.constraint(equalTo:  contentView.centerYAnchor, constant: 13),
            labMessage.leftAnchor.constraint(equalTo:  imgUser2.leftAnchor, constant: 70),
            labMessage.rightAnchor.constraint(equalTo:  contentView.rightAnchor, constant: 20),
            labMessage.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        
        
        // LAYOUT VIEW:
        
        NSLayoutConstraint.activate(bgOconstraints)
        NSLayoutConstraint.activate(img1constraints)
        NSLayoutConstraint.activate(img2constraints)
        NSLayoutConstraint.activate(TITLEconstraints)
        NSLayoutConstraint.activate(Messageconstraints)
        NSLayoutConstraint.activate(checkImgconstraints)
        
        bgView.translatesAutoresizingMaskIntoConstraints = false
        imgUser.translatesAutoresizingMaskIntoConstraints = false
        imgUser2.translatesAutoresizingMaskIntoConstraints = false
        labUserName.translatesAutoresizingMaskIntoConstraints = false
        labMessage.translatesAutoresizingMaskIntoConstraints = false
        checkImg.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.layoutIfNeeded()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
