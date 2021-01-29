//
//  NewPostViewController.swift
//  Sillo
//
//  Created by Angelica Pan on 1/29/21.
//

import UIKit

class NewPostViewController: UIViewController {
    
    //MARK: init exit button
    let exitButton: UIImageView = {
        let image = UIImage(named: "exit")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: init post button
    let newPostButton: UIButton = {
        let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.titleLabel?.font = Font.bold(17)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Color.buttonClickable
        button.addTarget(self, action: #selector(createPost(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    
    //MARK: init Header label
    let headerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1;
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = Font.bold(24)
        label.text = "New Post"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    //MARK: init anonymous profile picture
    let profilepic: UIImageView = {
        let image = UIImage(named: "profileplaceholder") //TODO: replace with finalized image
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    //MARK: init textfield
    let postTextField: UITextField = {
        let textView = UITextField()
        textView.placeholder = "Say something nice..."
        textView.textColor = UIColor.lightGray
        textView.backgroundColor = UIColor.blue
        textView.font = Font.regular(17)
        textView.layer.backgroundColor = CGColor.init(red: 33, green: 33, blue: 33, alpha: 0.5) //TODO: remove this once sizing constraints complete
        //textField.keyboardType = .emailAddress
        textView.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    //MARK: init giphy space

    override func viewDidLoad() {
        super.viewDidLoad()
//        postTextField.delegate = self

        // Do any additional setup after loading the view.
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .white
        
        //MARK: exitButton
        view.addSubview(exitButton)
        exitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        
        //MARK: newPost headerview
        view.addSubview(newPostButton)
        newPostButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        newPostButton.centerYAnchor.constraint(equalTo: exitButton.centerYAnchor, constant: 0).isActive = true
        newPostButton.addTarget(self, action: #selector(createPost), for: .touchUpInside)
        newPostButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        newPostButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
      
        //MARK: new post header label
        view.addSubview(headerLabel)
        headerLabel.topAnchor.constraint(equalTo: exitButton.topAnchor, constant: 40).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        
//        //MARK: profilepic
        view.addSubview(profilepic)
        profilepic.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        profilepic.topAnchor.constraint(equalTo: headerLabel.topAnchor, constant: 50).isActive = true
//
//        //MARK: textfield
        view.addSubview(postTextField)
        postTextField.leadingAnchor.constraint(equalTo: profilepic.leadingAnchor, constant: 50).isActive = true
        postTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        postTextField.topAnchor.constraint(equalTo: exitButton.bottomAnchor, constant: 50).isActive = true
        
        //MARK: giphy field
        //TODO: add this
        
       
    }
    
//    func textViewDidBeginEditing(_ textView: UITextView) {
//        if textView.textColor == UIColor.lightGray {
//            textView.text = nil
//            textView.textColor = UIColor.black
//        }
//    }
//
//    func textViewDidEndEditing(_ textView: UITextView) {
//        if textView.text.isEmpty {
//            textView.text = "Placeholder"
//            textView.textColor = UIColor.lightGray
//        }
//    }
    
    //User pressed post button
    @objc func createPost(_:UIButton) {
        print("TODO: add post to firebase")
    }
    
    //User pressed exit button
    @objc func exitPressed(_:UIImage) {
        print("TODO: return to home page")
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
