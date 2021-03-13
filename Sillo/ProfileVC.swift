//
//  ProfileVC.swift
//  Sillo
//
//  Created by Angelica Pan on 3/4/21.
//

import UIKit

struct CustomData {
    var title: String
    var url: String
    var backgroundImage: UIImage
}

class ProfileVC: UIViewController{
    
    
    //TODO: replace this data with user data
    var name = "Kevin Nguyen"
    var pronouns = "He/Him"
    var bio = "I love the outdoors ⛰️ and fishing 🎣. Thinking of my next adventure ✨ "
    var interests = ["Art", "Baking", "Meditation"]
    var restaurants = [ "Asha Tea House", "Tamon Tea", "Urbann Turbann"]
    var profilePic = UIImage(named: "placeholder profile") //TODO: replace with profile pic
    
    var imageViewHeightConstraint: NSLayoutConstraint?
    
    //MARK: init exit button
    let exitButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "exit"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    //MARK: init anonymous profile picture
    let profilepic: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 50 // make circle
        return imageView
    }()
    
    //MARK: init name label
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1;
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = Font.bold(28)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    //MARK: init pronoun label
    let pronounLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1;
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = Font.medium(17)
        label.textColor = Color.clouds
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()

    //MARK: init bio label
    let bioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2;
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = Font.regular(17)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    //MARK: FIRST greyLine
    let greyLine:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1.0
        view.layer.borderColor = Color.clouds.cgColor
        return view
    }()
    
    //MARK: interest collectionview header label
    let collectionHeader: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1;
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = Font.bold(17)
        label.textColor = Color.matte
        label.text = "Interests"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    //MARK: interest collectionview
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .clear
        return cv
    }()
    
    //MARK: restaurant tableview
    
    let cellID = "cellID"
    let restoTable : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        table.separatorColor = .clear
        table.isScrollEnabled = false
        table.allowsSelection = false
        return table
    }()
    
    //MARK: greyLine
    let infoLine:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1.0
        view.layer.borderColor = Color.clouds.cgColor
        return view
    }()
            
    
    //MARK: infoIcon
    let infoIcon: UIImageView = {
        let image = UIImage(named: "info_icon_gray")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    //MARK: info
    let infoLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2;
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = Font.regular(14)
        label.textColor = Color.clouds
        label.text = "This is a preview of what other users will see once you have been revealed."
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .white
        
        //MARK: exitButton
        view.addSubview(exitButton)
        exitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        exitButton.addTarget(self, action: #selector(exitPressed(_:)), for: .touchUpInside)
        
        //MARK: profilepic
        profilepic.image = profilePic
        view.addSubview(profilepic)
        profilepic.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        profilepic.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: 25).isActive = true
        profilepic.widthAnchor.constraint(equalToConstant: 90).isActive = true
        profilepic.heightAnchor.constraint(equalToConstant: 90).isActive = true
        
        //MARK: add name and bio stack
        nameLabel.text = name
        pronounLabel.text = pronouns
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(nameLabel)
        stack.addArrangedSubview(pronounLabel)
        view.addSubview(stack)
        stack.leadingAnchor.constraint(equalTo: profilepic.trailingAnchor, constant: 28).isActive = true
        stack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        stack.centerYAnchor.constraint(equalTo: profilepic.centerYAnchor, constant: 0).isActive = true
      
        //MARK: bio label
        bioLabel.text = bio
        view.addSubview(bioLabel)
        bioLabel.topAnchor.constraint(equalTo: profilepic.bottomAnchor, constant: 20).isActive = true
        bioLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        bioLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        bioLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        //MARK: grey line under bio
        self.view.addSubview(greyLine)
        greyLine.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 20).isActive = true
        greyLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        greyLine.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        greyLine.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        //MARK: collectionview header label
        view.addSubview(collectionHeader)
        collectionHeader.heightAnchor.constraint(equalToConstant: 20).isActive = true
        collectionHeader.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 35).isActive = true
        collectionHeader.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        collectionHeader.topAnchor.constraint(equalTo: greyLine.bottomAnchor, constant: 20).isActive = true
        
        //MARK: interest collectionview
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.topAnchor.constraint(equalTo: collectionHeader.bottomAnchor, constant: 5).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        //MARK: restaurant tableview
        view.addSubview(restoTable)
        restoTable.delegate = self
        restoTable.dataSource = self
        restoTable.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 30).isActive = true
        restoTable.heightAnchor.constraint(equalToConstant: 240).isActive = true
        restoTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        restoTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        restoTable.register(GreyCell.self, forCellReuseIdentifier: cellID)
        
        //MARK: bottom grey line
        self.view.addSubview(infoLine)
        infoLine.topAnchor.constraint(equalTo: restoTable.bottomAnchor, constant: 20).isActive = true
        infoLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        infoLine.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        infoLine.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true

        //MARK: infoIcon
        view.addSubview(infoIcon)
        infoIcon.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        infoIcon.topAnchor.constraint(equalTo: infoLine.bottomAnchor, constant: 22).isActive = true
        infoIcon.widthAnchor.constraint(equalToConstant: 25).isActive = true
        infoIcon.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        //MARK: infoLabel
        view.addSubview(infoLabel)
        infoLabel.centerYAnchor.constraint(equalTo: infoIcon.centerYAnchor).isActive = true
        infoLabel.leadingAnchor.constraint(equalTo: infoIcon.trailingAnchor, constant: 16).isActive = true
        infoLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        infoLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
   
    //User pressed exit button
    @objc func exitPressed(_:UIImage) {
        self.dismiss(animated: true, completion: nil)
    }
}

