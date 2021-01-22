//
//  CustomUITabBarController.swift
//  Sillo
//
//  Created by Eashan Mathur on 1/13/21.
//

import UIKit

class CustomUITabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {

//        if let controller = self.viewControllers?[tabBar.items?.firstIndex(of: item)] as? NewPostViewController {
//
//            controller.modalPresentationStyle = .pageSheet
//              self.present(controller, animated: true, completion: nil)
//           }
    }
    



}
