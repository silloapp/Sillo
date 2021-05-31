//
//  StickerPickerViewController.swift
//  Sillo
//
//  Created by Eashan Mathur on 4/14/21.
//

import UIKit

class StickerPickerViewController: UIViewController {
    
    var stickerCollectionView: UICollectionView?
    //MARK: next button
    let removeStickerBtn: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.setTitle("Remove Sticker", for: .normal)
        button.titleLabel?.font = Font.bold(20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Color.buttonClickableUnselected
        button.isUserInteractionEnabled = false
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    let cellID = "stickerCell"
    public var stickers = ["Sticker-1", "Sticker-2", "Sticker-3", "Sticker-4", "Sticker-5"]
    weak var delegate: NewPostViewController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
        removeStickerBtn.addTarget(self, action: #selector(removeStickerPressed), for: .touchUpInside)

    }
    
    func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 112, height: 112)
        
        
        stickerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        stickerCollectionView?.register(StickerCollectionViewCell.self, forCellWithReuseIdentifier: StickerCollectionViewCell.id)
        stickerCollectionView?.delegate = self
        stickerCollectionView?.dataSource = self
        stickerCollectionView?.isScrollEnabled = true
        guard let collectionView = stickerCollectionView else { return }
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        stickerCollectionView = collectionView
        
        view.addSubview(collectionView)
        view.addSubview(removeStickerBtn)
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        collectionView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 4/7).isActive = true
        
        removeStickerBtn.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        removeStickerBtn.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        removeStickerBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        removeStickerBtn.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 25).isActive = true
    }
    
    @objc func removeStickerPressed() {
        delegate.removeSticker()
        removeStickerBtn.isUserInteractionEnabled = false
        removeStickerBtn.backgroundColor = Color.buttonClickableUnselected
    }
    
}

extension StickerPickerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: StickerCollectionViewCell.id, for: indexPath) as! StickerCollectionViewCell
        let stickerName = quests.ownedStickers[indexPath.row]
        let StickerAssetName = quests.stickerNameToImageMapping[stickerName] ?? "ERROR"
        myCell.stickerImage.image = UIImage(named: StickerAssetName)
        return myCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return quests.ownedStickers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let stickerName = quests.ownedStickers[indexPath.row]
        let stickerSelected = quests.stickerNameToImageMapping[stickerName] ?? "ERROR"
        
        print("clicked something")
        delegate.addSticker(img: UIImage(named: stickerSelected)!, name: stickerSelected)
        removeStickerBtn.isUserInteractionEnabled = true
        removeStickerBtn.backgroundColor = Color.buttonClickable
    }
    
    
}
