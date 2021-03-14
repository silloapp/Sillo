//
//  ProfileHalfVC.swift
//  
//
//  Created by Angelica Pan on 2/26/21.
//

import UIKit

class ProfileHalfVC: UIViewController {
    var cardViewTopConstraint: NSLayoutConstraint?
    var selectedImage = UIImage()
    var imageUploaded = false
    
    let backingImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage() //replace this with screenshot
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let blurView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.headerBackground
        
        return view
    }()

    let cardView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.progressBlue
        
        return view
    }()
    
    let handleView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.gray
        
        return view
    }()
        
    
    let submitButton: UIButton = {
        let button = UIButton()
        button.setTitle("PLACEHOLDER", for: .normal)
        button.titleLabel?.font = Font.bold(20)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = Color.buttonClickable
//        button.addTarget(self, action: #selector(actionButton(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 5
        return button
    }()
    

    enum CardViewState {
        case expanded
        case normal
    }
    //set default card state
    var cardViewState : CardViewState = .normal
    
    // to store the card view top constraint value before the dragging start
    // default is 30 pt from safe area top -- can change this!
    var cardPanStartingTopConstant : CGFloat = 30.0
    
    // to store backing (snapshot) image
    var backingImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        overrideUserInterfaceStyle = .light
        cardViewTopConstraint?.constant = 300
        // hide the card view at the bottom when the View first load
        if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
            let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
            cardViewTopConstraint?.constant = safeAreaHeight + bottomPadding
        }
    
        // update the backing image view
        backingImageView.image = backingImage
        
        // round the top left and top right corner of card view
        cardView.clipsToBounds = true
        
        DispatchQueue.main.async {
            self.cardView.layer.cornerRadius = 25 //TODO: why is this suddenly not working anymore?
            self.cardView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        }
        
        // round the handle view
        view.addSubview(handleView)
        handleView.clipsToBounds = true
        handleView.layer.cornerRadius = 3.0
        
       
        
        // set dimmerview to transparent
        blurView.alpha = 0.8
        
        //when back is clicked, the halfmodal closes
        let blurTap = UITapGestureRecognizer(target: self, action: #selector(blurViewTapped(_:)))
        blurTap.cancelsTouchesInView = false;
        blurView.addGestureRecognizer(blurTap)
        blurView.isUserInteractionEnabled = true
        

        let viewPan = UIPanGestureRecognizer(target: self, action: #selector(viewPanned(_:)))
        // by default iOS will delay the touch before recording the drag/pan information
        // we want the drag gesture to be recorded down immediately, hence setting no delay
        viewPan.delaysTouchesBegan = false
        viewPan.delaysTouchesEnded = false
        self.view.addGestureRecognizer(viewPan)
        
        
        ///set constraints
        view.addSubview(backingImageView)
        backingImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        backingImageView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        backingImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        backingImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        view.addSubview(blurView)
        blurView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        blurView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        blurView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        blurView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        view.addSubview(cardView)
        cardView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        cardView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
                cardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        cardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
//        // submit button
//        view.addSubview(submitButton)
//        submitButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 32).isActive = true
//        submitButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -32).isActive = true
//        submitButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        submitButton.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
//        submitButton.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 50).isActive = true
        
        
        
        
    }
    

    
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showCard()
    }
    
    @objc func blurViewTapped(_ tapRecognizer: UITapGestureRecognizer) {
        hideCardAndGoBack()
    }
    
    // this function will be called when user pan/drag the view
    @objc func viewPanned(_ panRecognizer: UIPanGestureRecognizer) {
        // how much distance has user dragged the card view
        // positive number means user dragged downward
        // negative number means user dragged upward
        let translation = panRecognizer.translation(in: self.view)
        // how fast the user drag
        let velocity = panRecognizer.velocity(in: self.view)
        
        //print("user has dragged \(translation.y) point vertically")
        
        
        switch panRecognizer.state {
        case .began:
            cardPanStartingTopConstant = cardViewTopConstraint!.constant
        case .changed :
            // currently 300 is the default height of view. When toggles are clicked, change the value
            if self.cardPanStartingTopConstant + translation.y > 30.0 {
                self.cardViewTopConstraint!.constant = self.cardPanStartingTopConstant + translation.y
            }
            
            // change the dimmer view alpha based on how much user has dragged
            blurView.alpha = dimAlphaWithCardTopConstraint(value: self.cardViewTopConstraint!.constant)
            
        case .ended :
            
            
            if velocity.y > 1500.0 { // can modify later on
                // hide the card and dismiss current view controller
                hideCardAndGoBack()
                return
            }
            
            if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
                let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
                print("condition for normal HEIGHT: \((safeAreaHeight - 150))")
                if self.cardViewTopConstraint!.constant < (safeAreaHeight + bottomPadding) * 0.3 {
                    // show the card at expanded state
                    // showCard(atState: .expanded)
                    // maybe only show expanded when qText is clicked and not otherwise
                    showCard(atState: .normal)
                } else if self.cardViewTopConstraint!.constant < (safeAreaHeight) - 150 {
                    // show the card at normal state
                    showCard(atState: .normal)
                } else {
                    // hide the card and dismiss current view controller
                    hideCardAndGoBack()
                }
                
                
            }
        default:
            break
        }
        
    }
    
