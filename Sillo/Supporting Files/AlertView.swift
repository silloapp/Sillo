//
//  AlertView.swift
//  berkeley-mobile
//
//  Created by Eashan Mathur on 2/27/21.
//  Copyright © 2021 ASUC OCTO. All rights reserved.
//

import UIKit

class AlertView: UIViewController {
    
    let heading: UILabel = {
        var txt = UILabel()
        txt.font = UIFont(name: "Apercu-Bold", size: 18)
        txt.textColor = Color.matte
        txt.numberOfLines = 0
        txt.textAlignment = .center
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()

    let message: UILabel = {
        var txt = UILabel()
        txt.font = UIFont(name: "Apercu-Regular", size: 15)
        txt.textColor = Color.matte
        txt.numberOfLines = 0
        txt.textAlignment = .center
        txt.translatesAutoresizingMaskIntoConstraints = false
        return txt
    }()

    var btn1: UIButton = {
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()

    var btn2: UIButton = {
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var cancelBtn: UIButton = {
        var btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    var alertImageView: UIImageView = {
        var img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    
    var withCancel: Bool
    var withOneButton: Bool
    var btn1Action: () -> Void
    var btn2Action: () -> Void
    
    
    init(headingText: String, messageText: String, action1Label btn1String: String, action1Color btn1Color: UIColor, action1Completion: @escaping () -> Void, action2Label btn2String: String, action2Color btn2Color: UIColor, action2Completion: @escaping () -> Void, withCancelBtn: Bool, image: UIImage?, withOnlyOneAction: Bool) {
        
        
        btn1Action = action1Completion
        btn2Action = action2Completion
        withCancel = withCancelBtn
        withOneButton = withOnlyOneAction
        
        super.init(nibName: nil, bundle: nil)
        
        
        if let img = image {
            alertImageView.image = img
        }
        
        heading.text = headingText
        message.text = messageText
        
        guard let customFont = UIFont(name: "Apercu-Regular", size: 14) else {
            fatalError("""
                Failed to load the "CustomFont-Light" font.
                Make sure the font file is included in the project and the font name is spelled correctly.
                """
            )
        }
        
        btn1 = ActionButton(title: btn1String, font: customFont, defaultColor: btn1Color, pressedColor: btn1Color)
        btn2 = ActionButton(title: btn2String, font: customFont, defaultColor: btn2Color, pressedColor: btn2Color)
        
        btn1.layer.cornerRadius = 5
        btn2.layer.cornerRadius = 5
        
        btn1.addTarget(self, action: #selector(btn1Function), for: .touchUpInside)
        btn2.addTarget(self, action: #selector(btn2Function), for: .touchUpInside)
        
        
        btn1.titleLabel?.adjustsFontSizeToFitWidth = true
        btn2.titleLabel?.adjustsFontSizeToFitWidth = true
        
        btn1.layer.shadowOpacity = 0
        btn2.layer.shadowOpacity = 0
        
        
        if !UIAccessibility.isReduceTransparencyEnabled {
            view.backgroundColor = .clear

            let blurEffect = UIBlurEffect(style: .systemMaterialDark)
            let blurEffectView = UIVisualEffectView(effect: blurEffect)
            //always fill the view
            blurEffectView.frame = self.view.bounds
            
            blurEffectView.alpha = 0.75
            blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

            view.addSubview(blurEffectView)
            blurEffectView.translatesAutoresizingMaskIntoConstraints = false
            
            blurEffectView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
            blurEffectView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            blurEffectView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            blurEffectView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            
            view.sendSubviewToBack(blurEffectView)
            self.tabBarController?.tabBar.addSubview(blurEffectView)

        } else {
            view.backgroundColor = .black
        }
        
    }
    
    
    @objc func btn1Function() {
        btn1Action()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PopupDidAppear"), object: nil)
    }
    
    @objc func btn2Function() {
        btn2Action()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "PopupDidAppear"), object: nil)
    }
    
    @objc func dismissPop() {
        self.dismiss(animated: true, completion: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupView()
    }
    
    
    func setupView(){
        
        let backgroundView = UIView()
        backgroundView.backgroundColor = .white
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(backgroundView)
        
        let Vstack = UIStackView()
        Vstack.axis = .vertical
        Vstack.spacing = 10
        Vstack.distribution = .fillProportionally
        
        if alertImageView.image != nil {
            Vstack.addArrangedSubview(alertImageView)
        }
        
        Vstack.addArrangedSubview(heading)
        Vstack.addArrangedSubview(message)
        Vstack.translatesAutoresizingMaskIntoConstraints = false
        

        
        let Hstack = UIStackView()
        Hstack.axis = .horizontal
        Hstack.distribution = .fillEqually
        Hstack.spacing = 15
        
        Hstack.addArrangedSubview(btn1)
        if !withOneButton {
            Hstack.addArrangedSubview(btn2)
        }
        Hstack.translatesAutoresizingMaskIntoConstraints = false
        
        backgroundView.addSubview(Vstack)
        backgroundView.addSubview(Hstack)
        
        print("setting up")
        
        backgroundView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        backgroundView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        backgroundView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 304/375).isActive = true
        backgroundView.layer.cornerRadius = 12
        
        Vstack.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        Vstack.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 15).isActive = true
        Vstack.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor, constant: 28).isActive = true
        Vstack.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor, constant: -28).isActive = true
        
        Hstack.centerXAnchor.constraint(equalTo: backgroundView.centerXAnchor).isActive = true
        Hstack.topAnchor.constraint(equalTo: Vstack.bottomAnchor, constant: 20).isActive = true
        if !withOneButton {
            Hstack.widthAnchor.constraint(equalToConstant: 200).isActive = true
        } else {
            Hstack.widthAnchor.constraint(equalToConstant: 130).isActive = true
        }
        Hstack.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor, constant: -14).isActive = true
        
        btn1.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btn2.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
            
        if withCancel {
            cancelBtn.setImage(UIImage(named: "closeButton"), for: .normal)
            cancelBtn.addTarget(self, action: #selector(self.dismissPop), for: .touchUpInside)
            backgroundView.addSubview(cancelBtn)
            backgroundView.bringSubviewToFront(cancelBtn)
            cancelBtn.setTitleColor(.black, for: .normal)
            
            cancelBtn.topAnchor.constraint(equalTo: backgroundView.topAnchor, constant: 15).isActive = true
            cancelBtn.leftAnchor.constraint(equalTo: backgroundView.leftAnchor, constant: 15).isActive = true
        }
        
    }
    
    
}
