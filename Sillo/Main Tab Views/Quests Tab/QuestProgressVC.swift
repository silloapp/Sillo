//
//  ProgressVC.swift
//  WithoutStoryboard
//
//  Created by USER on 19/02/21.
//

import UIKit

class QuestProgressVC: UIViewController,UITableViewDelegate,UITableViewDataSource {

//MARK :IBDeclarations:
    
    let scrollView = UIScrollView()
    let insideScrollVw = UIView()
    let TopTable = UITableView()
    let titleLabel = UILabel()
    
    let lockImage = UIImageView()
    let popupLbl = UILabel()
    
    let progressView = UIProgressView(progressViewStyle: .bar)
    var timer = Timer()
    
    let screenSize = UIScreen.main.bounds
    var imgsArr = [ "i93","i92","i91"]
    
    var StarsView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
    self.navigationController?.navigationBar.isHidden = false
        setNavBar()
        settingElemets()
    }
  
   func setNavBar()
  {
   
    self.view.backgroundColor = .white
    navigationController?.navigationBar.barTintColor = UIColor.init(red: 242/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
    navigationController?.navigationBar.isTranslucent = false
    self.title = "Lorem Ispum"

//Setting Buttons :
    
    let backbutton = UIButton(type: UIButton.ButtonType.custom)
    backbutton.setImage(UIImage(named: "i94"), for: .normal)
    backbutton.addTarget(self, action:#selector(callMethod), for: .touchUpInside)
    backbutton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    let barbackbutton = UIBarButtonItem(customView: backbutton)
    self.navigationItem.leftBarButtonItems = [barbackbutton]
    
    let Imagebutton = UIButton(type: UIButton.ButtonType.custom)
    Imagebutton.setImage(UIImage(named: "Nathan"), for: .normal)
    //Imagebutton.addTarget(self, action:#selector(callMethod), for: .touchUpInside)
    Imagebutton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
    Imagebutton.imageView?.contentMode = .scaleAspectFill
    Imagebutton.imageView?.borderWidth = 2
    Imagebutton.imageView?.borderColor = UIColor.init(red: 222/255.0, green: 222/255.0, blue: 222/255.0, alpha: 1)
    Imagebutton.imageView?.clipsToBounds = true
    Imagebutton.imageView?.layer.cornerRadius = 12
    
    let barImagebutton = UIBarButtonItem(customView: Imagebutton)
    self.navigationItem.rightBarButtonItems = [barImagebutton]
 
}
 //MARK : IBACTIONS:
    
    @objc func callMethod() {
        self.navigationController?.popViewController(animated: true)
     }
//===================================*** SETTING CONSTRAINT ***=======================================//
            
            func settingElemets()
            {
                // FOR TITLE :
                        
                         self.view.addSubview(titleLabel)
                        titleLabel.text = "Quest #2"
                        titleLabel.backgroundColor = .clear
                        titleLabel.textColor = themeColor
                        titleLabel.font = UIFont(name: "Apercu-Bold", size: 22)
                        titleLabel.textAlignment = .left
                        
                    let TITLEconstraints = [
                        titleLabel.topAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.topAnchor, constant: 25),
                        titleLabel.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 20),
                        titleLabel.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 25),
                        titleLabel.heightAnchor.constraint(equalToConstant: 25)

                        ]
        // FOR Progress view :
                        
                         self.view.addSubview(progressView)
                progressView.setProgress(0.1, animated: true)
                progressView.trackTintColor = .lightGray
                progressView.tintColor = themeColor
                        
                    let progressViewconstraints = [
                        progressView.topAnchor.constraint(equalTo:  self.titleLabel.safeAreaLayoutGuide.topAnchor, constant: 40),
                        progressView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
                        progressView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
                        progressView.heightAnchor.constraint(equalToConstant: 2)
                        ]
                
                timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(ProgressAnimate)), userInfo: nil, repeats: true)
                
                
        // FOR SCROLL :
               
                scrollView.showsVerticalScrollIndicator = false
                scrollView.showsHorizontalScrollIndicator = false
                scrollView.backgroundColor = .clear
                scrollView.isUserInteractionEnabled = true
                insideScrollVw.isUserInteractionEnabled = true
                scrollView.bounces = true
                
                self.view.addSubview(scrollView)
              
               
           let scrollViewconstraints = [
            scrollView.topAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.topAnchor, constant: 50),
            scrollView.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 0),
            scrollView.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: 0),
            scrollView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: 0),

               ]
                
                self.scrollView.addSubview(insideScrollVw)
                let screenWidth = screenSize.width
                insideScrollVw.backgroundColor = .clear

           let insideScrollViewconstraints = [
            insideScrollVw.topAnchor.constraint(equalTo:  self.scrollView.contentLayoutGuide.topAnchor, constant: 0),
            insideScrollVw.leftAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.leftAnchor, constant: 0),
            insideScrollVw.rightAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.rightAnchor, constant: 0),
            insideScrollVw.bottomAnchor.constraint(equalTo: self.scrollView.contentLayoutGuide.bottomAnchor, constant: 0),
            
            insideScrollVw.heightAnchor.constraint(equalToConstant: 800),
            insideScrollVw.widthAnchor.constraint(equalToConstant: screenWidth)

               ]
              
                
                self.insideScrollVw.addSubview(lockImage)
                lockImage.image = #imageLiteral(resourceName: "lock")
               
           let lockImageconstraints = [
            lockImage.topAnchor.constraint(equalTo:  self.TopTable.bottomAnchor, constant: 130),
            lockImage.rightAnchor.constraint(equalTo: self.TopTable.rightAnchor, constant: 0),
            lockImage.widthAnchor.constraint(equalToConstant: 100),
            lockImage.heightAnchor.constraint(equalToConstant: 100)
               ]
       
                self.insideScrollVw.addSubview(popupLbl)
                popupLbl.text = "Lorem Ipsum Dollar"
                popupLbl.backgroundColor = UIColor.init(red: 253/255.0, green: 243/255, blue: 223/255.0, alpha: 1)
                popupLbl.textColor = UIColor.init(red: 0/255.0, green: 51/255, blue: 66/255.0, alpha: 1)
                popupLbl.font = UIFont(name: "Apercu-Regular", size: 16)
                popupLbl.textAlignment = .center
                popupLbl.clipsToBounds = true
                popupLbl.layer.cornerRadius = 10
               
           let popupLblconstraints = [
            popupLbl.topAnchor.constraint(equalTo:  self.TopTable.bottomAnchor, constant: 50),
            popupLbl.leftAnchor.constraint(equalTo: self.TopTable.leftAnchor, constant: 10),
            popupLbl.widthAnchor.constraint(equalToConstant: 180),
            popupLbl.heightAnchor.constraint(equalToConstant: 50)
               ]
                popupLbl.isHidden = true
                
                
        self.view.addSubview(StarsView)
                let StarsViewconstraints = [
                    StarsView.topAnchor.constraint(equalTo:  self.TopTable.bottomAnchor, constant: 50),
                    StarsView.rightAnchor.constraint(equalTo: self.TopTable.rightAnchor, constant: 0),
                    StarsView.widthAnchor.constraint(equalToConstant: 70),
                    StarsView.heightAnchor.constraint(equalToConstant: 100)
                    ]
                StarsView.isHidden = true
                
              let imgStar1 = UIImageView()
                imgStar1.image = UIImage.init(named: "bgStar")
                self.StarsView.addSubview(imgStar1)
                 let imgStar1constraints = [
                    imgStar1.topAnchor.constraint(equalTo:  self.StarsView.topAnchor, constant: 0),
                    imgStar1.rightAnchor.constraint(equalTo: self.StarsView.rightAnchor, constant: -5),
                    imgStar1.widthAnchor.constraint(equalToConstant: 40),
                    imgStar1.heightAnchor.constraint(equalToConstant: 40)
                            ]
                let imgStar2 = UIImageView()
                imgStar2.image = UIImage.init(named: "litstar")
                  self.StarsView.addSubview(imgStar2)
                   let imgStar2constraints = [
                    imgStar2.topAnchor.constraint(equalTo:  imgStar1.topAnchor, constant: 40),
                    imgStar2.leftAnchor.constraint(equalTo: self.StarsView.leftAnchor, constant: 0),
                    imgStar2.widthAnchor.constraint(equalToConstant: 25),
                    imgStar2.heightAnchor.constraint(equalToConstant: 25)
                              ]
                
                let imgStar3 = UIImageView()
                imgStar3.image = UIImage.init(named: "bgStar")
                  self.StarsView.addSubview(imgStar3)
                   let imgStar3constraints = [
                    imgStar3.bottomAnchor.constraint(equalTo:  self.StarsView.bottomAnchor, constant: 0),
                    imgStar3.rightAnchor.constraint(equalTo: self.StarsView.rightAnchor, constant: 0),
                    imgStar3.widthAnchor.constraint(equalToConstant: 30),
                    imgStar3.heightAnchor.constraint(equalToConstant: 30)
                              ]
                
                