//    private func setConstraints() {
//        backingImageView.bottomAnchor.constraint(
//
//    }
//
    //ANIMATIONS BELOW//////////////////////////////
    private func showCard(atState: CardViewState = .normal){
        
        // ensure there's no pending layout changes before animation runs
        self.view.layoutIfNeeded()
        
        // set the new top constraint value for card view
        // card view won't move up just yet, we need to call layoutIfNeeded()
        // to tell the app to refresh the frame/position of card view
        if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
            let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
            
            if atState == .expanded {
                // if state is expanded, top constraint is 30pt away from safe area top
                cardViewTopConstraint?.constant = 200
            }
            else {
                cardViewTopConstraint?.constant = 150
                // cardViewTopConstraint.constant = (safeAreaHeight + bottomPadding) / 3
            }
            //            cardViewTopConstraint.constant = cardViewTopConstraint.constant
        }
        
        // move card up from bottom by telling the app to refresh the frame/position of view
        // create a new property animator
        let showCard = UIViewPropertyAnimator(duration: 0.32, curve: .easeInOut, animations: {
            self.view.layoutIfNeeded()
            self.blurView.alpha = 0.8
        })
        
        // show dimmer view
        // this will animate the dimmerView alpha together with the card move up animation
//        showCard.addAnimations({
//
//        })
        
        
        // run the animation
        showCard.startAnimation()
    }
    
    private func hideCardAndGoBack() {
        // ensure there's no pending layout changes before animation runs
        self.view.layoutIfNeeded()
        
        // set the new top constraint value for card view
        // card view won't move down just yet, we need to call layoutIfNeeded()
        // to tell the app to refresh the frame/position of card view
        if let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
            let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
            
            // move the card view to bottom of screen
            cardViewTopConstraint!.constant = safeAreaHeight + bottomPadding
        }
        
        // move card down to bottom
        // create a new property animator
        let hideCard = UIViewPropertyAnimator(duration: 0.25, curve: .easeIn, animations: {
            self.view.layoutIfNeeded()
        })
        
        // hide dimmer view
        // this will animate the dimmerView alpha together with the card move down animation
        hideCard.addAnimations {
            self.blurView.alpha = 0.0
        }
        
        // when the animation completes, (position == .end means the animation has ended)
        // dismiss this view controller (if there is a presenting view controller)
        hideCard.addCompletion({ position in
            if position == .end {
                if(self.presentingViewController != nil) {
                    self.dismiss(animated: false, completion: nil)
                }
            }
        })
        
        // run the animation
        hideCard.startAnimation()
    }
    
    
    private func dimAlphaWithCardTopConstraint(value: CGFloat) -> CGFloat {
        let fullDimAlpha : CGFloat = 0.7
        
        // ensure safe area height and safe area bottom padding is not nil
        guard let safeAreaHeight = UIApplication.shared.keyWindow?.safeAreaLayoutGuide.layoutFrame.size.height,
            let bottomPadding = UIApplication.shared.keyWindow?.safeAreaInsets.bottom else {
                return fullDimAlpha
        }
        
        // when card view top constraint value is equal to this,
        // the dimmer view alpha is dimmest (0.7)
        let fullDimPosition = (safeAreaHeight + bottomPadding) / 2.0
        
        // when card view top constraint value is equal to this,
        // the dimmer view alpha is lightest (0.0)
        let noDimPosition = safeAreaHeight + bottomPadding
        
        // if card view top constraint is lesser than fullDimPosition
        // it is dimmest
        if value < fullDimPosition {
            return fullDimAlpha
        }
        
        // if card view top constraint is more than noDimPosition
        // it is dimmest
        if value > noDimPosition {
            return 0.0
        }
        
        // else return an alpha value in between 0.0 and 0.7 based on the top constraint value
        return fullDimAlpha * 1 - ((value - fullDimPosition) / fullDimPosition)
    }
}






   




