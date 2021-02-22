//
//  HomeViewController.swift
//  Sillo
//
//  Created by Eashan Mathur on 1/28/21.
//

import UIKit


class HomeViewController: UIViewController {
    
    private let posts = [ //placeholder data, TODO: fetch from firebase
        Post(alias: "Potato", name: "Alexa", profilePicture: UIImage(named:"avatar-1"), message: "Hey I really like potatoes what abotu you and this is some long long long text long long long text that should show up when cells are dynamic height please please work hello goodbye hello goodbye i need u to work constraint knowledge pls pull thru if u do it once u should be able to do it again", timeSent: "2.55pm"),
        Post(alias: "Apple Pie", name: "Barnie", profilePicture: UIImage(named:"avatar-2"), message: "BABABAABBANA BANAANAN ABANA BANA! BABABAABBANA BANAANAN ABANA BANA!BABABAABBANA BANAANAN ABANA BANA!BABABAABBANA BANAANAN ABANA BANA!BABABAABBANA BANAANAN ABANA BANA!", timeSent: "7.55pm"),
        Post(alias: "Bongo", name: "Sender", profilePicture: UIImage(named:"avatar-3"), message: "I really like candles would you like one here u go", timeSent: "7.55pm"),
        Post(alias: "Bingo", name: "Mickey", profilePicture: UIImage(named:"avatar-1"), message: "Did you know that hippo milk is pink??", timeSent: "7.33pm"),
        Post(alias: "Sink", name: "Siri", profilePicture: UIImage(named:"avatar-3"), message: "my favourite flavour of icecream is giraffe", timeSent: "5.15pm"),
        Post(alias: "Potato", name: "Aqua", profilePicture: UIImage(named:"avatar-1"), message: "baby shark doo doo doo doo do ", timeSent: "2.55pm"),
        Post(alias: "Apple Pie", name: "Bob", profilePicture: UIImage(named:"avatar-2"), message: "whooo is thta girl i see??? staring straight??? back at me", timeSent: "7.55pm"),
        Post(alias: "Bongo", name: "Angel", profilePicture: UIImage(named:"avatar-3"), message: "Houston to Apollo 13 do you copy o", timeSent: "7.55pm"),
        Post(alias: "Bingo", name: "Frances", profilePicture: UIImage(named:"avatar-1"), message: "I have a pencil and my pencil is black", timeSent: "7.33pm"),
        Post(alias: "Sink", name: "Seargant", profilePicture: UIImage(named:"avatar-1"), message: "I rly rly like sillo wbu rbo", timeSent: "5.15pm"),
        Post(alias: "Potato", name: "Aqua", profilePicture: UIImage(named:"avatar-1"), message: "baby shark doo doo doo doo do ", timeSent: "2.55pm"),
        Post(alias: "Apple Pie", name: "Bob", profilePicture: UIImage(named:"avatar-2"), message: "whooo is thta girl i see??? staring straight??? back at me", timeSent: "7.55pm"),
        Post(alias: "Bongo", name: "Angel", profilePicture: UIImage(named:"avatar-3"), message: "Houston to Apollo 13 do you copy o", timeSent: "7.55pm"),
        Post(alias: "Bingo", name: "Frances", profilePicture: UIImage(named:"avatar-1"), message: "I have a pencil and my pencil is black", timeSent: "7.33pm"),
        Post(alias: "Sink", name: "Seargant", profilePicture: UIImage(named:"avatar-1"), message: "I rly rly like sillo wbu rbo", timeSent: "5.15pm")
    ]

    let cellID = "cellID"
    let postsTable : UITableView = {
        let table = UITableView()
        table.translatesAutoresizingMaskIntoConstraints = false
        table.backgroundColor = .white
        table.separatorColor = .clear
        return table
    }()
    
    let header : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Color.headerBackground
        return view
    }()
        
    override func viewDidLoad() {
        
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        view.backgroundColor = .white
        setupHeader()
        setupTableView()
        
        //set up status bar up top
        self.setNeedsStatusBarAppearanceUpdate()
        if #available(iOS 13, *) {
          let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
            statusBar.backgroundColor = Color.headerBackground
          UIApplication.shared.keyWindow?.addSubview(statusBar)
        } else {
             let statusBar: UIView = UIApplication.shared.value(forKey: "statusBar") as! UIView
             if statusBar.responds(to:#selector(setter: UIView.backgroundColor)) {
                statusBar.backgroundColor = Color.headerBackground
             }
             UIApplication.shared.statusBarStyle = .lightContent
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .darkContent
    }
    
    
    func setupHeader() {
        view.addSubview(header)
        
        header.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        header.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        header.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        header.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        //app logo and team name stack
        let logoTeamStack = setupPhotoTeamName()
        header.addSubview(logoTeamStack)
        
        logoTeamStack.leadingAnchor.constraint(equalTo: header.safeAreaLayoutGuide.leadingAnchor, constant: 25).isActive = true
        logoTeamStack.topAnchor.constraint(equalTo: header.safeAreaLayoutGuide.topAnchor).isActive = true
        logoTeamStack.bottomAnchor.constraint(equalTo: header.bottomAnchor, constant: -15).isActive = true
        logoTeamStack.heightAnchor.constraint(equalToConstant: 40).isActive = true

        //team picture
        let teamPic = UIImageView()
        teamPic.image = UIImage(named: "avatar-2")
        teamPic.translatesAutoresizingMaskIntoConstraints = false
        teamPic.contentMode = .center
        teamPic.layer.masksToBounds = true
        teamPic.layer.borderWidth = 5.0
        teamPic.layer.borderColor = Color.gray.cgColor
        teamPic.frame = CGRect(x: 0, y: 0, width: 45, height: 45)
        teamPic.layer.cornerRadius = teamPic.frame.height / 2
        header.addSubview(teamPic)
        
        teamPic.rightAnchor.constraint(equalTo: header.safeAreaLayoutGuide.rightAnchor, constant: -16).isActive = true
        teamPic.centerYAnchor.constraint(equalTo: logoTeamStack.centerYAnchor).isActive = true
        teamPic.heightAnchor.constraint(equalToConstant: 45).isActive = true
        teamPic.widthAnchor.constraint(equalToConstant: 45).isActive = true
    }
    
    func setupPhotoTeamName() -> UIStackView {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 11
        stack.distribution = .fillProportionally
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        let silloLogo = UIImageView()
        silloLogo.image = UIImage(named: "sillo-logo-small")
        silloLogo.contentMode = .scaleAspectFit
        stack.addArrangedSubview(silloLogo)
        
        let clubName = UILabel()
        clubName.text = "Berkeley Design"
        clubName.font = Font.bold(22)
        clubName.textColor = Color.teamHeader
        stack.addArrangedSubview(clubName)
        
        return stack
    }
    
    func setupTableView() {
        postsTable.delegate = self
        postsTable.dataSource = self
        self.view.addSubview(postsTable)
        postsTable.rowHeight = UITableView.automaticDimension
        postsTable.estimatedRowHeight = 100
        postsTable.topAnchor.constraint(equalTo: header.bottomAnchor).isActive = true
        postsTable.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        postsTable.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        postsTable.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        postsTable.register(HomePostTableViewCell.self, forCellReuseIdentifier: cellID)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! HomePostTableViewCell
        cell.item = posts[indexPath.row]
        cell.separatorInset = UIEdgeInsets.zero
        return cell
    }
}