//------------------------------------ FOR TABLE VIEWS--------------------------------------------------//
                                    
            // FOR TOP TABLE  :

           TopTable.separatorStyle = .none
          TopTable.backgroundColor = .clear
        TopTable.bounces = true
          TopTable.register(CustomTableViewCell.self, forCellReuseIdentifier: "cell")
                                    
       let TopTableconstraints = [
        self.TopTable.topAnchor.constraint(equalTo:  self.view.safeAreaLayoutGuide.topAnchor, constant: 100),
        self.TopTable.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 15),
        self.TopTable.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -15),
        self.TopTable.heightAnchor.constraint(equalToConstant: 300)
             ]
             self.insideScrollVw.addSubview(TopTable)

              self.TopTable.delegate = self
           self.TopTable.dataSource = self
                            
                       
                 //-----------for aqctivating constraints:
                            
                            NSLayoutConstraint.activate(scrollViewconstraints)
                            NSLayoutConstraint.activate(insideScrollViewconstraints)
                NSLayoutConstraint.activate(TITLEconstraints)
                NSLayoutConstraint.activate(progressViewconstraints)
                            NSLayoutConstraint.activate(TopTableconstraints)
                NSLayoutConstraint.activate(lockImageconstraints)
                NSLayoutConstraint.activate(popupLblconstraints)
                
                NSLayoutConstraint.activate(StarsViewconstraints)
                NSLayoutConstraint.activate(imgStar1constraints)
                NSLayoutConstraint.activate(imgStar2constraints)
                NSLayoutConstraint.activate(imgStar3constraints)

                

                self.view.layoutIfNeeded()

                            self.scrollView.translatesAutoresizingMaskIntoConstraints = false
                            self.insideScrollVw.translatesAutoresizingMaskIntoConstraints = false
                            TopTable.translatesAutoresizingMaskIntoConstraints = false
                titleLabel.translatesAutoresizingMaskIntoConstraints = false
                progressView.translatesAutoresizingMaskIntoConstraints = false
                lockImage.translatesAutoresizingMaskIntoConstraints = false
                popupLbl.translatesAutoresizingMaskIntoConstraints = false
                StarsView.translatesAutoresizingMaskIntoConstraints = false
                imgStar1.translatesAutoresizingMaskIntoConstraints = false
                imgStar2.translatesAutoresizingMaskIntoConstraints = false
                imgStar3.translatesAutoresizingMaskIntoConstraints = false

                  
            }
    
  //MARK: For Progress Animation:
    
   
    
    @objc func ProgressAnimate(){

        progressView.progress += 0.1
                progressView.setProgress(progressView.progress, animated: true)
        self.TopTable.reloadData()

        let ProgressValue = Double(progressView.progress)
           print("ProgressValue","\(ProgressValue)")
     
     
                if(progressView.progress == 1.0)
                {
                    timer.invalidate()
                   
                }
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
          
            cell.bgView.backgroundColor = themeBgColor
            cell.labUserName.isHidden = false
            cell.imgUser2.isHidden = true


        
//            cell.imgUser.borderWidth = 3.5
//            cell.imgUser.borderColor = .gray
        cell.imgUser2.image = UIImage.init(named: "check")
        cell.labUserName.text = (["2/3","3/4","1/1"][indexPath.row] as! String)
        
        
            cell.labUserName.textColor = .black
            cell.labUserName.font = UIFont(name: "Apercu-Bold", size: 17)
        cell.labUserName.textAlignment = .right
    
            cell.labMessage.text = "Lorem Ispum dollar"
        cell.labMessage.textColor = UIColor.init(red: 0/255.0, green: 51/255, blue: 66/255.0, alpha: 1)
            cell.labMessage.font = UIFont(name: "Apercu-Bold", size: 17)
            
            cell.img1constraints = [
                cell.imgUser.centerYAnchor.constraint(equalTo:  cell.contentView.centerYAnchor, constant: 0),
                cell.imgUser.leftAnchor.constraint(equalTo:  cell.contentView.leftAnchor, constant: 30),
                cell.imgUser.widthAnchor.constraint(equalToConstant: 40),
                cell.imgUser.heightAnchor.constraint(equalToConstant: 40)
                ]
        
        cell.img2constraints = [
            cell.imgUser.centerYAnchor.constraint(equalTo:  cell.contentView.centerYAnchor, constant: 0),
            cell.imgUser.rightAnchor.constraint(equalTo:  cell.contentView.rightAnchor, constant: -30),
            cell.imgUser.widthAnchor.constraint(equalToConstant: 40),
            cell.imgUser.heightAnchor.constraint(equalToConstant: 40)
            ]
        
        
        cell.TITLEconstraints = [
            cell.labUserName.centerYAnchor.constraint(equalTo:  cell.contentView.centerYAnchor, constant: 0),
            cell.labUserName.leftAnchor.constraint(equalTo:  cell.contentView.leftAnchor, constant: 100),
            cell.labUserName.rightAnchor.constraint(equalTo:  cell.contentView.rightAnchor, constant: -20),
            cell.labUserName.heightAnchor.constraint(equalToConstant: 20)
            ]
        
            cell.Messageconstraints = [
                cell.labMessage.centerYAnchor.constraint(equalTo:  cell.contentView.centerYAnchor, constant: 0),
                cell.labMessage.leftAnchor.constraint(equalTo:  cell.imgUser2.leftAnchor, constant: 10),
                cell.labMessage.rightAnchor.constraint(equalTo:  cell.contentView.rightAnchor, constant: 20),
                cell.labMessage.heightAnchor.constraint(equalToConstant: 20)
                ]

          
            
            NSLayoutConstraint.activate(cell.Messageconstraints)
            NSLayoutConstraint.activate(cell.img1constraints)
        NSLayoutConstraint.activate(cell.TITLEconstraints)
        
            cell.contentView.layoutIfNeeded()
    
        
      //  cell.labUserName.isHidden = true
        
            // for ptogressView:
        
        let ProgressValue = Double(progressView.progress)
           print("ProgressValue","\(ProgressValue)")
        if ProgressValue >= 0.2
        {
            if indexPath.row == 0
            {
                cell.labUserName.isHidden = true
                cell.checkImg.isHidden = false
            }
            else
            {
                cell.labUserName.isHidden = false
                cell.checkImg.isHidden = true
            }
        }
        if ProgressValue >= 0.7000000476837158
        {
        if indexPath.row == 0 || indexPath.row == 1
            {
                cell.labUserName.isHidden = true
                cell.checkImg.isHidden = false
            }
            else
            {
                cell.labUserName.isHidden = false
                cell.checkImg.isHidden = true
            }
        }
        if ProgressValue == 1.0
        {
//        if indexPath.row == 0 || indexPath.row == 1
//            {
//                cell.labUserName.isHidden = false
//                cell.checkImg.isHidden = true
//            }
//            else
//            {
                cell.labUserName.isHidden = true
                cell.checkImg.isHidden = false
            
        
            StartFloatingStars()
            showPopupLbl()
            
           // }
        }
        
        
        cell.imgUser.image = UIImage.init(named: imgsArr[indexPath.row])
        
        
              
            return cell
        }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            print("did select")

        
        }
    
    
