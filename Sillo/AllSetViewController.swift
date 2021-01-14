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
            label.font = Font.bold(32)
              label.text = "Kudos! Your Sillo space is all set up."
              label.translatesAutoresizingMaskIntoConstraints = false
              return label
          }()
    
      //MARK: init success image
         let successImage: UIImageView = {
             let image = UIImage(named: "onboardingSillo")
             let imageView = UIImageView(image: image)
             imageView.contentMode = .left
             imageView.translatesAutoresizingMaskIntoConstraints = false
             return imageView
         }()
    
    
          //MARK: init body text label
          let bodyLabel: UILabel = {
              let label = UILabel()
              label.numberOfLines = 2;
              label.lineBreakMode = NSLineBreakMode.byWordWrapping
              label.font = Font.regular(17)
              label.text = "Get things going – post a question to start interacting with your teammates. "
              label.translatesAutoresizingMaskIntoConstraints = false
              return label
          }()
       
       //MARK: init new post button
          let newPostButton: UIButton = {
              let button = UIButton()
              button.setTitle("Enable Notifications", for: .normal)
              button.titleLabel?.font = Font.bold(20)
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
             
             //MARK: logotype
             view.addSubview(successImage)
             successImage.widthAnchor.constraint(equalToConstant: 132).isActive = true
             successImage.heightAnchor.constraint(equalToConstant: 61).isActive = true
             successImage.topAnchor.constraint(equalTo: view.topAnchor,constant: 91).isActive = true
             successImage.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
             
             //MARK: header label
             view.addSubview(headerLabel)
             headerLabel.widthAnchor.constraint(equalToConstant: 280).isActive = true
             headerLabel.heightAnchor.constraint(equalToConstant: 34).isActive = true
             headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
           headerLabel.topAnchor.constraint(equalTo: successImage.bottomAnchor, constant: 180).isActive = true
             
             //MARK: body label
             view.addSubview(bodyLabel)
             bodyLabel.widthAnchor.constraint(equalToConstant: 280).isActive = true
             bodyLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
             bodyLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 30).isActive = true

             //MARK: enable notifications button
             view.addSubview(newPostButton)
             newPostButton.widthAnchor.constraint(equalToConstant: 300).isActive = true
             newPostButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
             newPostButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
             newPostButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 530).isActive = true
           
    
                
       }
    
    //User pressed enable notifications button
    @objc func actionButton(_:UIButton) {
        print("TODO: Go to Home / Post")
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
