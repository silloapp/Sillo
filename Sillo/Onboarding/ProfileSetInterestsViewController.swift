//
//  ProfileSetInterestsViewController.swift
//  Sillo
//
//  Created by William Loo on 2/21/21.
//

import UIKit

class ProfileSetInterestsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    let maxInterestCount = 3 //maximum length of interests array
    var selectedInterests: [String] = [] //a list of interests
    var indexPathOfCellsSelected: [IndexPath] = [] //indices of table cells
    
    var interests = ["Art","Baking","Cooking","Dance","DIY","Fashion","Finance","Games","Meditation","Movies","Music","Outdoors","Photography","Reading","Sports","Tech","Travel","Volunteering"]
    
    var pretty_name_matching : [String:String] = ["art":"Art & Design","baking":"Baking","cooking":"Cooking","dance":"Dance","diy":"DIY","fashion":"Fashion","finance":"Finance","games":"Games","meditation":"Meditation","movies":"Movies & TV","music":"Music","outdoors":"Outdoors","photography":"Photography","reading":"Reading","sports":"Sports","tech":"Tech","travel":"Travel","volunteering":"Volunteering"]
    
    var selectedInterestCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    var interestCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout.init())
    
    //MARK: viewwillDissapear
    override func viewWillDisappear(_ animated: Bool) {
        let nextVC = self.navigationController?.topViewController as! ProfileEditViewController
        nextVC.interests = selectedInterests
    }
    
    //MARK: viewdidload
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        self.view.backgroundColor = .white
        
        let screenSize = UIScreen.main.bounds
        let screenWidth = screenSize.width
        
        
        //MARK: exit button
        let exitButton: UIButton = {
            let btn = UIButton()
            btn.setBackgroundImage(UIImage(named: "back"), for: .normal)
            btn.translatesAutoresizingMaskIntoConstraints = false
            return btn
        }()
        view.addSubview(exitButton)
        exitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        exitButton.addTarget(self, action: #selector(exitPressed(_:)), for: .touchUpInside)
        
        
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
        
        //MARK: selected interests collection view
        let selectedCollectionFlowLayout: UICollectionViewFlowLayout = {
            let first_layout = UICollectionViewFlowLayout()
            first_layout.minimumInteritemSpacing = 0
            first_layout.minimumLineSpacing = 40
            first_layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 20, right: 10)
            first_layout.itemSize = CGSize(width: screenWidth/4.5, height: screenWidth/4.5)
            return first_layout
        }()
        
        selectedInterestCollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: selectedCollectionFlowLayout)
        
        selectedInterestCollectionView.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "selectedInterestCell")
        selectedInterestCollectionView.delegate = self
        selectedInterestCollectionView.dataSource = self
        selectedInterestCollectionView.backgroundColor = UIColor.white
        selectedInterestCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(selectedInterestCollectionView)
        
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
        
        
        //MARK: prompt label constraints
        promptLabel.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true
        promptLabel.heightAnchor.constraint(equalToConstant: 70).isActive = true
        promptLabel.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: 20).isActive = true
        
        //MARK: constraints for selectedInterestCollectionView
        selectedInterestCollectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true
        selectedInterestCollectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.20).isActive = true
        selectedInterestCollectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        selectedInterestCollectionView.topAnchor.constraint(equalTo: promptLabel.topAnchor, constant: 100).isActive = true
        
        //MARK: prompt label constraint con't
        promptLabel.leftAnchor.constraint(equalTo: self.interestCollectionView.leftAnchor, constant: 10).isActive = true
        
        //MARK: constraints for interestCollectionView
        interestCollectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor, multiplier: 0.9).isActive = true
        interestCollectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor, multiplier: 0.5).isActive = true
        interestCollectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        interestCollectionView.topAnchor.constraint(equalTo: selectedInterestCollectionView.bottomAnchor, constant: 10).isActive = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == self.interestCollectionView) {
            return interests.count
        }
        if (collectionView == self.selectedInterestCollectionView) {
            //3 cells in collection at all times, the ones without content are set to neutral gray background.
            return maxInterestCount
        }
        return 0
    }
    //MARK: cellForItemAt
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        //MARK: generate selected interest cell
        if collectionView == self.selectedInterestCollectionView {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "selectedInterestCell", for: indexPath)
            //the foreach loop below clears the reusable cell, otherwise shitty shuffling occurs
            cell.subviews.forEach {subview in
                subview.removeFromSuperview()
            }
            
            let selectedInterestImage: UIImageView = {
                let imageView = UIImageView(frame: CGRect(x: 0,y: 0,width: 64,height: 64))
                imageView.contentMode = .scaleAspectFit
                imageView.translatesAutoresizingMaskIntoConstraints = false
                if (indexPath.item >= selectedInterests.count) {
                    //return placeholder
                    return imageView
                }
                imageView.image = UIImage(named: "\(selectedInterests[indexPath.item])")
                return imageView
            }()
            cell.addSubview(selectedInterestImage)
            selectedInterestImage.widthAnchor.constraint(equalTo: cell.widthAnchor, multiplier: 0.75).isActive = true
            selectedInterestImage.heightAnchor.constraint(equalTo: cell.heightAnchor, multiplier: 0.75).isActive = true
            selectedInterestImage.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
            selectedInterestImage.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
            
            //MARK: delete interest button
            if (indexPath.item < selectedInterests.count) {
                let deleteInterestButton: UIButton = {
                    let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
                    let image = UIImage(named: "delete_interest")
                    button.setImage(image,for: .normal)
                    button.contentMode = .scaleAspectFit
                    button.tag = indexPath.item
                    button.addTarget(self, action: #selector(deleteInterest), for: .touchUpInside)
                    button.translatesAutoresizingMaskIntoConstraints = false
                    return button
                }()
                
                cell.addSubview(deleteInterestButton)
                cell.bringSubviewToFront(deleteInterestButton)
                
                deleteInterestButton.topAnchor.constraint(equalTo: cell.topAnchor,constant: -10).isActive = true
                deleteInterestButton.rightAnchor.constraint(equalTo: cell.rightAnchor,constant: 5).isActive = true
            }
            
            let interestLabel : UILabel = {
                let label: UILabel = UILabel()
                label.textAlignment = .center
                label.font = Font.regular(dynamicFontSize(17))
                label.textColor = Color.navBlue
                //checks to see if index is within selectedInterests
                if (indexPath.item < selectedInterests.count) {
                    label.text = pretty_name_matching[selectedInterests[indexPath.item]]
                }
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
            

            //set color matteBlack is not a dummy cell, grey otherwise
            if (indexPath.item >= selectedInterests.count) {
                cell.backgroundColor = Color.russianDolphinGray
            }
            else {
                cell.backgroundColor = Color.matteBlack
                interestLabel.textColor = Color.matteBlack
            }
            
            return cell
        }
        
        //MARK: generate interest cell
        if (collectionView == self.interestCollectionView) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "interestCell", for: indexPath)
        //the foreach loop below clears the reusable cell, otherwise shitty shuffling occurs
        cell.subviews.forEach {subview in
            subview.removeFromSuperview()
        }
        let interestImage: UIImageView = {
            let imageView = UIImageView(frame: CGRect(x: 0,y: 0,width: 64,height: 64))
            imageView.image = UIImage(named: "\(interests[indexPath.item])")
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
            label.text = pretty_name_matching[interests[indexPath.item]]
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
        if (selectedInterests.contains(interests[indexPath.item]) && !indexPathOfCellsSelected.contains(indexPath)) {
            indexPathOfCellsSelected.append(indexPath)
            }
        if (indexPathOfCellsSelected.contains(indexPath)) {
            cell.backgroundColor = Color.matteBlack
            interestLabel.textColor = Color.matteBlack
        }
        else {
            cell.backgroundColor = Color.russianDolphinGray
        }
        
        return cell
        }
        return UICollectionViewCell() //this is an
    }
   
    //MARK: tapped an interest
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if (collectionView == self.interestCollectionView) {
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
        self.selectedInterestCollectionView.reloadData()
        }
    }
    
    @objc func deleteInterest(button:UIButton) {
        let index = button.tag //index
        selectedInterests.remove(at: index)
        indexPathOfCellsSelected.remove(at: index)
        self.selectedInterestCollectionView.reloadData()
        self.interestCollectionView.reloadData()
    }
    
    @objc func exitPressed(_:UIImage) {
        self.navigationController?.popViewController(animated: true)
        let nextVC = self.navigationController?.topViewController as! ProfileEditViewController
        nextVC.interests = selectedInterests
        
        
    }

}
