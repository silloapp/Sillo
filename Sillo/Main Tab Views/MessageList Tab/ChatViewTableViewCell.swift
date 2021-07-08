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
            if msg.isRevealed! { //TODO: use person's profile pic
                let imageRef:NSString = "profiles/\(msg.recipient_uid!)\(Constants.image_extension)" as NSString
                if imageCache.object(forKey: imageRef) != nil {
                    let cachedImage = imageCache.object(forKey: imageRef)
                    profilePic.image =  cachedImage
                }
                else {
                    profilePic.image =  cloudutil.downloadImage(ref: imageRef as String)
                }
            }
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "h:mm a" //12 hr time
//            dateFormatter.timeZone = TimeZone.current
//            let timeStampString = dateFormatter.string(from: msg.latestMessageTimestamp!)
//
            let date = msg.latestMessageTimestamp!
            
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mm a" //12 hr time
            timeFormatter.timeZone = TimeZone.current
            var timeStampString = timeFormatter.string(from: date)
            
            let calendar = Calendar.current
            if calendar.isDateInToday(date) {
                //do nothing
                timeStampString = timeFormatter.string(from: date)
            }
            else if calendar.isDateInYesterday(date) {
                timeStampString = "Yesterday"
            }
            else if date.isInThisWeek{
                let dayFormatter = DateFormatter()
                dayFormatter.dateFormat = "EEE"
                dayFormatter.timeZone = TimeZone.current
                let weekDay = dayFormatter.string(from: date)
                timeStampString = "\(weekDay)"
            } else {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "MMM dd"
                dateFormatter.timeZone = TimeZone.current
                let weekDay = dateFormatter.string(from: date)
                timeStampString = "\(weekDay)"
            }
            


            //let stringValue: String = "\(name) · \(timeStampString)"
            let stringValue: String = "\(name)"
            let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Apercu-Bold", size: 17)]
            guard let customFont = UIFont(name: "Apercu-Regular", size: 17) else {
                fatalError("""
                    Failed to load the "CustomFont-Light" font.
                    Make sure the font file is included in the project and the font name is spelled correctly.
                    """
                )
            }
            let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue, attributes: myAttribute)
            //let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue)
            attributedString.setColor(color: UIColor.lightGray, forText:"· \(timeStampString)")
            attributedString.setFont(font: customFont, forText: "· \(timeStampString)")
            userName.attributedText = attributedString
            
            timestamp.text = " · \(timeStampString)"
    
            message.text = msg.latest_message!
            
            if !msg.isRead! {
                userName.font = UIFont(name: "Apercu-Bold", size: 17)
                message.font = UIFont(name: "Apercu-Bold", size: 15)
                message.textColor = Color.matte
                unreadAlert.backgroundColor = Color.burple
            } else {
                userName.font = UIFont(name: "Apercu-Regular", size: 17)
                message.font = UIFont(name: "Apercu-Regular", size: 15)
                message.textColor = UIColor.lightGray
                unreadAlert.backgroundColor = .none
            }
            
        }
    }

    let profilePic: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imageView.layer.cornerRadius = 10
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    let userName : UILabel = {
        let userName = UILabel()
        userName.font = UIFont(name: "Apercu-Regular", size: 17)
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
        message.font = UIFont(name: "Apercu-Regular", size: 15)
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
        time.font = UIFont(name: "Apercu-Regular", size: 15)
        time.textColor = UIColor.lightGray
        time.translatesAutoresizingMaskIntoConstraints = false
        //time.backgroundColor = UIColor.blue
        return time
    }()
   
    
    //notification callback for refreshing profile picture
    @objc func refreshProfilePicture(_:UIImage) {
        let msg = self.item!
        profilePic.image = UIImage(named: msg.recipient_image ?? "avatar-4")
        
        if msg.isRevealed! {
            let profilePictureRef = "profiles/\(item?.recipient_uid ?? "")\(Constants.image_extension)"
            let cachedImage = imageCache.object(forKey: profilePictureRef as NSString)
            profilePic.image = cachedImage
        }
    }

    
   
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        NotificationCenter.default.addObserver(self, selector: #selector(refreshProfilePicture), name: Notification.Name(rawValue: "refreshPicture"), object: nil)
        
        self.contentView.addSubview(profilePic)
        profilePic.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        profilePic.leadingAnchor.constraint(equalTo: self.contentView.leadingAnchor, constant: 25).isActive = true
        profilePic.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profilePic.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        //MARK: profile pic masking
        /*
        let maskImageView = UIImageView()
        maskImageView.contentMode = .scaleAspectFit
        maskImageView.image = UIImage(named: "profile_mask")
        maskImageView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        profilePic.mask = maskImageView
        */
        
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
        timestamp.widthAnchor.constraint(greaterThanOrEqualToConstant: 15).isActive = true
        
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
