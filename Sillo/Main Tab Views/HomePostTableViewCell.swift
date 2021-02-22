//
//  HomePostTableViewCell.swift
//  Sillo
//
//  Created by Angelica Pan on 2/22/21.
//

import UIKit

class HomePostTableViewCell: UITableViewCell {
    
    //set data to display within post cell
    var item:Post? {
        didSet {
            guard let msg = item else {return}
            if let name = msg.alias {
                let stringValue: String = "\(name) · \(msg.timeSent ?? "")"
                let myAttribute = [ NSAttributedString.Key.font: Font.bold(17)]
                let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue, attributes: myAttribute)
                attributedString.setColor(color: UIColor.lightGray, forText:"· \(msg.timeSent ?? "")")
                attributedString.setFont(font: Font.regular(17), forText: "· \(msg.timeSent ?? "")")
                userName.attributedText = attributedString
            }
            if let messageText = msg.message {
                message.text = messageText
            }
            
            if msg.profilePicture != nil {
                profilePic.image = msg.profilePicture
            }
        }
    }
    
    let profilePic: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let userName : UILabel = {
        let userName = UILabel()
        userName.font = Font.bold(17)
        userName.textColor = UIColor.black
        userName.translatesAutoresizingMaskIntoConstraints = false
        return userName
    }()
    
    let optionsButton: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Downward Arrow")
        imageView.frame = CGRect(x: 0, y: 0, width: 18, height: 10)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let message:UILabel = {
        let message = UILabel()
        message.font = Font.regular(15)
        message.numberOfLines = 0
        message.textColor = Color.message
        message.textAlignment = .left
        message.lineBreakMode = NSLineBreakMode.byWordWrapping
        message.sizeToFit()
        message.translatesAutoresizingMaskIntoConstraints = false
        return message
    } ()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //add profile pic
        self.contentView.addSubview(profilePic)
        profilePic.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 15).isActive = true
        profilePic.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 25).isActive = true
        profilePic.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profilePic.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        //add username and time
        self.contentView.addSubview(userName)
        userName.heightAnchor.constraint(equalToConstant: 18).isActive = true
        userName.leadingAnchor.constraint(equalTo: self.profilePic.trailingAnchor, constant: 16).isActive = true
        userName.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 250/375).isActive = true
        userName.topAnchor.constraint(equalTo: self.profilePic.topAnchor).isActive = true
        
        //add options button
        self.contentView.addSubview(optionsButton)
        optionsButton.heightAnchor.constraint(equalToConstant: 10).isActive = true
        optionsButton.trailingAnchor.constraint(equalTo: self.userName.trailingAnchor, constant: 0).isActive = true
        optionsButton.widthAnchor.constraint(equalToConstant: 18).isActive = true
        optionsButton.centerYAnchor.constraint(equalTo: self.userName.centerYAnchor).isActive = true
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(optionsTapped(tapGestureRecognizer:)))
        optionsButton.isUserInteractionEnabled = true
        optionsButton.addGestureRecognizer(tapGestureRecognizer)
        
        //add post content message
        self.contentView.addSubview(message)
        message.heightAnchor.constraint(greaterThanOrEqualToConstant: 18).isActive = true
        message.leadingAnchor.constraint(equalTo: self.profilePic.trailingAnchor, constant: 16).isActive = true
        message.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 250/375).isActive = true
        message.topAnchor.constraint(equalTo: self.userName.bottomAnchor, constant: 5).isActive = true
        message.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor, constant: -10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func optionsTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("Clicked on options! Time to bring up the small VC from the bottom.. ")
    }
}
