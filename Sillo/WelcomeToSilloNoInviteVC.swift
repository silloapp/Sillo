//
//  WelcomeToSilloNoInviteVC.swift
//  Sillo
//
//  Created by Eashan Mathur on 3/28/21.
//

import UIKit

class WelcomeToSilloNoInviteVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        navigationController?.navigationBar.isHidden = true
        
        setupView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    func setupView() {
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 10
//        stack.distribution = .equalSpacing
        stack.alignment = .leading
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let heading = UILabel()
        heading.font = UIFont(name: "Apercu Bold", size: 24)
        heading.text = "Welcome to Sillo"
        heading.textColor = Color.burple
        stack.addArrangedSubview(heading)
        
        
        let stack2 = UIStackView()
        stack2.axis = .vertical
        stack2.spacing = 15
        stack2.alignment = .leading
        stack2.distribution = .fillProportionally
        stack.addArrangedSubview(stack2)
        
        let middleText = UILabel()
        middleText.font =  UIFont(name: "Apercu Regular", size: 17)
        middleText.text = "We don’t see any Sillo spaces associated with \(Constants.EMAIL ?? "your email")"
        middleText.textColor = Color.matte
        middleText.numberOfLines = 0
        stack2.addArrangedSubview(middleText)
        
        let stack3 = UIStackView()
        stack3.axis = .vertical
        stack3.spacing = 5
        stack3.alignment = .leading
        stack2.addArrangedSubview(stack3)
        
        let bottomText = UILabel()
        bottomText.font =  UIFont(name: "Apercu Regular", size: 17)
        bottomText.text = "To join a space, ask your team administrator for an invitation or:"
        bottomText.textColor = Color.matte
        bottomText.numberOfLines = 0
        stack3.addArrangedSubview(bottomText)
        
        let btn = UIButton()
        btn.titleLabel?.font = UIFont(name: "Apercu Regular", size: 17)
        btn.setTitleColor(Color.burple, for: .normal)
        btn.backgroundColor = .white
        btn.underlineButton(text: "try another email address.")
        btn.addTarget(self, action: #selector(otherEmailClicked), for: .touchUpInside)
        stack3.addArrangedSubview(btn)
        
        let imageView = UIImageView()
        imageView.image = UIImage(named: "no-associated-spaces-noText")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
        
        
        stack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 315/375).isActive = true
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
        stack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 192/812).isActive = true
        
        imageView.topAnchor.constraint(equalTo: stack.bottomAnchor).isActive = true
        imageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        let createSpaceBtn = UIButton()
        view.addSubview(createSpaceBtn)
        createSpaceBtn.translatesAutoresizingMaskIntoConstraints = false
        createSpaceBtn.backgroundColor = Color.buttonClickable
        createSpaceBtn.setTitle("Create New Space", for: .normal)
        createSpaceBtn.titleLabel?.font = UIFont(name: "Apercu Bold", size: 16)
        createSpaceBtn.setTitleColor(.white, for: .normal)
        createSpaceBtn.clipsToBounds = true
        createSpaceBtn.cornerRadius = 7
        createSpaceBtn.addTarget(self, action: #selector(BottomButtonMethod), for: .touchUpInside)
        
        createSpaceBtn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -35).isActive = true
        createSpaceBtn.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        createSpaceBtn.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 305/375).isActive = true
        createSpaceBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        
    }
    
    @objc func BottomButtonMethod() {
        let nextVC = SetupOrganizationViewController()
        nextVC.navigationController?.navigationBar.isHidden = false
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    
    @objc func otherEmailClicked() {
        localUser.signOut()
        let nextVC = StartScreenViewController()
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }

}

///Shameless copy from StackOverflow to underline UIButton text:
///https://stackoverflow.com/questions/2630004/underlining-text-in-uibutton
extension UIButton {
    func underlineButton(text: String) {
        let titleString = NSMutableAttributedString(string: text)
        titleString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: NSMakeRange(0, text.count))
        self.setAttributedTitle(titleString, for: .normal)
    }
}