//TABLEVIEW
extension ProfileVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurants.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! GreyCell
        cell.restaurantName = restaurants[indexPath.row]
        cell.separatorInset = UIEdgeInsets.zero
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
            let headerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: tableView.frame.width, height: 50))
        
            let label = UILabel()
            label.frame = CGRect.init(x: 5, y: 5, width: headerView.frame.width, height: headerView.frame.height-10)
            label.text = "Favourite Restaurants Nearby"
            label.font = Font.medium(17)
            label.textColor = UIColor.black
            headerView.addSubview(label)
            return headerView
        }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
            return 35
        }
}

class GreyCell: UITableViewCell {

    var restaurantName:String? {
        didSet {
            nameLabel.text = restaurantName        }
    }
    
    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true // this will make sure its children do not go out of the boundary
        view.layer.backgroundColor = Color.russiandolphin.cgColor
        view.layer.cornerRadius = 10
        return view
    }()
    
    let nameLabel:UILabel = {
        let label = UILabel()
        label.font = Font.regular(17)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        containerView.addSubview(nameLabel)
        self.contentView.addSubview(containerView)
        
       
        containerView.topAnchor.constraint(equalTo: self.contentView.topAnchor,constant: 8).isActive = true
        containerView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor,constant: -8).isActive = true
        containerView.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:5).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-5).isActive = true
        
        nameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant: 15).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

//COLLECTIONVIEW
extension ProfileVC: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        cell.data = self.interests[indexPath.item]
        return cell
    }
    
}


class CustomCell: UICollectionViewCell {
    
    var data: String? {
        didSet {
            guard let data = data else { return }
            if data != "NONE" {
                interestImage.image = UIImage(named: data)
                interestImage.backgroundColor = Color.matte
                label.text = data
            }
            else {
                //data is set to "NONE" when no interest is selected, and a blank cell is shown
                interestImage.image = UIImage()
                interestImage.backgroundColor = Color.russiandolphin
                label.text = ""
            }
        }
    }
    
    let interestImage: UIImageView = {
       let iv = UIImageView()
        iv.image = UIImage(named: "")
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        return iv
    }()
    
    let tile: UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        view.backgroundColor = Color.matte
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true
        return view
    }()
    
    let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1;
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = Font.regular(13)
        label.textColor = UIColor.black
        label.text = ""
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        contentView.addSubview(tile)
        tile.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        tile.heightAnchor.constraint(equalToConstant: 60).isActive = true
        tile.widthAnchor.constraint(equalToConstant: 60).isActive = true
        tile.centerXAnchor.constraint(equalTo: contentView.centerXAnchor, constant: 0).isActive = true
        
        tile.addSubview(interestImage)
        interestImage.heightAnchor.constraint(equalToConstant: 60).isActive = true
        interestImage.widthAnchor.constraint(equalToConstant: 60).isActive = true
        interestImage.centerXAnchor.constraint(equalTo: tile.centerXAnchor, constant: 0).isActive = true
        interestImage.centerYAnchor.constraint(equalTo: tile.centerYAnchor, constant: 0).isActive = true
        
        contentView.addSubview(label)
        label.topAnchor.constraint(equalTo: tile.bottomAnchor, constant: 5).isActive = true
        label.centerXAnchor.constraint(equalTo: tile.centerXAnchor, constant: 0).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
