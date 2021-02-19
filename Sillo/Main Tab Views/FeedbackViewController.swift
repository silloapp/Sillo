//
//  FeedbackViewController.swift
//  Sillo
//
//  Created by Angelica Pan on 2/20/21.
//


import UIKit

class FeedbackViewController: UIViewController, UITextViewDelegate {
    
    //MARK: init success label
    let text: UILabel = {
        let label = UILabel()
        label.font = Font.regular(17)
        label.numberOfLines = 3
        label.text = "Help us improve your experience with Sillo. Let us know how we can make it better:"
        label.textAlignment = .left
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: init textview
    let textView: UITextView = {
        let textView = UITextView()
        textView.text = "Send us some feedback..."
        textView.textColor = UIColor.darkGray
        textView.textAlignment = .left
        textView.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 1.00)
        textView.font = Font.regular(17)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        textView.clipsToBounds = true;
        textView.layer.cornerRadius = 10.0;
        return textView
    }()
    
    let newPostButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send Feedback", for: .normal)
        button.titleLabel?.font = Font.bold(20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Color.buttonClickable
        button.addTarget(self, action: #selector(actionButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    

    let header : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.navBar
        return view
    }()
    
    
    let menuItemTableView = UITableView() // view
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        setupHeader()
        textView.delegate = self
        view.backgroundColor = .white
        view.addSubview(text)
        text.topAnchor.constraint(equalTo: header.bottomAnchor, constant: 20).isActive = true
        text.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32).isActive = true
        text.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32).isActive = true
        text.heightAnchor.constraint(equalToConstant: 70).isActive = true
        
        view.addSubview(textView)
        textView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32).isActive = true
        textView.heightAnchor.constraint(greaterThanOrEqualToConstant: 150).isActive = true
        textView.topAnchor.constraint(equalTo: text.bottomAnchor, constant: 5).isActive = true
        
        //MARK: new post button
        view.addSubview(newPostButton)
        newPostButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32).isActive = true
        newPostButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32).isActive = true
        newPostButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        newPostButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        newPostButton.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20).isActive = true

    }
    
   
    

    
    func setupPhotoTeamName() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 100
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let icon = UIImageView()
        icon.image = UIImage(named: "Backward Arrow")
        icon.heightAnchor.constraint(equalToConstant: 17).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 10).isActive = true
        icon.contentMode = .scaleAspectFit
       
        stack.addArrangedSubview(icon)
        
        
         let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backTapped(tapGestureRecognizer:)))
         icon.isUserInteractionEnabled = true
         icon.addGestureRecognizer(tapGestureRecognizer)
        
        let tabName = UILabel()
        tabName.text = "Feedback"
        tabName.font = Font.bold(22)
        tabName.textColor = Color.teamHeader
        tabName.widthAnchor.constraint(equalToConstant: 200).isActive = true
        
        stack.addArrangedSubview(tabName)
        
        return stack
    }
    
    func setupHeader() {
        view.addSubview(header)
        
        header.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        header.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: 132).isActive = true
        
        
        //app logo and team name stack
        let logoTeamStack = setupPhotoTeamName()
        header.addSubview(logoTeamStack)
        
        logoTeamStack.leadingAnchor.constraint(equalTo: header.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        logoTeamStack.topAnchor.constraint(equalTo: header.safeAreaLayoutGuide.topAnchor).isActive = true
        logoTeamStack.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -15).isActive = true
        logoTeamStack.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        //team picture
            //        let icon = UIImageView()
            //        icon.image = UIImage(named: "Backward Arrow")
            //        icon.heightAnchor.constraint(equalToConstant: 17).isActive = true
            //        icon.widthAnchor.constraint(equalToConstant: 10).isActive = true
            //        icon.contentMode = .scaleAspectFit
            //        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(backTapped(tapGestureRecognizer:)))
            //        icon.isUserInteractionEnabled = true
            //        icon.addGestureRecognizer(tapGestureRecognizer)
            //        header.addSubview(icon)
            //
            //        let tabName = UILabel()
            //        tabName.text = "Settings"
            //        tabName.font = Font.bold(22)
            //        tabName.textColor = Color.teamHeader
            //        header.addSubview(tabName)
            //
            //
            //        icon.topAnchor.constraint(equalTo: header.safeAreaLayoutGuide.topAnchor).isActive = true
            //        icon.leadingAnchor.constraint(equalTo: header.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
            //        tabName.centerXAnchor.constraint(equalTo: header.centerXAnchor, constant: 0).isActive = true
            //        tabName.centerYAnchor.constraint(equalTo: icon.centerYAnchor, constant:0 ).isActive = true
            //        tabName.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        
        
        


    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.darkGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Send us some feedback..."
            textView.textColor = UIColor.darkGray
        }
    }
    
    
    @objc func backTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        print("Going back to previous VC... ")
        self.navigationController?.popViewController(animated: true)
    }
    
    //User pressed enable notifications button
    @objc func actionButton(_:UIButton) {
        print("TODO: submit the feedback")
        print(textView.text)
    }
    

}
