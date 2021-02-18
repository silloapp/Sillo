//
//  TeamSettingsTableViewCell.swift
//  Sillo
//
//  Created by Angelica Pan on 2/14/21.
//

import UIKit

class TeamSettingsTableViewCell: UITableViewCell {

    let itemImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "Person")
        imageView.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupView() {
        let itemLabel = UILabel()
        itemLabel.text = "Settings"
        itemLabel.font = Font.bold(17)
        itemLabel.textColor = Color.textSemiBlack
        itemLabel.translatesAutoresizingMaskIntoConstraints = false

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .leading
        stackView.spacing = 0
        stackView.addArrangedSubview(itemImage)
        stackView.addArrangedSubview(itemLabel)
    
        contentView.addSubview(stackView)
        
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
