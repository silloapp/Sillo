//
//  AddNewSpace.swift
//  WithoutStoryboard
//
//  Created by USER on 19/02/21.
//

import UIKit

@available(iOS 13.0, *)
class AddNewSpace: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    // MARK: - IBDeclarations :
    
    let scrollView = UIScrollView()
    let insideScrollVw = UIView()
    let titleLabel = UILabel()
    let screenSize = UIScreen.main.bounds
    let TopTable = UITableView()
    
    var selectedIndx = -1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.view.backgroundColor = ViewBgColor
        self.navigationController?.navigationBar.isHidden = true
        settingElemets()
    }
    
    //===================================*** SETTING CONSTRAINT ***=======================================//
    
    
    func settingElemets() {
        
        // FOR SCROLL :
        
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        
        scrollView.isUserInteractionEnabled = true
        insideScrollVw.isUserInteractionEnabled = true
        scrollView.bounces = true
        
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
            
            insideScrollVw.heightAnchor.constraint(equalToConstant: 800),
            insideScrollVw.widthAnchor.constraint(equalToConstant: screenWidth)
        ]
        
        // FOR TITLE :
        
        self.insideScrollVw.addSubview(titleLabel)
        titleLabel.text = "Welcome to Sillo"
        titleLabel.backgroundColor = .clear
        titleLabel.textColor = themeColor
        titleLabel.font = UIFont(name: "Apercu-Bold", size: 22)
        titleLabel.textAlignment = .left
        
        let TITLEconstraints = [
            titleLabel.topAnchor.constraint(equalTo:  self.insideScrollVw.safeAreaLayoutGuide.topAnchor, constant: 45),
            titleLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            titleLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 25),
            titleLabel.heightAnchor.constraint(equalToConstant: 25)
            
        ]
        
        // FOR secondTITLE :
        
        let sectitleLabel = UILabel()
        self.insideScrollVw.addSubview(sectitleLabel)
        sectitleLabel.text = "These are spaces you’ve been invited to. Select the spaces you would like to join. You can always sign in to more later."
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
            sectitleLabel.heightAnchor.constraint(equalToConstant: 50)
            
        ]
        
        // FOR BOTTOM TITLE :
        
        let bottomtitleLabel = UILabel()
        self.insideScrollVw.addSubview(bottomtitleLabel)
        bottomtitleLabel.text = "This a list of all your teams associated with berkeley@gmail.com."
        bottomtitleLabel.backgroundColor = .clear
        bottomtitleLabel.textColor = .black
        bottomtitleLabel.font = UIFont(name: "Apercu-Regular", size: 16)
        bottomtitleLabel.textAlignment = .left
        bottomtitleLabel.numberOfLines = 0
        bottomtitleLabel.lineBreakMode = .byWordWrapping
        
        let bottomtitleconstraints = [
            bottomtitleLabel.topAnchor.constraint(equalTo:  self.TopTable.safeAreaLayoutGuide.topAnchor, constant: 325),
            bottomtitleLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            bottomtitleLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -25),
            bottomtitleLabel.heightAnchor.constraint(equalToConstant: 50)
            
        ]
        
        // FOR BOTTOM secondTITLE :
        
        let bottomSectitleLabel = UILabel()
        self.insideScrollVw.addSubview(bottomSectitleLabel)
        bottomSectitleLabel.text = "Don’t see what you’re looking for? Make sure you’ve been invited by your team administrator."
        bottomSectitleLabel.backgroundColor = .clear
        bottomSectitleLabel.textColor = themeColor
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
        BottomButton.backgroundColor = themeColor
        BottomButton.setTitle("Create a Sillo space", for: .normal)
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
            TopTable.topAnchor.constraint(equalTo:  sectitleLabel.topAnchor, constant: 75),  TopTable.leftAnchor.constraint(equalTo: titleLabel.leftAnchor, constant: 0),
            TopTable.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -25),
            TopTable.heightAnchor.constraint(equalToConstant: 300)
        ]
        self.insideScrollVw.addSubview(TopTable)
        
        self.TopTable.delegate = self
        self.TopTable.dataSource = self
        
        
        
        //-----------for aqctivating constraints:
        
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
    
    @objc func BottomButtonMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    //=============================*** DELEGATE DATASOURCE METHODS ***===============================//
    
    //MARK :  Table View Delegate Methods:
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CustomTableViewCell
        cell.selectionStyle = .none
        
        
        cell.bgView.backgroundColor = hexStringToUIColor(hex: "#F2F4F4")
        cell.labUserName.isHidden = true
        cell.imgUser2.isHidden = true
        
        cell.imgUser.borderWidth = 3.5
        cell.imgUser.borderColor = .gray
        
        
        cell.labMessage.text = "Lorem Ispum dollar"
        cell.labMessage.textColor = .black
        cell.labMessage.font = UIFont(name: "Apercu-Bold", size: 17)
        
        cell.img1constraints = [
            cell.imgUser.centerYAnchor.constraint(equalTo:  cell.contentView.centerYAnchor, constant: 0),
            cell.imgUser.leftAnchor.constraint(equalTo:  cell.contentView.leftAnchor, constant: 30),
            cell.imgUser.widthAnchor.constraint(equalToConstant: 60),
            cell.imgUser.heightAnchor.constraint(equalToConstant: 60)
        ]
        
        cell.Messageconstraints = [
            cell.labMessage.centerYAnchor.constraint(equalTo:  cell.contentView.centerYAnchor, constant: 0),
            cell.labMessage.leftAnchor.constraint(equalTo:  cell.imgUser2.leftAnchor, constant: 10),
            cell.labMessage.rightAnchor.constraint(equalTo:  cell.contentView.rightAnchor, constant: 20),
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
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("did select")
        
        selectedIndx = indexPath.row
        self.TopTable.reloadData()
        
    }
}

extension UIView {
    func addTopShadow(shadowColor : UIColor, shadowOpacity : Float,shadowRadius : Float,offset:CGSize){
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.shadowOffset = offset
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowRadius = CGFloat(shadowRadius)
        self.clipsToBounds = false
    }
}
