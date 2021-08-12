//
//  CustomTabBarController.swift
//  Sillo
//
//  Created by Eashan Mathur on 2/20/21.
//

import UIKit

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.setMessagesBadgeStatus(note:)), name: Notification.Name("UpdateMessageTabBarBadge"), object: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
//        tabBar.frame.size.height = 65
//        tabBar.frame.origin.y = view.frame.height - 65

    }
    
    
    @objc func setMessagesBadgeStatus(note: NSNotification) {
        var status:Int = -1
        self.tabBar.items![3].badgeColor = Color.burple
        if note.userInfo != nil && note.userInfo!["badge"] != nil {
            let data = note.userInfo!
            status = data["badge"] as! Int
            //if -1, clear badge, if not, leave a blank dot
            if status < 0 {
                self.tabBar.items![3].badgeValue = nil
            }
            else {
                self.tabBar.items![3].badgeValue = ""
            }
        }

    }
    
    //get index to determine direction
    func getIndexHelper(forViewController vc: UIViewController) -> Int? {
        guard let vcs = self.viewControllers else { return nil }
        for (index, thisVC) in vcs.enumerated() {
            if thisVC == vc { return index }
        }
        return nil
    }
    
    //MARK: UITabbar Delegate
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        
        //scrolling up to top of feed function:
        //check if current view controller, and is looking at feed.
        if self.selectedIndex == 0 && getIndexHelper(forViewController: viewController) == getIndexHelper(forViewController: self.selectedViewController!) {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "scrollToTopOfFeed"), object: nil)
        }
        
        
        
        if viewController.isKind(of: NewPostViewController.self) {

            let vc =  NewPostViewController()
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            return false
        }
        return true
    }
    
    func tabBarController(_ tabBarController: UITabBarController, animationControllerForTransitionFrom fromVC: UIViewController, to toVC: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return SlideTransition(viewControllers: tabBarController.viewControllers)
    }
    
}

//https://stackoverflow.com/questions/44346280/how-to-animate-tab-bar-tab-switch-with-a-crossdissolve-slide-transition
//keywords: hor segue, horizontal slide, 
class SlideTransition: NSObject, UIViewControllerAnimatedTransitioning {

    let viewControllers: [UIViewController]?
    let transitionDuration: Double = 0.3

    init(viewControllers: [UIViewController]?) {
        self.viewControllers = viewControllers
    }

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return TimeInterval(transitionDuration)
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        guard
            let fromVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from),
            let fromView = fromVC.view,
            let fromIndex = getIndex(forViewController: fromVC),
            let toVC = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to),
            let toView = toVC.view,
            let toIndex = getIndex(forViewController: toVC)
            else {
                transitionContext.completeTransition(false)
                return
        }

        let frame = transitionContext.initialFrame(for: fromVC)
        var fromFrameEnd = frame
        var toFrameStart = frame
        fromFrameEnd.origin.x = toIndex > fromIndex ? frame.origin.x - frame.width : frame.origin.x + frame.width
        toFrameStart.origin.x = toIndex > fromIndex ? frame.origin.x + frame.width : frame.origin.x - frame.width
        toView.frame = toFrameStart

        DispatchQueue.main.async {
            transitionContext.containerView.addSubview(toView)
            UIView.animate(withDuration: self.transitionDuration, delay: 0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.1, options: [.curveEaseInOut], animations: {
                fromView.frame = fromFrameEnd
                toView.frame = frame
            }, completion:  {success in
                fromView.removeFromSuperview()
                transitionContext.completeTransition(success)
            })
        }
    }

    //get index to determine direction
    func getIndex(forViewController vc: UIViewController) -> Int? {
        guard let vcs = self.viewControllers else { return nil }
        for (index, thisVC) in vcs.enumerated() {
            if thisVC == vc { return index }
        }
        return nil
    }
}
