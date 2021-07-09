//
//  NewPostViewController.swift
//  Sillo
//
//  Created by Angelica Pan on 1/29/21.
//

import Firebase
import GiphyUISDK
import UIKit
import FloatingPanel


class NewPostViewController: UIViewController, UITextViewDelegate {
    
    var posterImageName: String = "avatar-1"
    let stickerFloatingPanel = FloatingPanelController()
    var selectedContentType: GPHContentType?
    var showMoreByUser: String?
    
    var conversation: [ChatMessage] = []
    var selectedGifId: String = ""
    
    private var latestButtonPressTimestamp: Date = Date()
    private var DEBOUNCE_LIMIT: Double = 0.9 //in seconds
    
    var imageViewHeightConstraint: NSLayoutConstraint?
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 30
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView(frame: .zero, collectionViewLayout: layout)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: init exit button
    let exitButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "exit"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    //MARK: init post button
    let newPostButton: UIButton = {
        let button = UIButton()
        button.setTitle("Post", for: .normal)
        button.titleLabel?.font = UIFont(name: "Apercu-Bold", size: 17)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Color.buttonClickableUnselected
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
        label.font = UIFont(name: "Apercu-Bold", size: 24)
        label.text = "New Post"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        return label
    }()

    //MARK: init anonymous profile picture
    let profilepic: UIImageView = {
        let image = UIImage(named: "avatar-1") //TODO: replace with randomized profile pic
        let imageView = UIImageView(image: image)
        imageView.contentMode = .center
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFit
       
        return imageView
    }()
    
    let PLACEHOLDER_TEXT = "Ask something anonymously to \(organizationData.currOrganizationName ?? "your organization")..."

    
    //MARK: init textview
    let textView: UITextView = {
        let textView = UITextView()
        textView.text = "Ask something anonymously to \(organizationData.currOrganizationName ?? "your organization")..."
        textView.textColor = UIColor.lightGray
        textView.backgroundColor = UIColor.white
        textView.font = UIFont(name: "Apercu-Regular", size: 17)
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
    
    //MARK: sticker image view
    public let stickerImageView: UIImageView = {
        let imgView = UIImageView()
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        return imgView
    }()
    
    var stickerName: String = ""
    var imageView = GPHMediaView()
    var media: GPHMedia?

    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        // Do any additional setup after loading the view.
        setupView()
        textView.text = PLACEHOLDER_TEXT
        textView.textColor = UIColor.lightGray
        textView.becomeFirstResponder()
        textView.selectedTextRange = textView.textRange(from: textView.beginningOfDocument, to: textView.beginningOfDocument)
        Giphy.configure(apiKey: "Z5AW2zezCf4gtUQEOh379fYxxqfLzPYX")
        
        stickerFloatingPanel.delegate = self
        stickerFloatingPanel.layout = MyFloatingPanelLayout()
        stickerFloatingPanel.behavior = MyFloatingPanelBehavior()
        stickerFloatingPanel.isRemovalInteractionEnabled = true
        
        let apperance = SurfaceAppearance()
        apperance.cornerRadius = 25
        stickerFloatingPanel.surfaceView.appearance = apperance
        let contentVC = StickerPickerViewController()
        contentVC.delegate = self
        stickerFloatingPanel.set(contentViewController: contentVC)
        stickerFloatingPanel.track(scrollView: contentVC.stickerCollectionView!)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkNewUser()
    }
    
    func checkNewUser() {
        
        if !UserDefaults.standard.bool(forKey: "alreadySeenPopup") {
            let vc = AlertView(headingText: "🚨 New Feature Alert 🚨", messageText: "Click on the Sticker button when writing your post to add a sticker", action1Label: "Sounds good", action1Color: Color.burple, action1Completion: {
                self.dismiss(animated: true, completion: nil)
            }, action2Label: "", action2Color: .gray, action2Completion: { return }, withCancelBtn: false, image: nil, withOnlyOneAction: true)
            
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
            UserDefaults.standard.setValue(true, forKey: "alreadySeenPopup")
        } else {
            return
        }
    }
    
