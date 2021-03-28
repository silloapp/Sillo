//
//  ChatViewTableViewCell.swift
//  Sillo
//
//  Created by Angelica Pan on 2/21/21.
//

import UIKit

class ChatViewTableViewCell: UITableViewCell {
    let dateFormatter = DateFormatter()
    // TODO: reformat the message below so that it uses chat to determine pfp
    // since we already stored the other party's image, we shouldn't have to store their pfp
    // for every message, since it is very inefficient
    // instead, compare the message sender id to the chat's recipient id and determine the pfp
    var item:Message? {
        didSet {
            guard let msg = item else {return}
            if let name = msg.name {
                //userName.text = name
                let timeSent = dateFormatter.string(from: msg.timestamp!)
                let stringValue: String = "\(name) · \(timeSent)"
                let myAttribute = [ NSAttributedString.Key.font: Font.bold(17)]
                let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue, attributes: myAttribute)
                //let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
                attributedString.setColor(color: UIColor.lightGray, forText:"· \(timeSent)")
                attributedString.setFont(font: Font.regular(17), forText: "· \(timeSent)")
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(profilePic)
        profilePic.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 22).isActive = true
        profilePic.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 25).isActive = true
        profilePic.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profilePic.widthAnchor.constraint(equalToConstant: 50).isActive = true
         
        //stackview containing name/time and message
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(userName)
        stack.addArrangedSubview(message)
        self.contentView.addSubview(stack)
        
        //set up constraints
        userName.heightAnchor.constraint(equalToConstant: 18).isActive = true
        message.heightAnchor.constraint(equalToConstant: 18).isActive = true
        stack.leadingAnchor.constraint(equalTo: self.profilePic.trailingAnchor, constant: 16).isActive = true
        stack.widthAnchor.constraint(equalTo: self.contentView.widthAnchor, multiplier: 250/375).isActive = true
        stack.topAnchor.constraint(equalTo: self.profilePic.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.profilePic.bottomAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

// An attributed string extension to achieve colors on text in label.
extension NSMutableAttributedString {
    func setColor(color: UIColor, forText stringValue: String) {
       let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: range)
    }
    
    func setFont(font: UIFont, forText stringValue: String) {
       let range: NSRange = self.mutableString.range(of: stringValue, options: .caseInsensitive)
        self.addAttribute(NSAttributedString.Key.font, value: font, range: range)
    }
}