//=================================== *** SHOW ANIMATION *** ============================================//
    
 // MARK: - Opening lock with animation :
    
  func showPopupLbl()
  {
    UIView.transition(with: self.popupLbl,
                  duration: 0.25,
                   options: .transitionCrossDissolve,
                animations: { [weak self] in
                    self?.popupLbl.isHidden = false
             }, completion: nil)
  }
    func StartFloatingStars()
    {
       /* UIView.animate(withDuration: 0.6, delay: 0.1, options: [.autoreverse, .repeat], animations: { [self] in
            self.StarsView.frame = CGRect(x: self.StarsView.frame.origin.x, y: self.StarsView.frame.origin.y - 15, width: self.StarsView.frame.size.width, height: self.StarsView.frame.size.height)
            self.StarsView.isHidden = false
            self.lockImage.image = UIImage.init(named: "unlock")

        },completion: nil )*/
        
        self.timer = Timer.scheduledTimer(timeInterval: 0.5, target: self,   selector: (#selector(StarsAnimationStarts)), userInfo: nil, repeats: true)
    }
        @objc func StarsAnimationStarts()
      {
        //----------------- For  Bubble :
                
          let bubbleImageView = UIImageView(image: #imageLiteral(resourceName: "bgStar"))
                let size = randomFloatBetween(5, and: 30)
            bubbleImageView.frame = CGRect(x: ((lockImage.layer.presentation()?.frame.origin.x)!+80) , y: (lockImage.layer.presentation()?.frame.origin.y ?? 0) + 50, width: size, height: size)
                bubbleImageView.alpha = CGFloat(randomFloatBetween(0.1, and: 1))
                view.addSubview(bubbleImageView)
                
                let zigzagPath = UIBezierPath()
                let oX = bubbleImageView.frame.origin.x
                let oY = bubbleImageView.frame.origin.y
                let eX = oX
                let eY = oY - randomFloatBetween(50, and: 300)
                let t = randomFloatBetween(20, and: 100)
                let cp1 = CGPoint(x: oX - t, y: (oY + eY) / 2)
                let cp2 = CGPoint(x: oX + t, y: cp1.y)
                  
                zigzagPath.move(to: CGPoint(x: oX, y: oY))
                zigzagPath.addCurve(to: CGPoint(x: eX, y: eY), controlPoint1: cp1, controlPoint2: cp2)
                CATransaction.begin()
                CATransaction.setCompletionBlock({
                  
                    UIView.transition(
                        with: bubbleImageView,
                        duration: 0.1,
                        options: .transitionCrossDissolve,
                        animations: {
                            bubbleImageView.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
                        }) { finished in
                            bubbleImageView.removeFromSuperview()
                        }
                })
                
                let pathAnimation = CAKeyframeAnimation(keyPath: "position")
                pathAnimation.duration = 5
                pathAnimation.path = zigzagPath.cgPath
                pathAnimation.fillMode = .forwards
                pathAnimation.isRemovedOnCompletion = false
                bubbleImageView.layer.add(pathAnimation, forKey: "movingAnimation")
                CATransaction.commit()

                
    }
    
   
        
    func randomFloatBetween(_ smallNumber: CGFloat, and bigNumber: CGFloat) -> CGFloat {
        let diff = bigNumber - smallNumber
        let differnece = CGFloat(diff)
        let firstpart = CGFloat(arc4random() % (UInt32(RAND_MAX) + 1))
        let dividation = (firstpart) / CGFloat(RAND_MAX)
        let multiplication = (dividation * diff)
        return multiplication + smallNumber
      
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
