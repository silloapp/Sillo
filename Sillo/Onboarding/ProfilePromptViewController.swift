//
//  ProfilePromptViewController.swift
//  Sillo
//
//  Created by William Loo on 2/25/21.
//
import Firebase
import UIKit

class ProfilePromptViewController: UIViewController {
    
    private var latestButtonPressTimestamp: Date = Date()
    private var DEBOUNCE_LIMIT: Double = 0.9 //in seconds
    
    var ORGANIZATION_NAME = "Berkeley Food Club"//SET DYNAMICALLY SOON
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureNavBar()
        setupView()
    }
    
    func configureNavBar() {
        navigationController?.isNavigationBarHidden = true
    }
    
    func setupView() {
        
        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .trailing
        stack.distribution = .fillProportionally
        stack.spacing = 5
        view.addSubview(stack)
        
        let skipButton = UIButton()
        let RIGHT_MARGIN=20
        skipButton.frame = CGRect(x: self.view.frame.size.width - skipButton.frame.size.width - CGFloat(RIGHT_MARGIN), y: CGFloat(100), width: skipButton.frame.size.width, height: skipButton.frame.size.height)
        skipButton.contentHorizontalAlignment = .right
        skipButton.setTitle("Skip", for: .normal)
        skipButton.setTitleColor(.black, for: .normal)
        skipButton.titleLabel?.font = Font.light(dynamicFontSize(17))
        skipButton.titleLabel?.minimumScaleFactor = 0.5
        skipButton.titleLabel?.adjustsFontSizeToFitWidth = true
        skipButton.addTarget(self, action: #selector(skipClicked), for: .touchUpInside)
        stack.addArrangedSubview(skipButton)
        
        let welcomeHeader = UILabel()
        welcomeHeader.numberOfLines = 0
        welcomeHeader.text = "Let's set up your profile in \(ORGANIZATION_NAME)!"
        welcomeHeader.font = Font.medium(dynamicFontSize(24))
        welcomeHeader.minimumScaleFactor = 0.5
        welcomeHeader.adjustsFontSizeToFitWidth = true
        welcomeHeader.textColor = Color.buttonClickable
        stack.addArrangedSubview(welcomeHeader)
        
        let descriptionText = UILabel()
        descriptionText.numberOfLines = 0
        descriptionText.text = "You can always set up a unique profile for other organizations later."
        descriptionText.font = Font.regular(dynamicFontSize(17))
        descriptionText.minimumScaleFactor = 0.5
        descriptionText.adjustsFontSizeToFitWidth = true
        descriptionText.textColor = Color.textSemiBlack
        stack.addArrangedSubview(descriptionText)
        
        let image = UIImageView()
        image.image = UIImage(named: "onboarding-mirror")
        image.contentMode = .top
        stack.addArrangedSubview(image)
        
        let button = UIButton()
        button.setTitle("Continue", for: .normal)
        button.backgroundColor = Color.buttonClickable
        button.titleLabel?.font = Font.bold(dynamicFontSize(17))
        button.titleLabel?.minimumScaleFactor = 0.5
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 5
        button.addTarget(self, action: #selector(createProfileClicked), for: .touchUpInside)
        stack.addArrangedSubview(button)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        stack.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 30).isActive = true
        stack.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -30).isActive = true
        stack.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.8).isActive = true
        
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        
        welcomeHeader.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        welcomeHeader.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.1).isActive = true
        image.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        
        descriptionText.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        
        button.widthAnchor.constraint(equalTo: stack.widthAnchor).isActive = true
        button.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.07).isActive = true
        
    }
    
    @objc private func createProfileClicked() {
        //debouncing business
        let requestThrottled: Bool = -self.latestButtonPressTimestamp.timeIntervalSinceNow < self.DEBOUNCE_LIMIT
        if (requestThrottled) {return}
        self.latestButtonPressTimestamp = Date()
        
        //show loading vc while backend business
        let loadingVC = LoadingViewController()
        loadingVC.modalPresentationStyle = .overCurrentContext
        loadingVC.modalTransitionStyle = .crossDissolve
        self.present(loadingVC, animated: false, completion: nil)
        
        //prepare next view controller
        let nextVC = ProfileSetupViewController()
        
        //perform backend businesss
        guard let userID = Auth.auth().currentUser?.uid else { return }
        let upperUserRef = db.collection("profiles").document(userID)
        
        upperUserRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                let dataDict = document.data()
                print("Document data: \(dataDescription)")
                var profileDocumentName = "all_orgs"

                let useSeparateProfiles = dataDict!["use_separate_profiles"] as! Bool
                profileDocumentName = "all_orgs"
                if (useSeparateProfiles) {
                    profileDocumentName = "some_orgs"
                }
                let userRef = db.collection("profiles").document(userID).collection("org_profiles").document(profileDocumentName)
                userRef.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let innerDict = document.data()!
                        let pronouns = innerDict["pronouns"] as! String
                        let bioText = innerDict["bio"] as! String
                        let interests = innerDict["interests"] as! [String]
                        let restaurants = innerDict["restaurants"] as! [String]

                        nextVC.bioText = bioText
                        nextVC.pronouns = pronouns
                        nextVC.interests = interests
                        nextVC.restaurants = restaurants
                        nextVC.useSeparateProfiles = useSeparateProfiles
                        
                        //https://firebase.google.com/docs/analytics/events?platform=ios
                        Analytics.logEvent("edit_profile", parameters: [
                          "name": "will" as NSObject,
                          "full_text": "creating a profile.." as NSObject
                          ])
                        //transition to next vc
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }
                    else {
                        //transition to next vc (blank, because organization-specific profile doesn't exist yet)
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }
                    //dismiss loading overlay
                    loadingVC.dismiss(animated: false, completion: nil)
                }
            }
            else {
                //transition to next vc (blank, because no existing document found)
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            
        }
        
        
        
        
        
    }
    @objc private func skipClicked() {
        let requestThrottled: Bool = -self.latestButtonPressTimestamp.timeIntervalSinceNow < self.DEBOUNCE_LIMIT
        
        if (requestThrottled) {
            return
        }
        self.latestButtonPressTimestamp = Date()
        //navigationController?.pushViewController(ProfileSetInterestsViewController(), animated: true)
        print("SKIP")
    }

}
