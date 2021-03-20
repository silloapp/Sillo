//
//  CustomTableViewCell.swift
//  Sillo
//
//  Created by Eashan Mathur on 3/6/21.
//

import UIKit

class CustomTableViewCell: UITableViewCell {
    
    let bgView = UIView()
    let imgUser = UIImageView()
    let imgUser2 = UIImageView()
    let checkImg = UIImageView()
    
    let labUserName = UILabel()
    let labMessage = UILabel()
    
    var TITLEconstraints = [NSLayoutConstraint]()
    var Messageconstraints = [NSLayoutConstraint]()
    var img1constraints = [NSLayoutConstraint]()
    var img2constraints = [NSLayoutConstraint]()
    
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // FOR bg :
        
        contentView.addSubview(bgView)
        
        let bgOconstraints = [
            bgView.topAnchor.constraint(equalTo:  contentView.topAnchor, constant: 8),
            bgView.leftAnchor.constraint(equalTo:  contentView.leftAnchor, constant: 5),
            bgView.rightAnchor.constraint(equalTo:  contentView.rightAnchor, constant: -5),
            bgView.bottomAnchor.constraint(equalTo:  contentView.bottomAnchor, constant: -8),
            
        ]
        
        bgView.backgroundColor = hexStringToUIColor(hex: "#F2F4F4")
        bgView.layer.cornerRadius = 10
        bgView.clipsToBounds = true
        
        // for images :
        
        contentView.addSubview(imgUser)
        imgUser.image = UIImage.init(named: "profile")
        
        img1constraints = [
            imgUser.centerYAnchor.constraint(equalTo:  contentView.centerYAnchor, constant: 0),
            imgUser.leftAnchor.constraint(equalTo:  contentView.leftAnchor, constant: 15),
            imgUser.widthAnchor.constraint(equalToConstant: 40),
            imgUser.heightAnchor.constraint(equalToConstant: 40)
        ]
        imgUser.layer.cornerRadius = 20
        imgUser.clipsToBounds = true
        
        contentView.addSubview(imgUser2)
        imgUser2.image = UIImage.init(named: "smiley")
        
        img2constraints = [
            imgUser2.centerYAnchor.constraint(equalTo:  contentView.centerYAnchor, constant: 0),
            imgUser2.leftAnchor.constraint(equalTo:  contentView.leftAnchor, constant: 65),
            imgUser2.widthAnchor.constraint(equalToConstant: 40),
            imgUser2.heightAnchor.constraint(equalToConstant: 40)
        ]
        imgUser2.layer.cornerRadius = 20
        imgUser2.clipsToBounds = true
        
        // for checkmark :
        
        contentView.addSubview(checkImg)
        checkImg.image = UIImage.init(named: "check")
        
        let checkImgconstraints = [
            checkImg.centerYAnchor.constraint(equalTo:  contentView.centerYAnchor, constant: 0),
            checkImg.rightAnchor.constraint(equalTo:  contentView.rightAnchor, constant: -20),
            checkImg.widthAnchor.constraint(equalToConstant: 25),
            checkImg.heightAnchor.constraint(equalToConstant: 25)
        ]
        checkImg.isHidden = true
        
        
        
        
        // FOR LABELS :
        
        contentView.addSubview(labUserName)
        labUserName.text = "Full Name"
        labUserName.backgroundColor = .clear
        labUserName.textColor = .black
        labUserName.font = UIFont(name: "Apercu-Bold", size: 17)
        labUserName.textAlignment = .left
        
        TITLEconstraints = [
            labUserName.centerYAnchor.constraint(equalTo:  contentView.centerYAnchor, constant: -10),
            labUserName.leftAnchor.constraint(equalTo:  imgUser2.leftAnchor, constant: 70),
            labUserName.rightAnchor.constraint(equalTo:  contentView.rightAnchor, constant: 20),
            labUserName.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        contentView.addSubview(labMessage)
        labMessage.text = "Level 5"
        labMessage.backgroundColor = .clear
        labMessage.textColor = .black
        labMessage.font = UIFont(name: "Apercu-Regular", size: 12)
        labMessage.textAlignment = .left
        
        Messageconstraints = [
            labMessage.centerYAnchor.constraint(equalTo:  contentView.centerYAnchor, constant: 13),
            labMessage.leftAnchor.constraint(equalTo:  imgUser2.leftAnchor, constant: 70),
            labMessage.rightAnchor.constraint(equalTo:  contentView.rightAnchor, constant: 20),
            labMessage.heightAnchor.constraint(equalToConstant: 20)
        ]
        
        
        
        // LAYOUT VIEW:
        
        NSLayoutConstraint.activate(bgOconstraints)
        NSLayoutConstraint.activate(img1constraints)
        NSLayoutConstraint.activate(img2constraints)
        NSLayoutConstraint.activate(TITLEconstraints)
        NSLayoutConstraint.activate(Messageconstraints)
        NSLayoutConstraint.activate(checkImgconstraints)
        
        bgView.translatesAutoresizingMaskIntoConstraints = false
        imgUser.translatesAutoresizingMaskIntoConstraints = false
        imgUser2.translatesAutoresizingMaskIntoConstraints = false
        labUserName.translatesAutoresizingMaskIntoConstraints = false
        labMessage.translatesAutoresizingMaskIntoConstraints = false
        checkImg.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.layoutIfNeeded()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }

    
}

