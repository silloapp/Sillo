//
//  ChatViewTableViewCell.swift
//  Sillo
//
//  Created by Angelica Pan on 2/21/21.
//

import UIKit

//these are the cells that will appear in the messages tab. each cell will represent one conversation / active chat
class ChatViewTableViewCell: UITableViewCell {
    let dateFormatter = DateFormatter()
    var item:ChatMetadata? {
        didSet {
            guard let msg = item else {return}
            var name = msg.recipient_name!
            profilePic.image = UIImage(named: msg.recipient_image ?? "avatar-4")
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a" //12 hr time
            dateFormatter.timeZone = TimeZone.current
            let timeStampString = dateFormatter.string(from: msg.latestMessageTimestamp!)

            //let stringValue: String = "\(name) · \(timeStampString)"
            let stringValue: String = "\(name)"
            let myAttribute = [ NSAttributedString.Key.font: Font.bold(17)]
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue, attributes: myAttribute)
            //let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
            attributedString.setColor(color: UIColor.lightGray, forText:"· \(timeStampString)")
            attributedString.setFont(font: Font.regular(17), forText: "· \(timeStampString)")
            userName.attributedText = attributedString
            
            timestamp.text = " · \(timeStampString)"
          
//            if let messageText = msg.latest_message {
//                message.text = messageText
//            }
            
            message.text = msg.latest_message!
            
            if !msg.isRead! {
                userName.font = Font.bold(17)
                message.font = Font.bold(15)
                message.textColor = Color.matte
                unreadAlert.backgroundColor = Color.burple
            } else {
                userName.font = Font.regular(17)
                message.font = Font.regular(15)
                message.textColor = UIColor.lightGray
                unreadAlert.backgroundColor = .none
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
        userName.font = Font.regular(17)
        userName.textColor = UIColor.black
        userName.translatesAutoresizingMaskIntoConstraints = false
        return userName
    }()
    
    let unreadAlert : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.burple
        view.layer.cornerRadius = 7
        return view
    }()
   
    let message:UILabel = {
        let message = UILabel()
        message.font = Font.regular(15)
        message.numberOfLines = 1
        message.textColor = UIColor.lightGray
        message.textAlignment = .left
        message.translatesAutoresizingMaskIntoConstraints = false
        message.sizeToFit()
        //message.layer.backgroundColor = UIColor.green.cgColor
        return message
    } ()
    
    let timestamp : UILabel = {
        let time = UILabel()
        time.font = Font.regular(15)
        time.textColor = UIColor.lightGray
        time.translatesAutoresizingMaskIntoConstraints = false
        //time.backgroundColor = UIColor.blue
        return time
    }()
   
    
   
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(profilePic)
        profilePic.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        profilePic.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 25).isActive = true
        profilePic.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profilePic.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        //stackview containing name and unread status
        let nameStack = UIStackView()
        nameStack.axis = .horizontal
        nameStack.spacing = 0
        nameStack.translatesAutoresizingMaskIntoConstraints = false
        nameStack.addArrangedSubview(userName)
        
        
        //stackview containing message and time
        let msgStack = UIStackView()
        msgStack.axis = .horizontal
        msgStack.spacing = 0
        msgStack.translatesAutoresizingMaskIntoConstraints = false
        msgStack.addArrangedSubview(message)
        msgStack.addArrangedSubview(timestamp)
        //msgStack.backgroundColor = UIColor.systemPink
        
        
        //stackview containing name/unread and message/time
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 0
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.addArrangedSubview(userName)
        stack.addArrangedSubview(msgStack)
        self.contentView.addSubview(stack)
        
        //set up constraints
        nameStack.heightAnchor.constraint(equalToConstant: 20).isActive = true
        userName.heightAnchor.constraint(equalToConstant: 18).isActive = true
        userName.widthAnchor.constraint(lessThanOrEqualToConstant: 180).isActive = true
        
        message.heightAnchor.constraint(equalToConstant: 18).isActive = true
        message.widthAnchor.constraint(lessThanOrEqualToConstant: 130).isActive = true
        msgStack.widthAnchor.constraint(lessThanOrEqualTo: self.contentView.widthAnchor).isActive = true
        
        timestamp.leadingAnchor.constraint(equalTo: message.trailingAnchor,constant: 5).isActive = true
        timestamp.widthAnchor.constraint(greaterThanOrEqualToConstant: 10).isActive = true
        
        stack.leadingAnchor.constraint(equalTo: self.profilePic.trailingAnchor, constant: 16).isActive = true
        stack.widthAnchor.constraint(lessThanOrEqualTo: self.contentView.widthAnchor).isActive = true
        stack.topAnchor.constraint(equalTo: self.profilePic.topAnchor).isActive = true
        stack.bottomAnchor.constraint(equalTo: self.profilePic.bottomAnchor).isActive = true
        
        
        self.contentView.addSubview(unreadAlert)
        unreadAlert.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        unreadAlert.heightAnchor.constraint(equalToConstant: 12).isActive = true
        unreadAlert.widthAnchor.constraint(equalToConstant: 12).isActive = true
        unreadAlert.trailingAnchor.constraint(equalTo: self.contentView.trailingAnchor, constant: -20).isActive = true
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
