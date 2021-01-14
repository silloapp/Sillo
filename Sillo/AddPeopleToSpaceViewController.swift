//
//  AddPeopleToSpaceViewController.swift
//  Sillo
//
//  Created by Eashan Mathur on 1/13/21.
//

import UIKit

class AddPeopleToSpaceViewController: UIViewController, UIGestureRecognizerDelegate {

    //MARK: Figma #1221

    var bar = UIProgressView()
    var orgNameString : String = "FAKE"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupProgressBar()
        setupView()
    }
    
    //MARK: Prevents NavBar header from showing up when going back to root VC
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: animated);
        super.viewWillDisappear(animated)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    func configureNavBar() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        navigationController?.navigationBar.barTintColor = .white
        view.backgroundColor = .white
        navigationController?.navigationBar.tintColor = .black
    }
    
    
    func setupProgressBar() {
        bar.trackTintColor = Color.gray
        bar.progressTintColor = Color.buttonClickable
        bar.setProgress(2/4, animated: true)
        view.addSubview(bar)
        
        bar.translatesAutoresizingMaskIntoConstraints = false
        bar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        bar.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        bar.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        bar.heightAnchor.constraint(equalToConstant: 3).isActive = true
    }
    
    func setupView() {
        
        let stack = UIStackView()
        stack.distribution = .equalSpacing
        stack.alignment = .center
        stack.axis = .vertical
        stack.spacing = 20
        view.addSubview(stack)
        
        let header = UILabel()
        header.text = "Add people to this space"
        header.font = Font.medium(dynamicFontSize(22))
        header.adjustsFontSizeToFitWidth = true
        header.textColor = Color.textSemiBlack
        header.numberOfLines = 1
        stack.addArrangedSubview(header)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 300/375).isActive = true

        let hStack = UIStackView()
        hStack.distribution = .fillProportionally
        hStack.alignment = .center
        hStack.axis = .horizontal
        hStack.spacing = 25
        stack.addArrangedSubview(hStack)
        
        hStack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.15).isActive = true
        hStack.widthAnchor.constraint(equalTo: stack.widthAnchor, multiplier: 1).isActive = true
        
        let addPhotoImage = UIImageView()
        addPhotoImage.image = UIImage(named: "addPhoto")
        addPhotoImage.contentMode = .scaleAspectFit
        
        let orgName = UILabel()
        orgName.text = orgNameString
        orgName.textColor = Color.textSemiBlack
        orgName.font = Font.medium(dynamicFontSize(22))
        
        hStack.addArrangedSubview(addPhotoImage)
        hStack.addArrangedSubview(orgName)
        
        orgName.widthAnchor.constraint(equalTo: hStack.widthAnchor, multiplier: 0.7).isActive = true
        orgName.heightAnchor.constraint(equalTo: hStack.heightAnchor, multiplier: 30/71).isActive = true
        addPhotoImage.widthAnchor.constraint(equalTo: orgName.heightAnchor).isActive = true
        addPhotoImage.heightAnchor.constraint(equalTo: orgName.heightAnchor).isActive = true
    }
    
    


}
