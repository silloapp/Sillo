//
//  AllSetViewController.swift
//  Sillo
//
//  Created by Angelica Pan on 1/12/21.
//
import UIKit

class AllSetViewController: UIViewController {
    
    //MARK: init Header label
    let headerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 2;
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont(name: "Apercu-Bold", size: 32)
        label.textColor = Color.buttonClickable
        label.text = "Kudos!\r\nYou're all set up!"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    //MARK: init all set success image
    let successImage: UIImageView = {
        let image = UIImage(named: "allsetplaceholder") //TODO: replace with finalized image
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()

    //MARK: init body text label
    let bodyLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3;
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = UIFont(name: "Apercu-Regular", size: 17)
        label.text = "Get things going – post a question to start interacting with your teammates or respond to any post. "
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()
    
    //MARK: init new post button
    let newPostButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get Started", for: .normal)
        button.titleLabel?.font = UIFont(name: "Apercu-Bold", size: 20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Color.buttonClickable
        button.addTarget(self, action: #selector(actionButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()


    override func viewDidLoad() {

        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .white
        
        //MARK: header label
        view.addSubview(headerLabel)
        headerLabel.widthAnchor.constraint(equalToConstant: 280).isActive = true
        headerLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 100).isActive = true
        
        //MARK: init stack
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .center
        stack.distribution = .fillProportionally
        stack.spacing = 20
        stack.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(stack)
        stack.widthAnchor.constraint(equalTo: view.safeAreaLayoutGuide.widthAnchor).isActive = true
        stack.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        stack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor).isActive = true
        
        //MARK: successImage
        stack.addArrangedSubview(successImage)
        successImage.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor, constant: -30).isActive = true
        
        //MARK: body label
        stack.addArrangedSubview(bodyLabel)
        bodyLabel.widthAnchor.constraint(equalToConstant: 280).isActive = true
        bodyLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true

        //MARK: new post button
        view.addSubview(newPostButton)
        newPostButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
        newPostButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        newPostButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        newPostButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50).isActive = true
    }

    //User pressed enable notifications button
    @objc func actionButton(_:UIButton) {
        let nextVC = prepareTabVC()
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true)
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
