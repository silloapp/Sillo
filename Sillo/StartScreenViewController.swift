//
//  StartScreenViewController.swift
//
//
//  Created by William Loo on 3/15/21.
//

import UIKit
import GoogleSignIn

class StartScreenViewController: UIViewController {
    
    //MARK: logo imageview
    let logoImageView:UIImageView = {
        var imageView = UIImageView()
        imageView.image = UIImage(named:"sillo-logo-small")
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(self.routeUser(note:)), name: Notification.Name("UserLoadingComplete"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.goToMainView(note:)), name: Notification.Name("ColdOrgChangeComplete"), object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        overrideUserInterfaceStyle = .light
        
        //MARK: logo image view
        view.addSubview(logoImageView)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.20).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 0.20).isActive = true
        
        pulsate()
        localUser.coldStart()
    }
    @objc func routeUser(note:NSNotification) {
        var nextVC = UIViewController()
        nextVC.navigationController?.view.backgroundColor = .white
        if (UserDefaults.standard.bool(forKey: "loggedIn")) {
            //loggedIn
            if (UserDefaults.standard.bool(forKey: "finishedOnboarding")) {
                //onboarding finished
                print("logged in, onboarding finished")
                
                if (UserDefaults.standard.string(forKey: "defaultOrganization") != nil) {
                    organizationData.coldChangeOrganization(dest: UserDefaults.standard.string(forKey: "defaultOrganization"))
                    return
                }
                
                if !organizationData.organizationList.isEmpty {
                    print(organizationData.organizationList)
                    organizationData.coldChangeOrganization(dest: organizationData.organizationList[0])
                    return //leave this router and await notification coldOrgChangeComplete
                }
                
                else {
                    
                    nextVC = WelcomeToSilloViewController()

//                    if localUser.invites.count > 0 {
//                        print("HAVE INVITES")
//                        nextVC = WelcomeToSilloViewController()
//                    }
//                    else {
//                        //MARK: set up fallback if table is empty
//                        nextVC = WelcomeToSilloNoInviteVC()
//                    }
                    
                }
            } else {
                print("logged in, onboarding unfinished")
                //not yet finished with onboarding, go through steps
                if (!(Constants.me?.isEmailVerified ?? false)) {
                    //is email verified?
                    nextVC = PasscodeVerificationViewController()
                    //cloudutil.generateAuthenticationCode()
                }
                else if (Constants.me?.displayName == nil) {
                    //is name set?
                    nextVC = SetNameViewController()
                }
                else {
                    //alright, then it must be notifications.
                    nextVC = NotificationRequestViewController()
                }
                self.navigationController?.pushViewController(nextVC, animated: true)
            }
            
        } else {
            //not loggedIn
            nextVC = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
        }
        
        let navC = UINavigationController(rootViewController: nextVC)
        navC.view.backgroundColor = .white
        
        navC.modalPresentationStyle = .fullScreen
        navC.setNavigationBarHidden(true, animated: false)
        self.present(navC, animated: true, completion: nil)
    }
    
    @objc func goToMainView(note:NSNotification) {
        let nextVC = prepareTabVC()
        
        let navC = UINavigationController(rootViewController: nextVC)
        navC.modalPresentationStyle = .fullScreen
        navC.setNavigationBarHidden(true, animated: false)
        self.present(navC, animated: true, completion: nil)
    }
    
    func pulsate() {
        let pulse = CASpringAnimation(keyPath: "transform.scale")
        pulse.duration = 1.0
        pulse.fromValue = 0.9
        pulse.toValue = 1.0
        pulse.autoreverses = true
        pulse.repeatCount = .infinity
        pulse.initialVelocity = 0.1
        pulse.damping = 0.1
        logoImageView.layer.add(pulse, forKey: nil)
    }
    
}
func prepareTabVC() -> UIViewController {
    let tabVC = CustomTabBarController()
    tabVC.tabBar.barTintColor = Color.offsnow
    tabVC.tabBar.layer.masksToBounds = true
    tabVC.tabBar.isTranslucent = true
    tabVC.tabBar.layer.borderWidth = 0
    
    tabVC.tabBar.layer.shadowOffset = CGSize(width: 0, height: -4)
    tabVC.tabBar.layer.shadowRadius = 10
    tabVC.tabBar.layer.shadowColor = UIColor.black.cgColor
    tabVC.tabBar.layer.shadowOpacity = 0.15
    tabVC.tabBar.clipsToBounds = false
    
    let icon1 = UITabBarItem(title: "Home", image: UIImage(named: "home")!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "home active")!.withRenderingMode(.alwaysOriginal))
    let icon2 = UITabBarItem(title: "Quests", image: UIImage(named: "missions")!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "missions active")!.withRenderingMode(.alwaysOriginal))
    let icon3 = UITabBarItem(title: "New Post", image: UIImage(named: "new post")!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "new post active")!.withRenderingMode(.alwaysOriginal))
    let icon4 = UITabBarItem(title: "Messages", image: UIImage(named: "messages")!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "messages active")!.withRenderingMode(.alwaysOriginal))
    let icon5 = UITabBarItem(title: "Team", image: UIImage(named: "team")!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "team active")!.withRenderingMode(.alwaysOriginal))
    
    
    let vc1 = UINavigationController(rootViewController: HomeViewController())
    let vc2 = UINavigationController(rootViewController: QuestProgressVC())
    let vc3 = NewPostViewController()
    let vc4 = UINavigationController(rootViewController: MessagesViewController())
    let vc5 = UINavigationController(rootViewController: TeamViewController())
    
    vc1.title = "Home"
    vc1.tabBarItem = icon1
    vc1.view.backgroundColor = .white
    
    vc2.title = "Achievements"
    vc2.tabBarItem = icon2
    vc2.view.backgroundColor = .white
    
    vc3.title = "New Post"
    vc3.tabBarItem = icon3
    vc3.view.backgroundColor = .white
    
    vc4.title = "Team"
    vc4.tabBarItem = icon4
    vc4.view.backgroundColor = .white
    
    vc5.title = "Messages"
    vc5.tabBarItem = icon5
    vc5.view.backgroundColor = .white
    
    tabVC.setViewControllers([vc1, vc2, vc3, vc4, vc5], animated: false)
    
    return tabVC
}

