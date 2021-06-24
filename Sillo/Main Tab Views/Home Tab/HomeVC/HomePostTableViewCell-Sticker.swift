//
//  HomePostTableViewCell-Sticker.swift
//  Sillo
//
//  Created by William Loo on 5/27/21.
//

import UIKit
import GiphyUISDK

class HomePostTableViewCellSticker: UITableViewCell {
    
    
    //set data to display within post cell
    var item:Post? {
        didSet {
            print("Line 15")
            guard let msg = item else {return}
            if let name = msg.posterAlias {
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "h:mm a" //12 hr time
                timeFormatter.timeZone = TimeZone.current
                var timeStampString = timeFormatter.string(from: msg.date!)
                
                let calendar = Calendar.current
                let date = msg.date!
                if calendar.isDateInToday(date) {
                    //do nothing
                    timeStampString = timeFormatter.string(from: msg.date!)
                }
                else if calendar.isDateInYesterday(date) {
                    timeStampString = "Yesterday \(timeFormatter.string(from: msg.date!))"
                }
                else if date.isInThisWeek{
                    let dayFormatter = DateFormatter()
                    dayFormatter.dateFormat = "EEE h:mm a"
                    dayFormatter.timeZone = TimeZone.current
                    let weekDay = dayFormatter.string(from: msg.date!)
                    timeStampString = "\(weekDay)"
                } else {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM dd h:mm a"
                    dateFormatter.timeZone = TimeZone.current
                    let weekDay = dateFormatter.string(from: msg.date!)
                    timeStampString = "\(weekDay)"
                }
                

                
                let stringValue: String = "\(name) · \(timeStampString)"
                let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Apercu-Bold", size: 17)]
                let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue, attributes: myAttribute as [NSAttributedString.Key : Any])
                attributedString.setColor(color: UIColor.lightGray, forText:"· \(timeStampString)")
                attributedString.setFont(font: UIFont(name: "Apercu Regular", size: 15)!, forText: "· \(timeStampString)")
                userName.attributedText = attributedString
            }
            if let messageText = msg.message {
                message.text = messageText
            }
            
            if let imgName = msg.posterImageName  {
                profilePic.image = UIImage(named: imgName)
            }
            
            stickerImageView.image = UIImage(named: msg.attachment!)
            self.optionsButton.post = self.item
        }
    }
    
    
    public let stickerImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.frame = CGRect(x: 0, y: 0, width: 112, height: 112)
//        imgView.image = #imageLiteral(resourceName: "donut")
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    let profilePic: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let userName : UILabel = {
        let userName = UILabel()
        userName.font = UIFont(name: "Apercu-Bold", size: 17)
        userName.textColor = UIColor.black
        userName.translatesAutoresizingMaskIntoConstraints = false
        return userName
    }()
    
    let optionsButton: ReportButton = {
        let imageView = ReportButton()
        imageView.image = UIImage(named: "Downward Arrow")
        imageView.frame = CGRect(x: 0, y: 0, width: 18, height: 10)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let message:UILabel = {
        let message = UILabel()
        message.font = UIFont(name: "Apercu Regular", size: 15)
        message.numberOfLines = 0
        message.textColor = Color.message
        message.textAlignment = .left
        message.lineBreakMode = NSLineBreakMode.byWordWrapping
        message.sizeToFit()
        message.translatesAutoresizingMaskIntoConstraints = false
        return message
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        print("Doing cell UI updates now")
        
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
        optionsButton.heightAnchor.constraint(equalToConstant: 12).isActive = true
        optionsButton.trailingAnchor.constraint(equalTo: self.userName.trailingAnchor, constant: 0).isActive = true
        optionsButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
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
        
        //adds sticker to cell
        self.contentView.addSubview(stickerImageView)
        stickerImageView.topAnchor.constraint(equalTo: self.message.bottomAnchor, constant: 15).isActive = true
        stickerImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        stickerImageView.leadingAnchor.constraint(equalTo: self.message.leadingAnchor).isActive = true
        stickerImageView.heightAnchor.constraint(equalToConstant: 112).isActive = true
        stickerImageView.widthAnchor.constraint(equalToConstant: 112).isActive = true        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func optionsTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("DEPRECATED")
    }
}


//CELL FOR GIPHY GIFS AND STICKERS!!!!!!
class HomePostTableViewCellGIF: UITableViewCell {
    
