//
//  StickerPickerViewController.swift
//  Sillo
//
//  Created by Eashan Mathur on 4/14/21.
//

import UIKit

class StickerPickerViewController: UIViewController {
    
    var stickerCollectionView: UICollectionView?

    let cellID = "stickerCell"
    var stickers = [#imageLiteral(resourceName: "wait_success"), #imageLiteral(resourceName: "team-7"), #imageLiteral(resourceName: "coffee with outline"), #imageLiteral(resourceName: "team-6"), #imageLiteral(resourceName: "no-associated-spaces-noText"), #imageLiteral(resourceName: "placeholder profile"), #imageLiteral(resourceName: "Fashion"), #imageLiteral(resourceName: "onboarding3")]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupCollectionView()
    }
    
    func setupCollectionView(){
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: 112, height: 112)
        
        
        stickerCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        stickerCollectionView?.register(StickerCollectionViewCell.self, forCellWithReuseIdentifier: StickerCollectionViewCell.id)
        stickerCollectionView?.delegate = self
        stickerCollectionView?.dataSource = self
        guard let collectionView = stickerCollectionView else { return }
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white
        stickerCollectionView = collectionView
        view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 50).isActive = true
        collectionView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
}

extension StickerPickerViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let myCell = collectionView.dequeueReusableCell(withReuseIdentifier: StickerCollectionViewCell.id, for: indexPath) as! StickerCollectionViewCell
        myCell.stickerImage.image = stickers[indexPath.row]
        
        return myCell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
}
