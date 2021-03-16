//
//  SceneDelegate.swift
//  Sillo
//
//  Created by Eashan Mathur on 1/2/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        
        //configure first screen
//        let vc = PageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)

//        let transition = CATransition()
//        transition.duration = 0.3
//        transition.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
//        transition.type = .fade
//        self.navigationController?.view.layer.add(transition, forKey: nil)

//        let vc = NewPostViewController()

        
//        let tabVC = UITabBarController()
        //MARK:: ALL MOVED TO STARTSCREENVIEWCONTROLLER
        /*
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
        
        let icon1 = UITabBarItem(title: "Home", image: UIImage(named: "tab1")!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tab1Selected")!.withRenderingMode(.alwaysOriginal))
        let icon2 = UITabBarItem(title: "Quests", image: UIImage(named: "tab2")!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tab2Selected")!.withRenderingMode(.alwaysOriginal))
        let icon3 = UITabBarItem(title: "New Post", image: UIImage(named: "tab3")!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tab3Selected")!.withRenderingMode(.alwaysOriginal))
        let icon4 = UITabBarItem(title: "Messages", image: UIImage(named: "tab4")!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tab4Selected")!.withRenderingMode(.alwaysOriginal))
        let icon5 = UITabBarItem(title: "Team", image: UIImage(named: "tab5")!.withRenderingMode(.alwaysOriginal), selectedImage: UIImage(named: "tab5Selected")!.withRenderingMode(.alwaysOriginal))
        
        
        let vc1 = UINavigationController(rootViewController: StartScreenViewController())
        let vc2 = UINavigationController(rootViewController: AchievementsViewController())
        let vc3 = NewPostViewController()
        let vc4 = UINavigationController(rootViewController: MessagesViewController())
        let vc5 = UINavigationController(rootViewController: TeamViewController())
        
        vc1.title = "Home"
        vc1.tabBarItem = icon1
        
        vc2.title = "Achievements"
        vc2.tabBarItem = icon2
        
        vc3.title = "New Post"
        vc3.tabBarItem = icon3
        
        vc4.title = "Team"
        vc4.tabBarItem = icon4
        
        vc5.title = "Messages"
        vc5.tabBarItem = icon5
        
        tabVC.setViewControllers([vc1, vc2, vc3, vc4, vc5], animated: false)
//        tabVC.modalPresentationStyle = .fullScreen
//        navigationController?.present(tabVC, animated: true, completion: nil)

        //OG CODE BELOW
//        let navVC = UINavigationController(rootViewController: tabVC)
//        navVC.modalPresentationStyle = .fullScreen

        window?.rootViewController = tabVC //starting VC (UI Tab bar / Nav controller)
        window?.makeKeyAndVisible()
 */
        
        let startVC = StartScreenViewController()
        startVC.modalPresentationStyle = .fullScreen
        window?.rootViewController = startVC
        window?.makeKeyAndVisible()
        
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.

        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

