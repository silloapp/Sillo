//
//  SetInterestsViewController.swift
//  Sillo
//
//  Created by William Loo on 2/21/21.
//

import UIKit

class SetInterestsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var interests = ["art","baking","cooking","dance","diy","fashion","finance","games","meditation","movies","music","outdoors","photography","reading","sports","tech","travel","volunteering"]
    
    var interests_pretty_name = ["Art & Design","Baking","Cooking","Dance","DIY","Fashion","Finance","Games","Meditation","Movies & TV","Music","Outdoors","Photography","Reading","Sports","Tech","Travel","Volunteering"]
    
    var selectedInterestCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    var interestCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    //MARK: viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        self.view.backgroundColor = .white
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        //MARK: select three interests label
        let promptLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .left
            label.numberOfLines = 0
            label.font = Font.medium(dynamicFontSize(24))
            label.textColor = Color.buttonClickable
            label.text = "Select three interests to personalize your profile."
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        self.view.addSubview(promptLabel)
        promptLabel.widthAnchor.constraint(equalToConstant: 319).isActive = true
        promptLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        promptLabel.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        promptLabel.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 119).isActive = true
        
        //MARK: interest collection view
        let flowLayout: UICollectionViewFlowLayout = {
            let second_layout = UICollectionViewFlowLayout()
            second_layout.minimumInteritemSpacing = 0
            second_layout.minimumLineSpacing = 40
            second_layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10)
            second_layout.itemSize = CGSize(width: screenWidth/4.5, height: screenWidth/4.5)
            return second_layout
        }()
        
        interestCollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        
        interestCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "interestCell")
        interestCollectionView.delegate = self
        interestCollectionView.dataSource = self
        interestCollectionView.backgroundColor = UIColor.white
        interestCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(interestCollectionView)
        interestCollectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true
        interestCollectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.7).isActive = true
        interestCollectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        interestCollectionView.topAnchor.constraint(equalTo: promptLabel.topAnchor, constant: 119).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interests.count
    }
    //MARK: cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestCell", for: indexPath)
        
        //the foreach loop below clears the reusable cell, otherwise shitty shuffling occurs
        cell.subviews.forEach {subview in
            subview.removeFromSuperview()
        }
        
        let interestImage: UIImageView = {
            let imageView = UIImageView(frame: CGRect(x: 0,y: 0,width: 64,height: 64))
            print(interests[indexPath.item])
            imageView.image = UIImage(named: "interest_\(interests[indexPath.item])")
            imageView.contentMode = .scaleAspectFit
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        cell.addSubview(interestImage)
        interestImage.widthAnchor.constraint(equalTo: cell.widthAnchor, multiplier: 0.75).isActive = true
        interestImage.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 0.75).isActive = true
        interestImage.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        interestImage.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        
        let interestLabel : UILabel = {
            let label: UILabel = UILabel()
            label.textAlignment = .center
            label.font = Font.regular(dynamicFontSize(17))
            label.textColor = Color.navBlue
            label.text = interests_pretty_name[indexPath.item]
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        interestLabel.tag = 100
        cell.addSubview(interestLabel)
        interestLabel.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 0.7).isActive = true
        interestLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        interestLabel.topAnchor.constraint(equalTo: cell.bottomAnchor, constant: -20).isActive = true
        
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = false
        
        if (indexPathOfCellsSelected.contains(indexPath)) {
            cell.backgroundColor = Color.matteBlack
            interestLabel.textColor = Color.matteBlack
        }
        else {
            cell.backgroundColor = Color.russianDolphinGray
        }
        
        return cell
    }
    
    var selectedInterests: [String] = [] //a list of interests
    let maxInterestCount = 3 //maximum length of interests array
    var indexPathOfCellsSelected: [IndexPath] = [] //indices of table cells
    
    /*
    func submitButtonCheck() {
        if selectedInterests.count == 3 {
            UIView.animate(withDuration: 0.2) {
                self.continueButton.isUserInteractionEnabled = true
                self.continueButton.alpha = 1
            }
        } else {
            if selectedInterests.count == 2 {
                UIView.animate(withDuration: 0.2) {
                    self.continueButton.alpha = 0.62
                    self.continueButton.isUserInteractionEnabled = false
                }
            }
        }
    }
 */
   
    //MARK: tapped an interest
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let cell = collectionView.cellForItem(at: indexPath)
        
        //tapped item is in data structure, deselect
        if indexPathOfCellsSelected.contains(indexPath) {
            let index = indexPathOfCellsSelected.firstIndex(of: indexPath)
            indexPathOfCellsSelected.remove(at: index!)
            selectedInterests.remove(at: index!)
            
            cell?.backgroundColor = Color.russianDolphinGray
            let label = cell?.viewWithTag(100) as? UILabel
            label?.textColor = Color.russianDolphinGray
        }
        else {
            //tapped item is not yet in data structure, evict last item, and include tapped item.
            let interest = interests[indexPath.item]
            //evict last item
            if indexPathOfCellsSelected.count == maxInterestCount {
                _ = selectedInterests.popLast()
                let removed_index: IndexPath = indexPathOfCellsSelected.popLast()!
                let removed_cell = collectionView.cellForItem(at: removed_index)
                
                removed_cell?.backgroundColor = Color.russianDolphinGray
                let label = removed_cell?.viewWithTag(100) as? UILabel
                label?.textColor = Color.russianDolphinGray
            }
            //append tapped item to data structure
            selectedInterests.append(interest)
            indexPathOfCellsSelected.append(indexPath)
            
            cell?.backgroundColor = Color.matteBlack
            let label = cell?.viewWithTag(100) as? UILabel
            label?.textColor = Color.matteBlack
        }
        print(selectedInterests) //debug output, pls remove
    }
    
    @objc func nextClicked(_:UIButton) {
        
//        let doc = Constants.db.collection("organizations").document()
//        DispatchQueue.main.async {
//            doc.getDocument() { (query, err) in
//                if let query = query, query.exists {
//
//                    let prompts = query.get("capacity") as! [String: String]
//
//                    for prompt in prompts.values {
//                        print(prompt)
//                    }
//
//                } else {
//                    print("Error retrieving prompts from org")
//                }
//            }
//        }
/*
        Constants.db.collection("profiles").document(Constants.FIREBASE_USERID).setData([
            "interest1": selectedInterests[0] ,
            "interest2": selectedInterests[1] ,
            "interest3": selectedInterests[2] ,
        ]) { err in
            if err != nil {
                print("error adding user info")
            } else {
                print("successfully added user info")
            }
        }
    
        //if user hasn't seen onboarding yet, show onboarding (for example if you signed out and sign back in, you shouldn't see the onboarding again.)
        if Core.shared.isNewUser() {
            let vc = self.storyboard?.instantiateViewController(identifier: "welcome") as! WelcomeViewController
            vc.modalPresentationStyle = .fullScreen
            self.present(vc, animated: true)
        } else {
            //signed in? seen onboarding before? OFF TO THE ORG LIST
            performSegue(withIdentifier: "interestToOrgSegue", sender: nil)
        }
         */
    }

}