    var assetRequest: URLSessionDataTask?
    var bubbleLeftConstraint: NSLayoutConstraint?
    var bubbleRightConstraint: NSLayoutConstraint?
    var avatarLeftConstraint: NSLayoutConstraint?
    var avatarRightConstraint: NSLayoutConstraint?
    var imageViewWidthConstraint: NSLayoutConstraint?
    var imageViewLeftConstraint: NSLayoutConstraint?

    
    //set data to display within post cell
    var item:Post? {
        didSet {
            print("Line 15")
            guard let msg = item else {return}
            if let name = msg.posterAlias {
                let timeFormatter = DateFormatter()
                timeFormatter.dateFormat = "h:mm a" //12 hr time
                timeFormatter.timeZone = TimeZone.current
                var timeStampString = timeFormatter.string(from: msg.date!)
                
                let calendar = Calendar.current
                let date = msg.date!
                if calendar.isDateInToday(date) {
                    //do nothing
                    timeStampString = timeFormatter.string(from: msg.date!)
                }
                else if calendar.isDateInYesterday(date) {
                    timeStampString = "Yesterday \(timeFormatter.string(from: msg.date!))"
                }
                else if date.isInThisWeek{
                    let dayFormatter = DateFormatter()
                    dayFormatter.dateFormat = "EEE h:mm a"
                    dayFormatter.timeZone = TimeZone.current
                    let weekDay = dayFormatter.string(from: msg.date!)
                    timeStampString = "\(weekDay)"
                } else {
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "MMM dd h:mm a"
                    dateFormatter.timeZone = TimeZone.current
                    let weekDay = dateFormatter.string(from: msg.date!)
                    timeStampString = "\(weekDay)"
                }
                

                
                let stringValue: String = "\(name) · \(timeStampString)"
                let myAttribute = [ NSAttributedString.Key.font: UIFont(name: "Apercu-Bold", size: 17)]
                let attributedString: NSMutableAttributedString = NSMutableAttributedString(string: stringValue, attributes: myAttribute as [NSAttributedString.Key : Any])
                attributedString.setColor(color: UIColor.lightGray, forText:"· \(timeStampString)")
                attributedString.setFont(font: UIFont(name: "Apercu Regular", size: 15)!, forText: "· \(timeStampString)")
                userName.attributedText = attributedString
            }
            if let messageText = msg.message {
                message.text = messageText
            }
            
            if let imgName = msg.posterImageName  {
                profilePic.image = UIImage(named: imgName)
            }
            
            if let id = msg.attachment {
                GiphyCore.shared.gifByID(id) { (response, error) in
                    if let media = response?.data {
                        DispatchQueue.main.sync { [weak self] in
                            self?.mediaView.media = media
                        }
                    }
                }
            }
           
            
            stickerImageView.image = UIImage(named: msg.attachment!)
            self.optionsButton.post = self.item
        }
    }
    
    
    public let stickerImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.frame = CGRect(x: 0, y: 0, width: 112, height: 112)
//        imgView.image = #imageLiteral(resourceName: "donut")
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    let bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let mediaView = GPHMediaView()
    
    
    let profilePic: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let userName : UILabel = {
        let userName = UILabel()
        userName.font = UIFont(name: "Apercu-Bold", size: 17)
        userName.textColor = UIColor.black
        userName.translatesAutoresizingMaskIntoConstraints = false
        return userName
    }()
    
    let optionsButton: ReportButton = {
        let imageView = ReportButton()
        imageView.image = UIImage(named: "Downward Arrow")
        imageView.frame = CGRect(x: 0, y: 0, width: 18, height: 10)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let message:UILabel = {
        let message = UILabel()
        message.font = UIFont(name: "Apercu Regular", size: 15)
        message.numberOfLines = 0
        message.textColor = Color.message
        message.textAlignment = .left
        message.lineBreakMode = NSLineBreakMode.byWordWrapping
        message.sizeToFit()
        message.translatesAutoresizingMaskIntoConstraints = false
        return message
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        print("Doing cell UI updates now")
        
      
        
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
        optionsButton.heightAnchor.constraint(equalToConstant: 12).isActive = true
        optionsButton.trailingAnchor.constraint(equalTo: self.userName.trailingAnchor, constant: 0).isActive = true
        optionsButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
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
        
        //bubbleview
        contentView.addSubview(bubbleView)
        bubbleView.topAnchor.constraint(equalTo: message.bottomAnchor, constant: 15).isActive = true
        bubbleView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        bubbleView.widthAnchor.constraint(equalToConstant: ChatCell.bubbleWidth).isActive = true
        bubbleView.leadingAnchor.constraint(equalTo: self.profilePic.trailingAnchor, constant: 16).isActive = true
        
        bubbleView.layer.cornerRadius = 16
        bubbleView.layer.masksToBounds = false
        bubbleView.layer.shadowColor = UIColor.black.cgColor
        bubbleView.layer.shadowOpacity = 0.12
        bubbleView.layer.shadowRadius = 25
        bubbleView.layer.shadowOffset = CGSize(width: 0, height: 13)
        
        bubbleView.backgroundColor = .systemRed
       
        
        
        bubbleView.addSubview(mediaView)
        mediaView.translatesAutoresizingMaskIntoConstraints = false
        mediaView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        
        
        
        
        if let id = item?.attachment {
            GiphyCore.shared.gifByID(id) { (response, error) in
                if let media = response?.data {
                    DispatchQueue.main.sync { [weak self] in
                        self?.mediaView.media = media
                        self!.imageViewWidthConstraint = self?.mediaView.widthAnchor.constraint(equalTo: (self?.mediaView.heightAnchor)!, multiplier: media.aspectRatio)
                        self!.imageViewWidthConstraint?.isActive = true
                    }
                }
            }
        }
        
        
        imageViewLeftConstraint = mediaView.leftAnchor.constraint(equalTo: bubbleView.leftAnchor)
        imageViewLeftConstraint?.isActive = true
        mediaView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        mediaView.isUserInteractionEnabled = false
        mediaView.contentMode = .scaleAspectFill //TODO: to avoid cropping, change this to aspectFit (though if you do this you'll also have to solve the issue with the rounded corners not showing, will do this when i have more time!)
        mediaView.layer.cornerRadius = bubbleView.layer.cornerRadius
        mediaView.layer.masksToBounds = true
 
        mediaView.topAnchor.constraint(equalTo: bubbleView.topAnchor).isActive = true
        mediaView.bottomAnchor.constraint(equalTo: bubbleView.bottomAnchor).isActive = true
        mediaView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor).isActive = true
        mediaView.trailingAnchor.constraint(equalTo: bubbleView.trailingAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    @objc func optionsTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("DEPRECATED")
    }
}