    func setupView() {
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .white
        
        //MARK: exitButton
        view.addSubview(exitButton)
        exitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        exitButton.addTarget(self, action: #selector(exitPressed(_:)), for: .touchUpInside)
        
        
        //MARK: newPost headerview
        view.addSubview(newPostButton)
        newPostButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        newPostButton.centerYAnchor.constraint(equalTo: exitButton.centerYAnchor, constant: 0).isActive = true
        newPostButton.addTarget(self, action: #selector(createPost), for: .touchUpInside)
        newPostButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        newPostButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
      
        //MARK: new post header label
        view.addSubview(headerLabel)
        headerLabel.topAnchor.constraint(equalTo: exitButton.topAnchor, constant: 55).isActive = true
        headerLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        
        //MARK: profilepic
        view.addSubview(profilepic)
        profilepic.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        profilepic.topAnchor.constraint(equalTo: headerLabel.topAnchor, constant: 50).isActive = true
        profilepic.widthAnchor.constraint(equalToConstant: 35).isActive = true
        profilepic.heightAnchor.constraint(equalToConstant: 35).isActive = true
        posterImageName = chatHandler.generateImageName()
        profilepic.image = UIImage(named:"\(posterImageName)")
        
        //textView
        view.addSubview(textView)
        textView.leadingAnchor.constraint(equalTo: profilepic.leadingAnchor, constant: 50).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        textView.topAnchor.constraint(equalTo: profilepic.topAnchor, constant: 0).isActive = true
        textView.becomeFirstResponder()
        
        //collectionview for gifs
        view.addSubview(collectionView)
        collectionView.leftAnchor.constraint(equalTo: view.safeLeftAnchor).isActive = true
        collectionView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20).isActive = true
        collectionView.rightAnchor.constraint(equalTo: view.safeRightAnchor).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant:500).isActive = true
        collectionView.register(ChatCell.self, forCellWithReuseIdentifier: ChatCell.id)
        collectionView.contentInset = UIEdgeInsets(top: 40, left: 30, bottom: 20, right: 0)
        collectionView.backgroundColor = .clear
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.isScrollEnabled = false
        
        view.addSubview(stickerImageView)
        stickerImageView.widthAnchor.constraint(equalToConstant: 112).isActive = true
        stickerImageView.heightAnchor.constraint(equalToConstant: 112).isActive = true
        stickerImageView.leadingAnchor.constraint(equalTo: textView.leadingAnchor).isActive = true
        stickerImageView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20).isActive = true
        
