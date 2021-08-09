//
//  OrganizationTableViewCell.swift
//  Sillo
//
//  Created by Eashan Mathur on 8/8/21.
//

import UIKit

class OrganizationTableViewCell: UITableViewCell {

    
    let orgImage = UIImageView()
    let orgName = UILabel()
    let msgDetails = UILabel()
    let bcg = UIView()
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupCell() {
        
        contentView.addSubview(bcg)
        bcg.translatesAutoresizingMaskIntoConstraints = false
        bcg.topAnchor.constraint(equalTo:  contentView.topAnchor, constant: 8).isActive = true
        bcg.leftAnchor.constraint(equalTo:  contentView.leftAnchor, constant: 5).isActive = true
        bcg.rightAnchor.constraint(equalTo:  contentView.rightAnchor, constant: -5).isActive = true
        bcg.bottomAnchor.constraint(equalTo:  contentView.bottomAnchor, constant: -8).isActive = true

        bcg.cornerRadius = 10
        bcg.clipsToBounds = true
        
        contentView.addSubview(orgImage)
        orgImage.translatesAutoresizingMaskIntoConstraints = false
        orgImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        orgImage.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 18).isActive = true
        orgImage.heightAnchor.constraint(equalToConstant: 42).isActive = true
        orgImage.widthAnchor.constraint(equalToConstant: 42).isActive = true
        
        orgImage.layer.borderWidth = 3.5
        orgImage.layer.masksToBounds = false
        orgImage.clipsToBounds = true
        orgImage.layer.cornerRadius = 20
        orgImage.layer.borderColor = Color.russiandolphin.cgColor
        
        contentView.addSubview(orgName)
        orgName.translatesAutoresizingMaskIntoConstraints = false
        orgName.font = UIFont(name: "Apercu-Bold", size: 18)
        orgName.textColor = Color.matte
        orgName.centerYAnchor.constraint(equalTo: orgImage.centerYAnchor).isActive = true
        orgName.leftAnchor.constraint(equalTo: orgImage.rightAnchor, constant: 20).isActive = true

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
