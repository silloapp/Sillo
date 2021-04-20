//
//  ViewController.swift
//  Sillo
//
//  Created by Eashan Mathur on 1/2/21.
//

import UIKit

//MARK: figma screens 1025, 1028, 1029
class PageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
    
    //MARK: Initialization of UI elements
    
    var pages = [UIViewController]()
    private let pageControl : UIPageControl = {
        let pageControl = UIPageControl()
        return pageControl
    }()
    
    var currentIndex: Int {
        guard let vc = viewControllers?.first else { return 0 }
        return pages.firstIndex(of: vc) ?? 0
    }
    
    let getStartedButton: UIButton = {
        let button = UIButton()
        button.setTitle("Get Started", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = Font.bold(20)
        button.backgroundColor = Color.buttonClickable
        button.addTarget(self, action: #selector(getStartedClicked(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let signInButton: UIButton = {
        let button = UIButton()
        button.setTitle("I already have an account", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.titleLabel?.font = Font.bold(20)
        button.addTarget(self, action: #selector(signInClicked(_:)), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    let silloLogo: UIImageView = {
        let imgV = UIImageView()
        imgV.contentMode = .scaleAspectFit
        imgV.image = #imageLiteral(resourceName: "sillo-logo")
        imgV.translatesAutoresizingMaskIntoConstraints = false
        return imgV
    }()
    

    
    let buttonsStack = UIStackView()
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.backgroundColor = .white
        self.dataSource = self
        self.delegate = self

        configureButtons()
        configurePageControl()
    
    }
    
    override func viewWillLayoutSubviews() {
        getStartedButton.layer.cornerRadius = getStartedButton.frame.height / 8
    }
    
    override func viewDidLayoutSubviews() {
        pageControl.subviews.forEach {
            $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5)
        }
    }
    
    func configureButtons() {
        buttonsStack.axis = .vertical
        buttonsStack.alignment = .center
        buttonsStack.distribution = .fillProportionally
        buttonsStack.spacing = 20
        view.addSubview(buttonsStack)
        view.addSubview(silloLogo)
        
        
        buttonsStack.addArrangedSubview(getStartedButton)
        buttonsStack.addArrangedSubview(signInButton)
        buttonsStack.translatesAutoresizingMaskIntoConstraints = false
        buttonsStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -15).isActive = true
        buttonsStack.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        buttonsStack.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 306/375).isActive = true
        
        getStartedButton.widthAnchor.constraint(equalTo: buttonsStack.widthAnchor).isActive = true
        getStartedButton.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 55/812).isActive = true
        signInButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        silloLogo.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        silloLogo.leadingAnchor.constraint(equalTo: buttonsStack.leadingAnchor).isActive = true
        silloLogo.heightAnchor.constraint(equalTo: view.heightAnchor, multiplier: 80/812).isActive = true
        silloLogo.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 138/375).isActive = true
        
    }
    
    @objc func close(_: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    

    @objc func signInClicked(_: UIButton) {
        let nextVC = SignInViewController()
        nextVC.modalPresentationStyle = .fullScreen
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc func getStartedClicked(_: UIButton){
        let nextVC = CreateAccountViewController()
        nextVC.modalPresentationStyle = .fullScreen
        self.navigationController?.setNavigationBarHidden(false, animated: false)
        self.navigationController?.pushViewController(nextVC, animated: true)
    }

    
    func configurePageControl() {
        let initialPage = 0

        let page1 = OnboardingViewController(_image: UIImage(named: "onboarding1")!, _descriptionText: "Spark a conversation in your team anonymously.")
        let page2 = OnboardingViewController(_image: UIImage(named: "onboarding2")!, _descriptionText: "Show yourself only when you are ready.")
        let page3 = OnboardingViewController(_image: UIImage(named: "onboarding3")!, _descriptionText: "Share exclusive deals from nearby restaurants.")
        
        // add the individual viewControllers to the pageViewController
        self.pages.append(page1)
        self.pages.append(page2)
        self.pages.append(page3)
        setViewControllers([pages[initialPage]], direction: .forward, animated: false, completion: nil)
        
        
        self.pageControl.currentPageIndicatorTintColor = UIColor.black
        self.pageControl.pageIndicatorTintColor = UIColor.lightGray
        self.pageControl.numberOfPages = self.pages.count
        self.pageControl.currentPage = initialPage
        self.pageControl.currentPageIndicatorTintColor = Color.buttonClickable
        self.pageControl.pageIndicatorTintColor = Color.gray
        self.view.addSubview(self.pageControl)
        
        self.pageControl.translatesAutoresizingMaskIntoConstraints = false
        self.pageControl.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.pageControl.topAnchor.constraint(equalTo: buttonsStack.topAnchor, constant: -40).isActive = true

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
                
            }
        }
    }
}

