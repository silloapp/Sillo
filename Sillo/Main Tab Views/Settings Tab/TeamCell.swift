//
//  TeamCell.swift
//  Sillo
//
//  Created by Angelica Pan on 2/19/21.
//

import UIKit

class TeamCell: UITableViewCell {

    var item:MenuItem? {
        didSet {
            guard let menuItem = item else {return}
            if let name = menuItem.name {
                itemImageview.image = UIImage(named: name)
                nameLabel.text = name
            }
            if menuItem.withArrow! {
                rightImageview.image = UIImage(named: "Forward Arrow")
            }
            if menuItem.fontSize != nil{
                nameLabel.font = UIFont(name: "Apercu-Regular", size: menuItem.fontSize!)
            }
        }
    }
    
    let containerView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.clipsToBounds = true // this will make sure its children do not go out of the boundary
        return view
    }()
    
    let itemImageview:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        img.clipsToBounds = true
        return img
    }()
    
    let rightImageview:UIImageView = {
        let img = UIImageView()
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false // enable autolayout
        img.clipsToBounds = true
        return img
    }()
    
    let nameLabel:UILabel = {
        let label = UILabel()
        label.font = UIFont(name: "Apercu-Regular", size: 20)
        label.textColor = .black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .white
        self.contentView.addSubview(itemImageview)
        containerView.addSubview(nameLabel)
        self.contentView.addSubview(containerView)
        self.contentView.addSubview(rightImageview)
        
        itemImageview.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        itemImageview.leadingAnchor.constraint(equalTo:self.contentView.leadingAnchor, constant:36).isActive = true
        itemImageview.widthAnchor.constraint(equalToConstant:25).isActive = true
        itemImageview.heightAnchor.constraint(equalToConstant:25).isActive = true
        
        containerView.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        containerView.leadingAnchor.constraint(equalTo:self.itemImageview.trailingAnchor, constant:10).isActive = true
        containerView.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-10).isActive = true
        containerView.heightAnchor.constraint(equalToConstant:40).isActive = true
        
        nameLabel.centerYAnchor.constraint(equalTo: self.contentView.centerYAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo:self.itemImageview.trailingAnchor, constant: 36).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo:self.containerView.trailingAnchor).isActive = true
        
        rightImageview.centerYAnchor.constraint(equalTo:self.contentView.centerYAnchor).isActive = true
        rightImageview.trailingAnchor.constraint(equalTo:self.contentView.trailingAnchor, constant:-36).isActive = true
        rightImageview.widthAnchor.constraint(equalToConstant:25).isActive = true
        rightImageview.heightAnchor.constraint(equalToConstant:25).isActive = true
       
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
}
