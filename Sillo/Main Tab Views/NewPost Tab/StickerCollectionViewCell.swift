//
//  StickerCollectionViewCell.swift
//  Sillo
//
//  Created by Eashan Mathur on 4/14/21.
//

import UIKit

class StickerCollectionViewCell: UICollectionViewCell {
    
    static let id = "cell"
    
    var stickerImage: UIImageView = {
        let img = UIImageView()
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        contentView.backgroundColor = .white
        contentView.addSubview(stickerImage)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        stickerImage.frame = CGRect(x: 0, y: 0, width: contentView.frame.size.height, height: contentView.frame.size.width)
    }
    
    
}
