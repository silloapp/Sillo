//
//  ViewController.swift
//  Sillo
//
//  Created by Eashan Mathur on 1/2/21.
//

import UIKit


class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    var pages = [UIViewController]()
    private let pageControl : UIPageControl = {
        let pageControl = UIPageControl()
        return pageControl
    }()
    var currentIndex: Int {
        guard let vc = viewControllers?.first else { return 0 }
        return pages.firstIndex(of: vc) ?? 0
    }
    let nextButton: UIButton = {
        let button = UIButton()
        button.setTitle("Next", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(nextClicked(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let skipButton: UIButton = {
        let button = UIButton()
        button.setTitle("Skip", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(skipClicked(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let closeButton: UIButton = {
        let button = UIButton()
        button.setTitle("X", for: .normal)
        button.setTitleColor(.gray, for: .normal)
        button.addTarget(self, action: #selector(close(_:)), for: .touchUpInside)
        return button
    }()
    let getStarted: UIButton = {
        let button = UIButton()
        button.setTitle("Let's get started!", for: .normal)
//        button.titleLabel?.font = Font.bold(15)
//        button.backgroundColor = Color.getStartedButton
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(close(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .white
        
        self.dataSource = self
        self.delegate = self

        configurePageControl()

        configureButtons()
    }
    
    override func viewWillLayoutSubviews() {
        getStarted.layer.cornerRadius = getStarted.frame.height / 2
    }
    
    override func viewDidLayoutSubviews() {
        pageControl.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
    }
    
    func configureButtons() {
        view.addSubview(nextButton)
        nextButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        nextButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        nextButton.centerYAnchor.constraint(equalTo: pageControl.centerYAnchor).isActive = true
        nextButton.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -24).isActive = true
        nextButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        view.addSubview(skipButton)
        skipButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        skipButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        skipButton.centerYAnchor.constraint(equalTo: pageControl.centerYAnchor).isActive = true
        skipButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        skipButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        view.addSubview(closeButton)
        closeButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        closeButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 24).isActive = true
        closeButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        
        view.addSubview(getStarted)
        getStarted.widthAnchor.constraint(equalToConstant: 200).isActive = true
        getStarted.heightAnchor.constraint(equalToConstant: 43).isActive = true
        getStarted.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        getStarted.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -30).isActive = true
        getStarted.isHidden = true
    }
    
    @objc func close(_: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @objc func skipClicked(_: UIButton) {
        
        for i in currentIndex...pages.count-1 {
            setViewControllers([pages[i]], direction: .forward, animated: true, completion: nil)
        }
        pageControl.currentPage = pages.count - 1
        buttonOpacityControl()
        
    }
    
    @objc func nextClicked(_: UIButton){
        moveToNextPage()
    }
    
    func moveToNextPage() {
        if currentIndex != pages.count - 1 {
            setViewControllers([pages[currentIndex + 1]], direction: .forward, animated: true, completion: nil)
        }
        pageControl.currentPage += 1

        buttonOpacityControl()
    }
    
    func buttonOpacityControl() {
        if pageControl.currentPage == self.pages.count - 1 {
            getStarted.isHidden = false
            UIView.animate(withDuration: 0.5) {
                self.getStarted.layer.opacity = 1
                self.skipButton.layer.opacity = 0
            }
            
        }
        
        else if pageControl.currentPage != self.pages.count - 1 {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.3) {
                    self.getStarted.layer.opacity = 0
                    self.skipButton.layer.opacity = 1
                }
            }
        }
    }
    
    func configurePageControl() {
        let initialPage = 0
        let page1 = OnboardingViewController(_bearImage: UIImage(named: "onboardingSillo")!, _descriptionText: "Connecting the real you.")
        let page2 = OnboardingViewController(_bearImage: UIImage(named: "onboardingSillo")!, _descriptionText: "Connecting the real you.")
        
        // add the individual viewControllers to the pageViewController
        self.pages.append(page1)
//        self.pages.append(page2)
//        self.pages.append(page3)
        setViewControllers([pages[initialPage]], direction: .forward, animated: true, completion: nil)
        
        // pageControl
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = initialPage
//        self.pageControl.pageIndicatorTintColor = Color.onboardingTint
        self.view.addSubview(self.pageControl)
        
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.bottomAnchor.constraint(equalTo: self.view.layoutMarginsGuide.bottomAnchor, constant: -10).isActive = true
        self.pageControl.widthAnchor.constraint(equalToConstant: 140).isActive = true
        self.pageControl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
//        self.pageControl.tintColor = Color.pageViewBackgroundTint
        self.pageControl.isUserInteractionEnabled = false
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let viewControllerIndex = self.pages.firstIndex(of: viewController), viewControllerIndex != 0 else { return nil }
        
        return self.pages[viewControllerIndex - 1]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = self.pages.firstIndex(of: viewController), viewControllerIndex < self.pages.count - 1 else { return nil }
                // go to next page in array
        return self.pages[viewControllerIndex + 1]
    
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
            
    // set the pageControl.currentPage to the index of the current viewController in pages
        if let viewControllers = pageViewController.viewControllers {
            if let viewControllerIndex = self.pages.firstIndex(of: viewControllers[0]) {
                self.pageControl.currentPage = viewControllerIndex
                
                buttonOpacityControl()
                
            }
        }
    }
}

