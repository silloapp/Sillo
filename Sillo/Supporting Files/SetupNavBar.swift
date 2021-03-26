//
//  SetupNavBar.swift
//  Sillo
//
//  Created by Eashan Mathur on 3/25/21.
//

import UIKit

class SetupNavBar: UIView {
    
    var navTitle: UILabel = {
        let txt = UILabel()
        txt.font = Font.bold(22)
        txt.textColor = Color.burple
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()
    
    let header : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.headerBackground
        return view
    }()

    var backAction: () -> Void
    
    
    public init(title: String, backButtonAction: @escaping () -> Void) {
        navTitle.text = title
        backAction = backButtonAction
        
        super.init(frame: CGRect.zero)
        setupView()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    /// Setup the nav bar
    func setupView() {
        addSubview(header)

        //header constraints
        header.topAnchor.constraint(equalTo: topAnchor).isActive = true
        header.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        header.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        header.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        
        //title constraints
        header.addSubview(navTitle)
        navTitle.centerXAnchor.constraint(equalTo: header.centerXAnchor).isActive = true
        navTitle.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        
        print("setting up header")
        //back button
        let backButton = UIImageView()
        backButton.image = UIImage(named: "back")
        backButton.translatesAutoresizingMaskIntoConstraints = false
        backButton.contentMode = .scaleAspectFit
        backButton.layer.masksToBounds = true
        backButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backTapped(tapGestureRecognizer:)))
        backButton.isUserInteractionEnabled = true
        backButton.addGestureRecognizer(tapGestureRecognizer)
        header.addSubview(backButton)
        

        backButton.leftAnchor.constraint(equalTo: header.safeAreaLayoutGuide.leftAnchor, constant: 16).isActive = true
        backButton.centerYAnchor.constraint(equalTo: navTitle.centerYAnchor).isActive = true
        backButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        backButton.widthAnchor.constraint(equalToConstant: 25).isActive = true

    }
    
    @objc func backTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        backAction()
    }
    
}