        let toolBar = UIToolbar(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 50))
        toolBar.barStyle = UIBarStyle.default
        let gifButton = UIBarButtonItem(image: UIImage(named: "file")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(addGifPressed(_:)))
        let stickerButton = UIBarButtonItem(image: UIImage(named: "stickers-1")?.withRenderingMode(.alwaysOriginal), style: .plain, target: self, action: #selector(addStickerPressed(_:)))
        let negativeSeperator = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        negativeSeperator.width = 12
        
           toolBar.items = [
            negativeSeperator,
           gifButton,
           negativeSeperator,
           stickerButton,
        ]
        
        toolBar.sizeToFit()
        toolBar.isTranslucent = false
        //toolBar.barTintColor = Color.burple
        textView.inputAccessoryView = toolBar
        
    }
    
    
    func addSticker(img: UIImage, name: String) {
        print("img passed in: \(img)")
        //remove the gifs if already in the VC
        self.conversation = []
        self.selectedGifId = ""
        self.collectionView.reloadData()
        
        //add image
        self.stickerImageView.image = img
        self.stickerName = name
    }
    
    func removeSticker() {
        self.stickerImageView.image = nil
        self.stickerName = ""
    }
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
            newPostButton.backgroundColor = Color.buttonClickable
        }
        stickerFloatingPanel.willMove(toParent: nil)
        stickerFloatingPanel.hide(animated: true) {
            self.stickerFloatingPanel.dismiss(animated: true, completion: nil)
        }
    }

    
    
    func textViewShouldBeginEditing(_ textView: UITextView) {
      if textView.textColor == .lightGray {
        //textView.text = ""
        textView.textColor = .black
      }
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if textView.text == PLACEHOLDER_TEXT {
            textView.text = ""
        }
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
    if textView.text.isEmpty {
    textView.text = PLACEHOLDER_TEXT
    textView.textColor = UIColor.lightGray
    }
    }
    
    func textViewDidChange(_ textView: UITextView) {
    let currText = textView.text
        if currText == PLACEHOLDER_TEXT {
        textView.textColor = .lightGray
        } else {
        textView.textColor = .black
        }
        
        if currText == "" {
            textView.text = PLACEHOLDER_TEXT
            textView.textColor = .lightGray
            let newPosition = textView.beginningOfDocument
            textView.selectedTextRange = textView.textRange(from: newPosition, to: newPosition)
        }
    }
    
    //User pressed post button
    @objc func createPost(_: UIButton) {
        
        stickerFloatingPanel.willMove(toParent: nil)
        stickerFloatingPanel.hide(animated: false) {
            self.stickerFloatingPanel.dismiss(animated: false, completion: nil)
        }
        
        let requestThrottled: Bool = -self.latestButtonPressTimestamp.timeIntervalSinceNow < self.DEBOUNCE_LIMIT
        
        if (requestThrottled) {
            return
        }
        let postText = textView.text.filter {$0 != " "}
        
        if (postText.count > 300) {
            let vc = AlertView(headingText: "Character Limit Exceeded", messageText: "", action1Label: "Go back", action1Color: Color.burple, action1Completion: {
                self.dismiss(animated: true, completion: nil)
            }, action2Label: "", action2Color: .gray, action2Completion: { return }, withCancelBtn: false, image: nil, withOnlyOneAction: true)
            
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
        else if (postText.count > 0 && postText != PLACEHOLDER_TEXT.filter {$0 != " "}) {
            textView.resignFirstResponder()
            self.latestButtonPressTimestamp = Date()
//            let attachment = media?.id ?? ""
            var attachment = ""
            if stickerName == "" {
                attachment = selectedGifId
            } else {
                attachment = stickerName
            }
           
            let poster = Constants.FIREBASE_USERID!
            let poster_alias = chatHandler.generateAlias()
            
            feed.addPost(attachment: attachment ?? "", postText: textView.text, poster: poster, posterAlias: poster_alias, posterImageName: posterImageName)
            self.dismiss(animated: true, completion: nil)
            print("DISMISSED")
            //log new post
            analytics.log_create_post()
            
            //update quest if newPost is a subtask
            quests.updateQuestProgress(typeToUpdate: "newPost")
            
        }
        else {
            DispatchQueue.main.async {
                let alert = AlertView(headingText: "Empty posts are no fun, write something!", messageText: "", action1Label: "Okay", action1Color: Color.burple, action1Completion: {
                    self.dismiss(animated: true, completion: nil)
                }, action2Label: "Nil", action2Color: .gray, action2Completion: {
                }, withCancelBtn: false, image: nil, withOnlyOneAction: true)
                alert.modalPresentationStyle = .overCurrentContext
                alert.modalTransitionStyle = .crossDissolve
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        
    }
    

    
    
    //User pressed exit button
    @objc func exitPressed(_:UIImage) {
        
        stickerFloatingPanel.willMove(toParent: nil)
        stickerFloatingPanel.hide(animated: false) {
            self.stickerFloatingPanel.dismiss(animated: false, completion: nil)
        }
        
        if textView.text.count == 0 && stickerImageView.image == nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            let vc = AlertView(headingText: "Are you sure you want to exit?", messageText: "If you exit now, your post will be discarded", action1Label: "Nevermind", action1Color: .gray, action1Completion: {
                self.dismiss(animated: true, completion: nil)
            }, action2Label: "Discard", action2Color: Color.salmon, action2Completion: {
                self.dismiss(animated: true, completion: nil)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.dismiss(animated: true, completion: nil)
                }
            }, withCancelBtn: false, image: nil, withOnlyOneAction: false)
            
            vc.modalTransitionStyle = .crossDissolve
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    func addMessageToConversation(text: String? = nil, media: GPHMedia? = nil, user: ChatUser = .sueRender) {
        let indexPath = IndexPath(row: conversation.count, section: 0)
        self.conversation = [ChatMessage(text: text, user: user, media: media)]
        self.selectedGifId = media!.id
        self.collectionView.reloadData()
    
    }
    
    
    //User pressed gif button
    @objc func addGifPressed(_:UIButton) {
        let giphy = GiphyViewController()
        giphy.theme = GPHTheme(type: GPHThemeType.light)
        giphy.mediaTypeConfig = [.gifs, .stickers]
        GiphyViewController.trayHeightMultiplier = 0.7
        giphy.showConfirmationScreen = false
        giphy.shouldLocalizeSearch = true
        giphy.delegate = self
        giphy.dimBackground = true
        giphy.rating = .ratedPG13
        giphy.modalPresentationStyle = .overCurrentContext
//        self.tabBarController?.setTabBar(hidden: true)
        present(giphy, animated: true, completion: nil)
    }
    
    //User pressed sticker button
    @objc func addStickerPressed(_:UIButton) {
        textView.resignFirstResponder()
        self.present(stickerFloatingPanel, animated: true, completion: nil)
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
        bubbleView.heightAnchor.constraint(equalToConstant: 250).isActive = true
//        bubbleView.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        bubbleView.widthAnchor.constraint(equalTo: textView.widthAnchor, multiplier: media.aspectRatio).isActive = true
        bubbleView.layer.masksToBounds = false

        bubbleView.layer.backgroundColor = UIColor.systemPink.cgColor //just for debugging size
        bubbleView.layer.cornerRadius = 16
        bubbleView.layer.borderWidth = 2
        bubbleView.layer.borderColor = UIColor.lightGray.cgColor
    
        
        ///TODO: add x button to remove gif
        
        view.addSubview(imageView)
        imageView.media = media
        imageView.widthAnchor.constraint(equalTo: textView.widthAnchor).isActive = true
        imageView.heightAnchor.constraint(equalTo: imageView.widthAnchor, multiplier: 1/media.aspectRatio).isActive = true
        imageView.leadingAnchor.constraint(equalTo: textView.leadingAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: textView.bottomAnchor, constant: 20).isActive = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.layer.masksToBounds = true
        imageView.clipsToBounds = true
        imageView.mask = bubbleView
        
        print(media.aspectRatio)
        
        imageView.isUserInteractionEnabled = false
        imageView.layer.cornerRadius = 10
    }
    
//    func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia) {
//        // user tapped a GIF!
//        print("user tapped a GIF!")
//        giphyViewController.dismiss(animated: true, completion: nil)
//        self.media = media
//        addMedia()
//        GPHCache.shared.clear()
//    }
    
    func didSelectMedia(giphyViewController: GiphyViewController, media: GPHMedia) {
        //remove sticker if gif added (only one media at any time)
        removeSticker()
        showMoreByUser = nil
        self.selectedContentType = giphyViewController.selectedContentType
        self.media = media
        giphyViewController.dismiss(animated: true, completion: { [weak self] in
            self?.addMessageToConversation(text: nil, media: media)
            guard self?.conversation.count ?? 0 > 7 else { return }
        })
        GPHCache.shared.clear()
    }
    
    func didDismiss(controller: GiphyViewController?) {
        // user dismissed the controller without selecting a GIF.
        GPHCache.shared.clear()
    }
}

extension UITabBarController {
    func setTabBar( hidden: Bool, animated: Bool = true, along transitionCoordinator: UIViewControllerTransitionCoordinator? = nil) {
        guard isTabBarHidden != hidden else { return }

        let offsetY = hidden ? tabBar.frame.height : -tabBar.frame.height
        let endFrame = tabBar.frame.offsetBy(dx: 0, dy: offsetY)
        let vc: UIViewController? = viewControllers?[selectedIndex]
        var newInsets: UIEdgeInsets? = vc?.additionalSafeAreaInsets
        let originalInsets = newInsets
        newInsets?.bottom -= offsetY

        func set(childViewController cvc: UIViewController?, additionalSafeArea: UIEdgeInsets) {
            cvc?.additionalSafeAreaInsets = additionalSafeArea
            cvc?.view.setNeedsLayout()
        }

        // Update safe area insets for the current view controller before the animation takes place when hiding the bar.
        if hidden, let insets = newInsets { set(childViewController: vc, additionalSafeArea: insets) }

        guard animated else {
            tabBar.frame = endFrame
            return
        }

        // Perform animation with coordinato if one is given. Update safe area insets _after_ the animation is complete,
        // if we're showing the tab bar.
        weak var tabBarRef = self.tabBar
        if let tc = transitionCoordinator {
            tc.animateAlongsideTransition(in: self.view, animation: { _ in tabBarRef?.frame = endFrame }) { context in
                if !hidden, let insets = context.isCancelled ? originalInsets : newInsets {
                    set(childViewController: vc, additionalSafeArea: insets)
                }
            }
        } else {
            UIView.animate(withDuration: 0.3, animations: { tabBarRef?.frame = endFrame }) { didFinish in
                if !hidden, didFinish, let insets = newInsets {
                    set(childViewController: vc, additionalSafeArea: insets)
                }
            }
        }
    }

    /// `true` if the tab bar is currently hidden.
    var isTabBarHidden: Bool {
        return !tabBar.frame.intersects(view.frame)
    }
}


extension NewPostViewController: FloatingPanelControllerDelegate {
    
    
    
}

extension NewPostViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let index = indexPath.item
        guard index < conversation.count else { return .zero }
        let message = conversation[index]
        if let media = message.media {
            let isEmoji = media.pingbacksEventType == .emoji
            let size = CGSize(width: media.images?.original?.width ?? 1, height: media.images?.original?.height ?? 1)
            let ratio = size.width / size.height
            return CGSize(width: collectionView.bounds.size.width, height: (isEmoji ? ChatCell.emojiBubbleWidth : ChatCell.bubbleWidth) / ratio)
        }
        guard let text = message.text else { return .zero }
        let targetSize = CGSize(width: ChatCell.bubbleWidth - ChatCell.padding * 2, height: .greatestFiniteMagnitude)
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byWordWrapping
        let textRect = text.boundingRect(with: targetSize, options: .usesLineFragmentOrigin, attributes: [.font: ChatCell.font, .paragraphStyle: style], context: nil)
        return CGSize(width: collectionView.bounds.size.width, height: ceil(textRect.height + ChatCell.padding * 2))
    }
}

