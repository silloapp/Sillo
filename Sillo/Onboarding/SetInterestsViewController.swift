//
//  SetInterestsViewController.swift
//  Sillo
//
//  Created by William Loo on 2/21/21.
//

import UIKit

class SetInterestsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    //final
    var interests = ["art","baking","cooking","dance","diy","fashion","finance","games","meditation","movies","music","outdoors","photography","reading","sports","tech","travel","volunteering"]
    
    var interests_pretty_name = ["Art & Design","Baking","Cooking","dance","diy","fashion","Finance","games","meditation","Movies & TV","music","outdoors","photography","reading","sports","tech","travel","volunteering"]
    
    var interestCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
            
        //MARK: interest collection view
        let flowLayout: UICollectionViewFlowLayout = {
            let screenSize = UIScreen.main.bounds
            let screenWidth = screenSize.width
            let screenHeight = screenSize.height
            let layout = UICollectionViewFlowLayout()
            layout.minimumInteritemSpacing = 0
            layout.minimumLineSpacing = 40
            layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
            layout.itemSize = CGSize(width: screenWidth/3.5, height: screenWidth/3.5)
            return layout
        }()
        
        interestCollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: flowLayout)
        
        interestCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "interestCell")
        interestCollectionView.delegate = self
        interestCollectionView.dataSource = self
        interestCollectionView.backgroundColor = UIColor.white
        
        
        //let largeConfig = UIImage.SymbolConfiguration(pointSize: 35, weight: .bold, scale: .medium)
        self.view.addSubview(interestCollectionView)
        interestCollectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.7).isActive = true
        interestCollectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.7).isActive = true
        interestCollectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        interestCollectionView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return interests.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestCell", for: indexPath)
        
        let interestImage: UIImageView = {
            let image = UIImage(named: "interest_\(interests[indexPath.item])")
            let imageView = UIImageView(image: image)
            imageView.contentMode = .center
            imageView.translatesAutoresizingMaskIntoConstraints = false
            return imageView
        }()
        cell.addSubview(interestImage)
        interestImage.widthAnchor.constraint(equalTo: cell.widthAnchor, multiplier: 0.5).isActive = true
        interestImage.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 0.5).isActive = true
        interestImage.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        interestImage.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        
        let interestLabel: UILabel = {
            let label = UILabel()
            label.textAlignment = .left
            label.font = Font.regular(dynamicFontSize(17))
            label.text = interests_pretty_name[indexPath.item]
            label.translatesAutoresizingMaskIntoConstraints = false
            return label
        }()
        cell.addSubview(interestLabel)
        interestLabel.widthAnchor.constraint(equalTo: cell.widthAnchor, multiplier: 0.7).isActive = true
        interestLabel.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        interestLabel.centerYAnchor.constraint(equalTo: cell.centerYAnchor, constant: 50).isActive = true
        
        
        cell.layer.backgroundColor = Color.russianDolphinGray.cgColor
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        //return cell ?? collectionView.dequeueReusableCell(withReuseIdentifier: "interestCell", for: indexPath)
        return cell
    }
    
    var selectedInterests: [String] = [] //a list of interests
    let maxInterestCount = 3 //maximum length of interests array
    var indexOfCellsSelected: [IndexPath] = [] //indices of table cells
    
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
        if indexOfCellsSelected.contains(indexPath) {
            let index = indexOfCellsSelected.firstIndex(of: indexPath)
            indexOfCellsSelected.remove(at: index!)
            selectedInterests.remove(at: index!)
            cell?.backgroundColor = Color.russianDolphinGray
        }
        else {
            //tapped item is not yet in data structure, evict last item, and include tapped item.
            let interest = interests[indexPath.item]
            //evict last item
            if indexOfCellsSelected.count == maxInterestCount {
                _ = selectedInterests.popLast()
                let removed_index: IndexPath = indexOfCellsSelected.popLast()!
                let removed_cell = collectionView.cellForItem(at: removed_index)
                removed_cell?.backgroundColor = Color.russianDolphinGray
            }
            //append tapped item to data structure
            selectedInterests.append(interest)
            indexOfCellsSelected.append(indexPath)
            cell?.layer.backgroundColor = Color.matteBlack.cgColor
            cell?.backgroundColor = Color.matteBlack
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
