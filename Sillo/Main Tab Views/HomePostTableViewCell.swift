//
//  HomePostTableViewCell.swift
//  Sillo
//
//  Created by Eashan Mathur on 2/4/21.
//

import UIKit

class HomePostTableViewCell: UITableViewCell {

    
    let profilePic: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "avatar-1")
        imageView.frame = CGRect(x: 0, y: 0, width: 50, height: 50)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupView() {
        
        addSubview(profilePic)
        profilePic.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 22).isActive = true
        profilePic.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 25).isActive = true
        
        //overarching message stack
        let nameTimeMessageStack = UIStackView()
        nameTimeMessageStack.axis = .vertical
        nameTimeMessageStack.spacing = 0
        nameTimeMessageStack.distribution = .fillProportionally
        nameTimeMessageStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nameTimeMessageStack)
        
        //stack holding the name and time
        let nameTimeStack = UIStackView()
        nameTimeStack.axis = .horizontal
        nameTimeStack.distribution = .fillProportionally
        nameTimeStack.alignment = .leading
        nameTimeStack.spacing = 0
        nameTimeMessageStack.addArrangedSubview(nameTimeStack)
        
        let userName = UILabel()
        userName.text = "Cabbage"
        userName.font = Font.bold(17)
        userName.textColor = Color.textSemiBlack
        userName.translatesAutoresizingMaskIntoConstraints = false
        nameTimeStack.addArrangedSubview(userName)
        
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm"
        let dateInString = dateFormatter.string(from: date as Date)
        
        let time = UILabel()
        time.text = dateInString
        time.font = Font.regular(17)
        time.textColor = .lightGray
        time.translatesAutoresizingMaskIntoConstraints = false
        nameTimeStack.addArrangedSubview(time)
        
        let message = UILabel()
        message.text = "Does anyone here like beets? I feel that beets are a lil too red for my liking, not sure if I’m the only who thinks this though! Lmk your thoughts.Does anyone here like beets? I feel that beets are a lil too red for my liking, not sure if I’m the only who thinks this though! Lmk your thoughts."
        message.font = Font.regular(15)
        message.numberOfLines = 0
        message.textColor = Color.message
        message.baselineAdjustment = .alignBaselines
        message.textAlignment = .left
        message.translatesAutoresizingMaskIntoConstraints = false
        message.sizeToFit()
        nameTimeMessageStack.addArrangedSubview(message)
        
        
        userName.heightAnchor.constraint(equalToConstant: 21).isActive = true
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