class MyFloatingPanelLayout: FloatingPanelLayout {
    let position: FloatingPanelPosition = .bottom
    let initialState: FloatingPanelState = .half
    var anchors: [FloatingPanelState: FloatingPanelLayoutAnchoring] {
        return [
            .half: FloatingPanelLayoutAnchor(fractionalInset: 0.5, edge: .bottom, referenceGuide: .safeArea),
        ]
    }
}

class MyFloatingPanelBehavior: FloatingPanelBehavior {
    func allowsRubberBanding(for edge: UIRectEdge) -> Bool {
        return false
    }
}

enum ChatUser: Int {
    case abraHam
    case sueRender
    
    var avatar: GiphyYYImage? {
        switch self {
        case .abraHam: return GiphyYYImage(contentsOfFile: Bundle.main.path(forResource: "abraham", ofType: "gif") ?? "")
        case .sueRender: return GiphyYYImage(contentsOfFile: Bundle.main.path(forResource: "suerender", ofType: "gif") ?? "")
        }
    }
    
    var isMe: Bool {
        switch self {
        case .abraHam: return false
        case .sueRender: return true
        }
    }
}

struct ChatMessage {
    var text: String?
    var user: ChatUser
    var media: GPHMedia?
    
    init(text: String? = "", user: ChatUser, media: GPHMedia? = nil) {
        self.text = text
        self.user = user
        self.media = media
    }
}

extension NewPostViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let genericCell = collectionView.dequeueReusableCell(withReuseIdentifier: ChatCell.id, for: indexPath)
        guard let cell = genericCell as? ChatCell else { return genericCell }
        let message = conversation[indexPath.item]
        cell.media = message.media
        cell.text = message.text
        cell.avatarImage = message.user.avatar
        cell.isReply = message.user == .abraHam
        cell.imageView.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(gifTapped(tapGestureRecognizer:)))
        cell.imageView.addGestureRecognizer(tapGestureRecognizer)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return conversation.count
    }
    
    //when a gif is tapped, we remove it from the view
    @objc func gifTapped(tapGestureRecognizer:UITapGestureRecognizer) {
        self.conversation = []
        self.selectedGifId = ""
        self.collectionView.reloadData()
    }
}
    

extension NewPostViewController: GPHMediaViewDelegate {
    func didPressMoreByUser(_ user: String) {
        showMoreByUser = user
        //addGifPressed(_:)
    }
}



