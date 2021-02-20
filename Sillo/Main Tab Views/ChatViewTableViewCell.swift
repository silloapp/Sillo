//
//  ChatViewTableViewCell.swift
//  Sillo
//
//  Created by Angelica Pan on 2/21/21.
//

import UIKit

class ChatViewTableViewCell: UITableViewCell {
    
    var item:Message? {
        didSet {
            guard let msg = item else {return}
            if let name = msg.name {
                userName.text = name
            }
            if let messageText = msg.message {
                message.text = messageText
            }
            if !msg.isRead! {
                message.font = Font.bold(15)
            }
            if msg.profilePicture != nil {
                profilePic.image = msg.profilePicture
            }
            if let timesent = msg.timeSent {
                time.text = timesent
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
        userName.textColor = Color.textSemiBlack
        userName.translatesAutoresizingMaskIntoConstraints = false
        return userName
    }()
    
    let time : UILabel = {
        let time = UILabel()
        time.font = Font.regular(17)
        time.textColor = .lightGray
        time.translatesAutoresizingMaskIntoConstraints = false
        return time
    } ()
    
    let message:UILabel = {
        let message = UILabel()
        message.font = Font.regular(15)
        message.numberOfLines = 1
        message.textColor = Color.message
        message.textAlignment = .left
        message.translatesAutoresizingMaskIntoConstraints = false
        message.sizeToFit()
        return message
    } ()
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupView() {
        
        addSubview(profilePic)
        profilePic.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22).isActive = true
        profilePic.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25).isActive = true
      
        //stack holding the name and time
        let nameTimeStack = UIStackView()
        nameTimeStack.axis = .horizontal
        nameTimeStack.alignment = .leading
        nameTimeStack.spacing = 0
        nameTimeStack.addArrangedSubview(userName)
        nameTimeStack.addArrangedSubview(time)
        
        //overarching message stack
        let nameTimeMessageStack = UIStackView()
        nameTimeMessageStack.axis = .vertical
        nameTimeMessageStack.spacing = 0
        nameTimeMessageStack.translatesAutoresizingMaskIntoConstraints = false
        nameTimeMessageStack.addArrangedSubview(nameTimeStack)
        nameTimeMessageStack.addArrangedSubview(message)
        contentView.addSubview(nameTimeMessageStack)
        nameTimeMessageStack.leadingAnchor.constraint(equalTo: profilePic.trailingAnchor, constant: 16).isActive = true
        nameTimeMessageStack.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 250/375).isActive = true
        nameTimeMessageStack.topAnchor.constraint(equalTo: profilePic.topAnchor).isActive = true
        nameTimeMessageStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        
        
    }
    
    override func layoutSubviews() {
        contentView.backgroundColor = .clear
        backgroundColor = .clear
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        setupView()
    }

}
