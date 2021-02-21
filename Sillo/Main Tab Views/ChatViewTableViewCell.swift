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
                //userName.text = name
                let stringValue: String = "\(name) · \(msg.timeSent ?? "")"
                let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
                attributedString.setColor(color: UIColor.lightGray, forText:"· \(msg.timeSent ?? "")")
                userName.attributedText = attributedString
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
        
        //set up profile picture
        addSubview(profilePic)
        profilePic.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22).isActive = true
        profilePic.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25).isActive = true
        profilePic.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profilePic.widthAnchor.constraint(equalToConstant: 50).isActive = true
         
        //stackview containing name/time and message
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(userName)
        stack.addArrangedSubview(message)
        contentView.addSubview(stack)
        
        //set up constraints
        userName.heightAnchor.constraint(equalToConstant: 15).isActive = true
        message.heightAnchor.constraint(equalToConstant: 18).isActive = true
        stack.leadingAnchor.constraint(equalTo: profilePic.trailingAnchor, constant: 16).isActive = true
        stack.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 250/375).isActive = true
        stack.topAnchor.constraint(equalTo: profilePic.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: profilePic.bottomAnchor).isActive = true
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

// An attributed string extension to achieve colors on text in label.
extension NSMutableAttributedString {
    func setColor(color: UIColor, forText stringValue: String) {
       let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
}
