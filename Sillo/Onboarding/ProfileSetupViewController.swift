//
//  ProfileEditViewController.swift
//  Sillo
//
//  Created by William Loo on 2/25/21.
//

import UIKit
import Firebase
import GoogleSignIn

class ProfileSetupViewController: UIViewController{
    
    let pronounValues = ["pronouns not specified", "she/her", "he/him", "they/them"]
    
    private let name = Auth.auth().currentUser?.displayName
    var bioText: String = ""
    var pronouns: String = ""
    var restaurants : [String] = [ "Asha Tea House", "Tamon Tea", "Urbann Turbann"]
    var interests : [String] = ["Art", "Baking", "Cooking"]
    var useSeparateProfiles: Bool = true
    private var latestButtonPressTimestamp: Date = Date()
    private var DEBOUNCE_LIMIT: Double = 0.9 //in seconds
    
    var profilePic = UIImage(named: "placeholder profile")
    
    var imageViewHeightConstraint: NSLayoutConstraint?
    
    //MARK: Scroll view
    let scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    //MARK: init exit button
    let exitButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "back"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    //MARK: init set up profile header
    let headerLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1;
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = Font.bold(22)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Color.burple
        label.text = "Set up profile"
        label.textAlignment = .center
        return label
    }()
    
    //MARK: preview profile button
    let previewButton: UIButton = {
        let btn = UIButton()
        btn.setBackgroundImage(UIImage(named: "preview"), for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    //MARK: init anonymous profile picture
    let profilepic: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.clipsToBounds = true
        return imageView
    }()
    
    //MARK: button to go next to profilepic
    let choosePicButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let image = UIImage(named: "edit")
        button.setImage(image,for: .normal)
        button.contentMode = .scaleAspectFit
        button.addTarget(self, action: #selector(choosePic), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: picture picker
    var imagePicker: UIImagePickerController!
    
    //MARK: init profile tip label
    let profileTipLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3;
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = Font.regular(17)
        label.text = "Your profile picture will only be seen once you are revealed"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    //MARK: FIRST greyLine
    let firstGreyLine:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1.0
        view.layer.borderColor = Color.clouds.cgColor
        return view
    }()
    
    //MARK: init name label
    let nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1;
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = Font.bold(28)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    //MARK: SECOND greyLine
    let secondGreyLine:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1.0
        view.layer.borderColor = Color.clouds.cgColor
        return view
    }()
    
    //MARK: pronouns label
    let pronounsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1;
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = Font.bold(17)
        label.textColor = Color.matte
        label.text = "Pronouns"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    //MARK: pronouns text field
    let pronounsTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = " no pronouns specified"
        textField.layer.cornerRadius = 10.0;
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        textField.backgroundColor = Color.textFieldBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    //MARK: THIRD greyLine
    let thirdGreyLine:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1.0
        view.layer.borderColor = Color.clouds.cgColor
        return view
    }()
    
    //MARK: bio label
    let bioLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1;
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = Font.bold(17)
        label.textColor = Color.matte
        label.text = "Bio"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    //MARK: bio text view
    let bioTextView: UITextView = {
        let textView = UITextView()
        textView.text = ""
        textView.layer.cornerRadius = 10.0;
        textView.font = Font.regular(17)
        textView.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        textView.backgroundColor = Color.textFieldBackground
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    //MARK: FOURTH greyLine
    let fourthGreyLine:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1.0
        view.layer.borderColor = Color.clouds.cgColor
        return view
    }()
    
    //MARK: interest collectionview header label
    let collectionHeader: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1;
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = Font.bold(17)
        label.textColor = Color.matte
        label.text = "Interests"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    //MARK: interest collectionview
    let collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(CustomCell.self, forCellWithReuseIdentifier: "cell")
        cv.backgroundColor = .clear
        return cv
    }()
    
    //MARK: edit interests button
    let editInterestsButton: UIButton = {
      let button = UIButton()
        button.setTitle("Edit", for: .normal)
        button.titleLabel?.font = Font.bold(20)
        button.setTitleColor(Color.matte, for: .normal)
        button.backgroundColor = Color.textFieldBackground
        button.addTarget(self, action: #selector(selectInterests(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    //MARK: favorite restaurants label
    let favoriteRestaurantsLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1;
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = Font.bold(17)
        label.textColor = Color.matte
        label.text = "Favorite restaurants nearby"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    //MARK: restaurant text field 1
    let restaurantTextFieldOne: UITextField = {
        let textField = UITextField()
        textField.placeholder = " Asha Tea House"
        textField.text = ""
        textField.layer.cornerRadius = 10.0;
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        textField.backgroundColor = Color.textFieldBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    //MARK: restaurant text field 2
    let restaurantTextFieldTwo: UITextField = {
        let textField = UITextField()
        textField.placeholder = " Eureka"
        textField.text = ""
        textField.layer.cornerRadius = 10.0;
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        textField.backgroundColor = Color.textFieldBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    //MARK: restaurant text field 3
    let restaurantTextFieldThree: UITextField = {
        let textField = UITextField()
        textField.placeholder = " Thai Basil"
        textField.text = ""
        textField.layer.cornerRadius = 10.0;
        textField.layer.sublayerTransform = CATransform3DMakeTranslation(5, 0, 0)
        textField.backgroundColor = Color.textFieldBackground
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    //MARK: set profile label
    let setProfileLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1;
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        label.font = Font.regular(17)
        label.textColor = Color.matte
        label.text = "Set this as my profile for all orgs"
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        return label
    }()
    
    //MARK: use all org org switch (WARNING LOGIC IS INVERTED)
    //useSeparateProfiles = true, means switch is off
    //useSeparateProfiles = false means switch is on
    let allOrgSwitch: UISwitch = {
        let newSwitch = UISwitch()
        newSwitch.onTintColor = Color.burple
        newSwitch.addTarget(self, action:#selector(toggleSwitch(_:)), for: .valueChanged)
        newSwitch.translatesAutoresizingMaskIntoConstraints = false
        return newSwitch
    }()
    
    //MARK: FIFTH greyLine
    let fifthGreyLine:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 10
        view.layer.borderWidth = 1.0
        view.layer.borderColor = Color.clouds.cgColor
        return view
    }()
    
    //MARK: next button
    let nextButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.setTitle("Save Changes", for: .normal)
        button.titleLabel?.font = Font.bold(20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Color.buttonClickable
        button.addTarget(self, action: #selector(saveChanges(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    
    override func viewWillAppear(_ animated: Bool) {
        //reload necessary coming from selecting interest view
        collectionView.reloadData()
        self.pronouns = ""
        if self.pronouns != "no pronouns specified" {
            pronounsTextField.text = self.pronouns
        }
        bioTextView.text = self.bioText
        for (index, restaurant) in restaurants.enumerated() {
            switch index {
            case 0:
                restaurantTextFieldOne.text = restaurant
            case 1:
                restaurantTextFieldTwo.text = restaurant
            case 2:
                restaurantTextFieldThree.text = restaurant
            default:
                break
            }
        }
    }
    
    //MARK: VIEWDIDAPPEAR
    override func viewDidAppear(_ animated: Bool) {
        //scrollView.contentSize = CGSize(width: 0, height: 896.0)
        scrollView.contentSize = CGSize(width: 0, height: 1000) //fuck the keyboard thing.
    }

    //MARK: VIEWDIDLOAD
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        }
        self.view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(refreshProfilePicture), name: Notification.Name(rawValue: "refreshPicture"), object: nil)
        
        
        //MARK: exitButton
        view.addSubview(exitButton)
        exitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        exitButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        exitButton.widthAnchor.constraint(equalToConstant: 20).isActive = true
        exitButton.heightAnchor.constraint(equalToConstant: 25).isActive = true
        exitButton.addTarget(self, action: #selector(exitPressed(_:)), for: .touchUpInside)
        
        //MARK: header label
        view.addSubview(headerLabel)
        headerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        headerLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        headerLabel.widthAnchor.constraint(equalToConstant: 160).isActive = true
        
        //MARK: next button
        view.addSubview(nextButton)
        nextButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.8).isActive = true
        
        //MARK: previewButton
        view.addSubview(previewButton)
        previewButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        previewButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        previewButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        previewButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        previewButton.addTarget(self, action: #selector(previewPressed(_:)), for: .touchUpInside)
        
        //MARK: scrollview
        let tap = UITapGestureRecognizer(target: self, action: #selector(hideKeyboard))
        scrollView.addGestureRecognizer(tap)
        self.view.addSubview(scrollView)
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 1.0).isActive = true
        scrollView.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: -1.0).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: nextButton.topAnchor, constant: -20).isActive = true
        scrollView.isScrollEnabled = true
        
        //MARK: drop shadows (not working it seems D: )
        scrollView.layer.shadowOffset = CGSize(width:0, height:10)
        scrollView.layer.shadowRadius = 10
        scrollView.layer.shadowColor = UIColor.black.cgColor
        scrollView.layer.shadowOpacity = 0.15
        
        //MARK: profilepic
        profilepic.image = profilePic
        scrollView.addSubview(profilepic)
        profilepic.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10).isActive = true
        profilepic.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        profilepic.widthAnchor.constraint(equalToConstant: 120).isActive = true
        profilepic.heightAnchor.constraint(equalToConstant: 120).isActive = true
        
        //MARK: profile pic masking
        let maskImageView = UIImageView()
        maskImageView.contentMode = .scaleAspectFit
        maskImageView.image = UIImage(named: "profile_mask")
        maskImageView.frame = CGRect(x: 0, y: 0, width: 120, height: 120)
        profilepic.mask = maskImageView
        
        //MARK: picker
        self.imagePicker = UIImagePickerController()
        self.imagePicker.delegate = self
        self.imagePicker.sourceType = .photoLibrary
        
        //MARK: edit button
        scrollView.addSubview(choosePicButton)
        choosePicButton.topAnchor.constraint(equalTo: profilepic.bottomAnchor,constant: -40).isActive = true
        choosePicButton.rightAnchor.constraint(equalTo: profilepic.rightAnchor,constant: -10).isActive = true
        
        
        //MARK: profile pic tip
        profileTipLabel.font = Font.regular(dynamicFontSize(17))
        scrollView.addSubview(profileTipLabel)
        profileTipLabel.leadingAnchor.constraint(equalTo: profilepic.trailingAnchor, constant: 14).isActive = true
        profileTipLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        profileTipLabel.centerYAnchor.constraint(equalTo: profilepic.centerYAnchor, constant: 0).isActive = true
        
        //MARK: grey line under bio
        scrollView.addSubview(firstGreyLine)
        firstGreyLine.topAnchor.constraint(equalTo: profilepic.bottomAnchor, constant: 20).isActive = true
        firstGreyLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        firstGreyLine.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        firstGreyLine.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        //MARK: name label
        nameLabel.text = name
        scrollView.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: firstGreyLine.bottomAnchor, constant: 20).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        
        //MARK: second grey line under name label
        scrollView.addSubview(secondGreyLine)
        secondGreyLine.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 20).isActive = true
        secondGreyLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        secondGreyLine.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        secondGreyLine.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        //MARK: pronouns label
        scrollView.addSubview(pronounsLabel)
        pronounsLabel.topAnchor.constraint(equalTo: secondGreyLine.bottomAnchor, constant: 20).isActive = true
        pronounsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        
        
        //MARK: create pronoun picker
        createPronounPicker()
        
        //MARK: pronouns text field
        scrollView.addSubview(pronounsTextField)
        pronounsTextField.attributedPlaceholder =
            NSAttributedString(string: self.pronouns, attributes: [NSAttributedString.Key.foregroundColor : Color.matte])
        pronounsTextField.topAnchor.constraint(equalTo: pronounsLabel.bottomAnchor, constant: 5).isActive = true
        pronounsTextField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        pronounsTextField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        pronounsTextField.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        scrollView.addSubview(pronounsTextField)
        
        
        //MARK: third grey line under name label
        scrollView.addSubview(thirdGreyLine)
        thirdGreyLine.topAnchor.constraint(equalTo: pronounsTextField.bottomAnchor, constant: 20).isActive = true
        thirdGreyLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        thirdGreyLine.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        thirdGreyLine.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        //MARK: bio label
        scrollView.addSubview(bioLabel)
        bioLabel.topAnchor.constraint(equalTo: thirdGreyLine.bottomAnchor, constant: 20).isActive = true
        bioLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        
        //MARK: bio text field
        scrollView.addSubview(bioTextView)
        bioTextView.topAnchor.constraint(equalTo: bioLabel.bottomAnchor, constant: 5).isActive = true
        bioTextView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        bioTextView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        bioTextView.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        //MARK: collectionview header label
        scrollView.addSubview(collectionHeader)
        collectionHeader.heightAnchor.constraint(equalToConstant: 20).isActive = true
        collectionHeader.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        collectionHeader.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        collectionHeader.topAnchor.constraint(equalTo: bioTextView.bottomAnchor, constant: 20).isActive = true
        
        //MARK: interest collectionview
        scrollView.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.topAnchor.constraint(equalTo: collectionHeader.bottomAnchor, constant: 5).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30).isActive = true
        //collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        collectionView.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.6).isActive = true
        collectionView.heightAnchor.constraint(equalToConstant: 80).isActive = true
    
        //MARK: select interests button
        scrollView.addSubview(editInterestsButton)
        editInterestsButton.centerYAnchor.constraint(equalTo: collectionView.centerYAnchor, constant: -10).isActive = true
        editInterestsButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30).isActive = true
        editInterestsButton.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.2).isActive = true
        
        //MARK: fourth grey line
        scrollView.addSubview(fourthGreyLine)
        fourthGreyLine.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 20).isActive = true
        fourthGreyLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        fourthGreyLine.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        fourthGreyLine.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        //MARK: favorite restaurants label
        scrollView.addSubview(favoriteRestaurantsLabel)
        favoriteRestaurantsLabel.heightAnchor.constraint(equalToConstant: 20).isActive = true
        favoriteRestaurantsLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        favoriteRestaurantsLabel.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        favoriteRestaurantsLabel.topAnchor.constraint(equalTo: fourthGreyLine.bottomAnchor, constant: 20).isActive = true
        
        //MARK: first restaurant text field
        scrollView.addSubview(restaurantTextFieldOne)
        restaurantTextFieldOne.topAnchor.constraint(equalTo: favoriteRestaurantsLabel.bottomAnchor, constant: 5).isActive = true
        restaurantTextFieldOne.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        restaurantTextFieldOne.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        restaurantTextFieldOne.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        //MARK: second restaurant text field
        scrollView.addSubview(restaurantTextFieldTwo)
        restaurantTextFieldTwo.topAnchor.constraint(equalTo: restaurantTextFieldOne.bottomAnchor, constant: 5).isActive = true
        restaurantTextFieldTwo.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        restaurantTextFieldTwo.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        restaurantTextFieldTwo.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        //MARK: third restaurant text field
        scrollView.addSubview(restaurantTextFieldThree)
        restaurantTextFieldThree.topAnchor.constraint(equalTo: restaurantTextFieldTwo.bottomAnchor, constant: 5).isActive = true
        restaurantTextFieldThree.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 30).isActive = true
        restaurantTextFieldThree.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -30).isActive = true
        restaurantTextFieldThree.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        //MARK: fifth grey line
        scrollView.addSubview(fifthGreyLine)
        fifthGreyLine.topAnchor.constraint(equalTo: restaurantTextFieldThree.bottomAnchor, constant: 20).isActive = true
        fifthGreyLine.heightAnchor.constraint(equalToConstant: 1).isActive = true
        fifthGreyLine.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        fifthGreyLine.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20).isActive = true
        
        //MARK: set all orgs label
        scrollView.addSubview(setProfileLabel)
        setProfileLabel.topAnchor.constraint(equalTo: fifthGreyLine.bottomAnchor, constant: 20).isActive = true
        setProfileLabel.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20).isActive = true
        setProfileLabel.widthAnchor.constraint(equalTo: scrollView.widthAnchor, multiplier: 0.7).isActive = true
        
        //MARK: set all orgs switch
        scrollView.addSubview(allOrgSwitch)
        allOrgSwitch.topAnchor.constraint(equalTo: fifthGreyLine.bottomAnchor, constant: 20).isActive = true
        allOrgSwitch.leadingAnchor.constraint(equalTo: setProfileLabel.trailingAnchor, constant: 0).isActive = true
        let isSwitchOn: Bool = !useSeparateProfiles
        allOrgSwitch.setOn(isSwitchOn, animated: false)
    }
   
    //MARK: restaurants collector helper
    func collectRestaurantHelper() -> [String] {
        var restaurants:[String] = []
        if restaurantTextFieldOne.hasText {
            restaurants.append(restaurantTextFieldOne.text!)
        }
        if restaurantTextFieldTwo.hasText {
            restaurants.append(restaurantTextFieldTwo.text!)
        }
        if restaurantTextFieldThree.hasText {
            restaurants.append(restaurantTextFieldThree.text!)
        }
        return restaurants
    }
    
    //MARK: objc action functions
    
    //User pressed exit button
    @objc func exitPressed(_:UIImage) {
        self.navigationController?.popViewController(animated: true)
    }
    
    //notification callback for refreshing profile picture
    @objc func refreshProfilePicture(_:UIImage) {
        let profilePictureRef = "profiles/\(Constants.FIREBASE_USERID!)\(Constants.image_extension)"
        self.profilePic = imageCache.object(forKey: profilePictureRef as NSString)
        self.profilepic.image = profilePic
    }
    
    //User pressed preview button
    @objc func previewPressed(_:UIImage) {
        let nextVC = ProfileVC()
        nextVC.name = nameLabel.text!
        nextVC.pronouns = "pronouns not specified"
        if pronounValues.contains(pronounsTextField.text!) {
            nextVC.pronouns = pronounsTextField.text!
        }
        nextVC.bio = bioTextView.text!
        nextVC.interests = interests
        nextVC.restaurants = collectRestaurantHelper()
        nextVC.profilePic = profilePic
        
        nextVC.modalPresentationStyle = .automatic
        nextVC.modalTransitionStyle = .coverVertical
        self.present(nextVC, animated: true, completion: nil)
    }
    
    //user pressed profile pic picker button
    @objc func choosePic() {
        present(self.imagePicker, animated: true, completion: nil)
    }
    
    //User pressed edit profile interests button
    @objc func selectInterests(_:UIImage) {
        let nextVC = ProfileSetInterestsViewController()
        nextVC.modalPresentationStyle = .automatic
        nextVC.modalTransitionStyle = .coverVertical
        nextVC.selectedInterests = interests
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    //User pressed save changes button
    @objc func saveChanges(_:UIButton) {
        print(cloudutil.uploadImages(image: profilePic!, ref: "profiles/\(Constants.FIREBASE_USERID!)\(Constants.image_extension)"))
        var errorState = false
        var errorMsg = "Oops, something unexpected happened! Please contact the Sillo team"
        
        let requestThrottled: Bool = -self.latestButtonPressTimestamp.timeIntervalSinceNow < self.DEBOUNCE_LIMIT
        
        if (requestThrottled) {
            return
        }
        
        if (!interests.isEmpty && bioTextView.hasText) {
            var pronouns = "no pronouns specified"
            //prevents malicious alterations of pronouns
            if pronounValues.contains(pronounsTextField.text!) {
                pronouns = pronounsTextField.text!
            }
            
            let bio = bioTextView.text!
            
            self.restaurants = collectRestaurantHelper()
            self.useSeparateProfiles = !allOrgSwitch.isOn
            
            self.latestButtonPressTimestamp = Date()
            
            //set the orgaization document to overwrite
            var profileDocumentName = "all_orgs"
            if (useSeparateProfiles) {
                profileDocumentName = organizationData.currOrganization ?? "ERROR"
            }
            
            guard let userID = Auth.auth().currentUser?.uid else { return }
            let upperUserRef = db.collection("profiles").document(userID)
            upperUserRef.setData(["use_separate_profiles":useSeparateProfiles])
            
            let userRef = db.collection("profiles").document(userID).collection("org_profiles").document(profileDocumentName)
            
            userRef.setData(["pronouns":pronouns,"bio":bio,"interests":self.interests,"restaurants":self.restaurants])
            
            //transition to all set, onboarding finished
            let nextVC = AllSetViewController()
            self.navigationController?.pushViewController(nextVC, animated: true)
        }
        else {
            errorState=true
            errorMsg="Please fill out at least your bio and one interest to continue."
        }
        if (errorState) {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: errorMsg, message: "", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: {_ in}))
                self.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    @objc func toggleSwitch(_ sender : UISwitch!){
        if sender.isOn {
            useSeparateProfiles = false
        } else {
            useSeparateProfiles = true
        }
    } 
    
    @objc func hideKeyboard() {
        pronounsTextField.resignFirstResponder()
        bioTextView.resignFirstResponder()
        restaurantTextFieldOne.resignFirstResponder()
        restaurantTextFieldTwo.resignFirstResponder()
        restaurantTextFieldThree.resignFirstResponder()
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        /*
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            self.scrollView_origin_y = scrollView.frame.origin.y
            print(scrollView.frame.origin.y)
            if scrollView.frame.origin.y == self.scrollView_origin_y {
                print("adjust")
                scrollView.frame.origin.y = self.scrollView_origin_y - keyboardSize.height
            }
        }
        */
    }

    @objc func keyboardWillHide(notification: NSNotification) {
        /*
        if scrollView.frame.origin.y != self.scrollView_origin_y {
            scrollView.frame.origin.y = self.scrollView_origin_y
        }
        */
    }
}

//COLLECTIONVIEW
extension ProfileSetupViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 70, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCell
        if indexPath.item < self.interests.count{
            cell.data = self.interests[indexPath.item]
        }
        else {
            cell.data = "NONE"
        }
        return cell
    }
}

extension ProfileSetupViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    func createPronounPicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneEdit))
        toolbar.setItems([doneBtn], animated: true)
        pronounsTextField.inputAccessoryView = toolbar
        let pronounPicker = UIPickerView()
        pronounPicker.delegate = self
        pronounPicker.dataSource = self
        pronounsTextField.inputView = pronounPicker
    }
    
    @objc func doneEdit() {
        self.view.endEditing(true)
    }
    
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pronounValues.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pronounValues[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int){
        pronounsTextField.text = pronounValues[row]
     }
}

extension ProfileSetupViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            profilePic = image
            self.profilepic.image = profilePic
        }
        self.imagePicker.dismiss(animated: true, completion: nil)
    }
}