//
//  NewPostViewController.swift
//  Sillo
//
//  Created by Angelica Pan on 1/29/21.
//

import UIKit
import GiphyUISDK

class NewPostViewController: UIViewController, UITextViewDelegate {
    var imageViewHeightConstraint: NSLayoutConstraint?
    
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
        let image = UIImage(named: "anon_profile") //TODO: replace with randomized profile pic
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
       
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
    
    //MARK: init textview
    let textView: UITextView = {
        let textView = UITextView()
        textView.text = "Say something nice..."
        textView.textColor = UIColor.lightGray
        textView.backgroundColor = UIColor.white
        textView.font = Font.regular(17)
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.isScrollEnabled = false
        return textView
    }()
    
    //MARK: init giphy space
    let bubbleView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var imageView = GPHMediaView()
    var media: GPHMedia?

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        // Do any additional setup after loading the view.
        addHomeView()
        Giphy.configure(apiKey: "Z5AW2zezCf4gtUQEOh379fYxxqfLzPYX")
        
        

    }
    
    func addHomeView() {
        
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
        profilepic.topAnchor.constraint(equalTo: headerLabel.topAnchor, constant: 40).isActive = true
        profilepic.widthAnchor.constraint(equalToConstant: 35).isActive = true
        profilepic.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        //textiview
        view.addSubview(textView)
        textView.leadingAnchor.constraint(equalTo: profilepic.leadingAnchor, constant: 50).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        textView.topAnchor.constraint(equalTo: profilepic.topAnchor, constant: 0).isActive = true
        
        
        //MARK: giphy field
        //TODO: add this
        
       
        
        // UITOOLBAR
        //for some reason these images don't show up as UIBarButtonItems :/
//        let giphyImage = UIImage(named: "GIPHY_logo")?.withRenderingMode(.alwaysOriginal)
//        let stickerImage = UIImage(named: "sticker_logo")?.withRenderingMode(.alwaysOriginal)
      
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
           toolBar.barStyle = UIBarStyle.default
           toolBar.items = [
            UIBarButtonItem(title:"GIPHY", style: UIBarButtonItem.Style.plain, target: self, action: #selector(addGifPressed(_:))),
//            UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil),
            UIBarButtonItem(title:"Sticker", style: UIBarButtonItem.Style.plain, target: self, action: #selector(addStickerPressed(_:)))]
           toolBar.sizeToFit()

           textView.inputAccessoryView = toolBar    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Say something nice..."
            textView.textColor = UIColor.lightGray
        }
    }
    
    //User pressed post button
    @objc func createPost(_:UIButton) {
        print("TODO: add post to firebase")
    }
    
    //User pressed exit button
    @objc func exitPressed(_:UIImage) {
        print("TODO: return to home page")
    }
    
    //User pressed gif button
    @objc func addGifPressed(_:UIButton) {
        let giphy = GiphyViewController()
        giphy.theme = GPHTheme(type: GPHThemeType.lightBlur)
        giphy.mediaTypeConfig = [.gifs, .stickers]
        GiphyViewController.trayHeightMultiplier = 0.7
        giphy.showConfirmationScreen = false
        giphy.shouldLocalizeSearch = true
        giphy.delegate = self
        giphy.dimBackground = true
        giphy.rating = .ratedPG13
        giphy.modalPresentationStyle = .overCurrentContext
        present(giphy, animated: true, completion: nil)
    }
    
    //User pressed sticker button
    @objc func addStickerPressed(_:UIButton) {
        print("TODO: bring up sillo sticker half VC")
    }

}

extension NewPostViewController: GiphyDelegate {
    func didSearch(for term: String) {
        print("your user made a search! ", term)
    }
    
    
    func addMedia() {
        guard let media = media else { return }
        view.addSubview(bubbleView)
        //review this
        bubbleView.leadingAnchor.constraint(equalTo: profilepic.leadingAnchor, constant: 50).isActive = true
        bubbleView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        bubbleView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20).isActive = true
        bubbleView.layer.masksToBounds = false
        
        bubbleView.layer.cornerRadius = 16
        
        //TODO: remove this after debugging
        bubbleView.layer.borderWidth = 2
        bubbleView.layer.borderColor = UIColor.lightGray.cgColor
        
        
        //TODO: add x button to remove gif
        bubbleView.addSubview(imageView)
        imageView.media = media
        
        imageView.heightAnchor.constraint(equalTo: bubbleView.heightAnchor).isActive = true
        imageViewHeightConstraint = imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1/media.aspectRatio) //try 1/media.aspectRatio or 1/media.aspectRatio
        imageViewHeightConstraint?.isActive = true
        //imageView.centerYAnchor.constraint(equalTo: bubbleView.centerYAnchor).isActive = true
        imageView.leadingAnchor.constraint(equalTo: bubbleView.leadingAnchor).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        
        
        imageView.isUserInteractionEnabled = false
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        
        //set up bubbleview height
        bubbleView.heightAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        bubbleView.widthAnchor.constraint(equalTo: imageView.widthAnchor).isActive = true
    }
    
    func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia) {
        // user tapped a GIF!
        print("user tapped a GIF!")
        giphyViewController.dismiss(animated: true, completion: nil)
        self.media = media
        addMedia()
        GPHCache.shared.clear()
    }
    
    func didDismiss(controller: GiphyViewController?) {
        // user dismissed the controller without selecting a GIF.
        GPHCache.shared.clear()
    }
}
