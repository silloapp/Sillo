/*
 MIT License
 
 Copyright (c) 2017-2018 MessageKit
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.
 */

import UIKit
import MessageInputBar

enum MessageInputBarStyle: String {
    
    case facebook = "Facebook"
    case `default` = "Default"
    
    func generate() -> MessageInputBar {
        switch self {
        // case .imessage: return iMessageInputBar()
        // case .slack: return SlackInputBar()
        // case .githawk: return GitHawkInputBar()
        case .facebook: return FacebookInputBar()
        case .default: return MessageInputBar()
        }
    }
}

final class ChatsViewController: UITableViewController {
    
    // MARK: - Properties
    
    override var inputAccessoryView: UIView? {
        return messageInputBar
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    /// The object that manages attachments
    /*  lazy var attachmentManager: AttachmentManager = { [unowned self] in
     let manager = AttachmentManager()
     manager.delegate = self
     return manager
     }()
     
     /// The object that manages autocomplete
     lazy var autocompleteManager: AutocompleteManager = { [unowned self] in
     let manager = AutocompleteManager(for: self.messageInputBar.inputTextView)
     manager.delegate = self
     manager.dataSource = self
     return manager
     }()*/
    
    let screenSize = UIScreen.main.bounds
    let users = ["nathantannar4", "SD10"]
    let hastags = ["MessageKit", "MessageInputBar"]
    
    // MARK: - MessageInputBar
    
    private let messageInputBar: MessageInputBar
    
    // MARK: Init
    
    init(messageInputBarStyle: MessageInputBarStyle) {
        self.messageInputBar = messageInputBarStyle.generate()
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //for initialising Table:
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        //  self.tableView.frame = CGRect(x: 0, y: 200, width: screenSize.width, height: screenSize.height)
        
        // automaticallyAdjustsScrollViewInsets = false
        
        
        self.tableView.separatorStyle = .none
        
        
        self.tableView.register(ChatsbleViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.delegate = self
        self.tableView.dataSource = self
        
        view.backgroundColor = ViewBgColor
        tableView.keyboardDismissMode = .interactive
        messageInputBar.delegate = self
        
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        //            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        //        }
        
        // self.tableView.contentInset = UIEdgeInsets(top: 120, left: 0, bottom: 0, right: 0)
    }
    @objc private func keyboardWillShow(notification: NSNotification) {
        
        print("keyb show")
        
        var _kbSize:CGSize!
        
        if let info = notification.userInfo {
            
            let frameEndUserInfoKey = UIResponder.keyboardFrameEndUserInfoKey
            
            //  Getting UIKeyboardSize.
            if let kbFrame = info[frameEndUserInfoKey] as? CGRect {
                
                let screenSize = UIScreen.main.bounds
                
                //Calculating actual keyboard displayed size, keyboard frame may be different when hardware keyboard is attached (Bug ID: #469) (Bug ID: #381)
                let intersectRect = kbFrame.intersection(screenSize)
                
                if intersectRect.isNull {
                    _kbSize = CGSize(width: screenSize.size.width, height: 0)
                } else {
                    _kbSize = intersectRect.size
                }
                print("Your Keyboard Size \(_kbSize)")
                tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: _kbSize.height, right: 0)
            }
        }
        
        
        
        //        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
        //
        //
        //
        //            print("keyboardSize.height",keyboardSize.height)
        //
        //            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height, right: 0)
        // }
    }
    
    @objc private func keyboardWillHide(notification: NSNotification) {
        print("keyb hide")
        
        self.tableView.contentInset = .zero
    }
    func setNavBar() {
        navigationController?.navigationBar.barTintColor = UIColor.init(red: 242/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        navigationController?.navigationBar.isTranslucent = false
        self.title = "Full Name"
        
        
        let label = UILabel()
        label.text = "Full Name"
        label.textAlignment = .left
        label.textColor = .gray
        label.font = UIFont.init(name: "Apercu-Regular", size: 16)
        
        self.navigationItem.titleView = label
        
        label.superview?.addConstraint(NSLayoutConstraint(item: label, attribute: .centerX, relatedBy: .equal, toItem: label.superview, attribute: .centerX, multiplier: 1, constant: -120))
        label.superview?.addConstraint(NSLayoutConstraint(item: label, attribute: .width, relatedBy: .equal, toItem: label.superview, attribute: .width, multiplier: 0.5, constant: 0))
        label.superview?.addConstraint(NSLayoutConstraint(item: label, attribute: .centerY, relatedBy: .equal, toItem: label.superview, attribute: .centerY, multiplier: 1, constant: 0))
        label.superview?.addConstraint(NSLayoutConstraint(item: label, attribute: .height, relatedBy: .equal, toItem: label.superview, attribute: .height, multiplier: 1, constant: 0))
        
        //  NSLayoutConstraint.activate(BottomTableconstraints)
        
        self.view.layoutIfNeeded()
        label.translatesAutoresizingMaskIntoConstraints = false
        
        
        //setting buttons
        let backbutton = UIButton(type: UIButton.ButtonType.custom)
        backbutton.setImage(UIImage(named: "back"), for: .normal)
        backbutton.addTarget(self, action:#selector(backBtnPressed), for: .touchUpInside)
        backbutton.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        let barbackbutton = UIBarButtonItem(customView: backbutton)
        
        let Imagebutton = UIButton(type: UIButton.ButtonType.custom)
        Imagebutton.setImage(UIImage(named: "Nathan"), for: .normal)
        Imagebutton.addTarget(self, action:#selector(backBtnPressed), for: .touchUpInside)
        Imagebutton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        //    Imagebutton.clipsToBounds = true
        //    Imagebutton.layer.cornerRadius = 20
        Imagebutton.imageView?.contentMode = .scaleAspectFill
        let barImagebutton = UIBarButtonItem(customView: Imagebutton)
        
        /* let titlebutton = UIButton(type: UIButton.ButtonType.custom)
         titlebutton.setTitle("Full Name", for: .normal)
         titlebutton.setTitleColor(.gray, for: .normal)
         titlebutton.titleLabel?.font = UIFont.init(name: "Apercu-Regular", size: 16)
         titlebutton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
         titlebutton.imageView?.contentMode = .scaleAspectFill
         let bartitlebutton = UIBarButtonItem(customView: Imagebutton)*/
        
        
        self.navigationItem.leftBarButtonItems = [barbackbutton,barImagebutton]
        
        let Rightbutton2 = UIButton(type: UIButton.ButtonType.custom)
        Rightbutton2.setImage(UIImage(named: "menu"), for: .normal)
        Rightbutton2.addTarget(self, action:#selector(menuMethod), for: .touchUpInside)
        Rightbutton2.frame = CGRect(x: 0, y: 0, width: 20, height: 30)
        let barRightbutton2 = UIBarButtonItem(customView: Rightbutton2)
        self.navigationItem.rightBarButtonItems = [barRightbutton2]
        
        
    }
    
    
    
    @objc func backBtnPressed() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func menuMethod() {
        self.navigationController?.popViewController(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = false
        setNavBar()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        navigationController?.isNavigationBarHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if #available(iOS 13, *) {
            let statusBar = UIView(frame: (UIApplication.shared.keyWindow?.windowScene?.statusBarManager?.statusBarFrame)!)
            statusBar.backgroundColor = UIColor.init(red: 242/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
            UIApplication.shared.keyWindow?.addSubview(statusBar)
        }
        else {
            let statusBar = UIApplication.shared.value(forKeyPath: "statusBarWindow.statusBar") as? UIView
            statusBar?.backgroundColor = UIColor.init(red: 242/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)
        }
    }
    
    
    
    //=============================*** DELEGATE DATASOURCE METHODS ***===============================//
    
    //MARK :  Table View Delegate Methods:
    
    //    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    //       return 90
    //    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ChatsbleViewCell
        cell.selectionStyle = .none
        print("cell for row")
        
        var Rightheight = CGFloat()
        var leftheight = CGFloat()
        
        var Rightwidth = CGFloat()
        var leftwidth = CGFloat()
        
        if indexPath.row % 2 == 0
        {
            cell.labLeft.isHidden = true
            cell.labRight.isHidden = false
            
            if indexPath.row == 0
            {
                cell.labRight.text = "OK"
            }
            else if indexPath.row == 6
            {
                cell.labRight.text = "lorem ispum"
            }
            else
            {
                cell.labRight.text = "lorem ispum dollar sit lorem ikspum loremm"
            }
            
            Rightheight = cell.labRight.text!.stringHeight + 30
            
            let RightW = cell.labRight.text!.stringWidth
            if RightW <= 200
            {
                Rightwidth = RightW + 30
            }
            else
            {
                Rightwidth = 200
            }
        }
        else
        {
            cell.labLeft.isHidden = false
            cell.labRight.isHidden = true
            cell.labLeft.text = "lorem ispum dollar sit lorem ikspum loremm"
            leftheight = cell.labLeft.text!.stringHeight + 30
            
            
            let leftW = cell.labLeft.text!.stringWidth + 30
            if leftW <= 200
            {
                leftwidth = leftW
            }
            else
            {
                leftwidth = 200
            }
            
        }
        
        //        let Rightheight = (cell.labRight.maxNumberOfLines*20) + 50
        //        let leftheight = (cell.labLeft.maxNumberOfLines*20) + 50
        
        
        print("Rightheight",Rightheight)
        print("leftheight",leftheight)
        
        cell.ViewRightconstraints = [
            cell.ViewRight.topAnchor.constraint(equalTo:  cell.contentView.topAnchor, constant: 8),
            cell.ViewRight.widthAnchor.constraint(equalToConstant: Rightwidth),
            cell.ViewRight.heightAnchor.constraint(equalToConstant: CGFloat(Rightheight)),
            cell.ViewRight.rightAnchor.constraint(equalTo:  cell.contentView.rightAnchor, constant: -20),
            cell.ViewRight.bottomAnchor.constraint(equalTo:  cell.contentView.bottomAnchor, constant: -8)
        ]
        
        
        cell.Viewleftconstraints = [
            cell.Viewleft.topAnchor.constraint(equalTo:  cell.contentView.topAnchor, constant: 8),
            cell.Viewleft.heightAnchor.constraint(equalToConstant: CGFloat(leftheight)),
            cell.Viewleft.widthAnchor.constraint(equalToConstant: leftwidth),
            cell.Viewleft.leftAnchor.constraint(equalTo:  cell.contentView.leftAnchor, constant: 20),
            cell.Viewleft.bottomAnchor.constraint(equalTo:  cell.contentView.bottomAnchor, constant: -8)
        ]
        
        NSLayoutConstraint.activate(cell.ViewRightconstraints)
        NSLayoutConstraint.activate(cell.Viewleftconstraints)
        
        cell.contentView.layoutIfNeeded()
        
        return cell
        
    }
    
    
}

extension ChatsViewController: MessageInputBarDelegate {
    
    func messageInputBar(_ inputBar: MessageInputBar, didPressSendButtonWith text: String) {
        // Use to send the message
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, textViewTextDidChangeTo text: String) {
        // Use to send a typing indicator
    }
    
    func messageInputBar(_ inputBar: MessageInputBar, didChangeIntrinsicContentTo size: CGSize) {
        // Use to change any other subview insets
    }
    
}


// MARK: - AttachmentManagerDelegate


// MARK: - AttachmentManagerDelegate Helper




// MARK: - AutocompleteManagerDelegate Helper



extension ChatsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    private func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        dismiss(animated: true, completion: {
            if let pickedImage = info[UIImagePickerController.InfoKey.originalImage.rawValue] as? UIImage {
                /* let handled = self.attachmentManager.handleInput(of: pickedImage)
                 if !handled {
                 // throw error
                 }*/
            }
        })
    }
}


class ChatsbleViewCell: UITableViewCell {
    
    
    let labRight = UILabel()
    let labLeft = UILabel()
    
    let Viewleft = UIView()
    let ViewRight = UIView()
    
    
    var labLeftconstraints = [NSLayoutConstraint]()
    var labRightconstraints = [NSLayoutConstraint]()
    
    var Viewleftconstraints = [NSLayoutConstraint]()
    var ViewRightconstraints = [NSLayoutConstraint]()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = .clear
        contentView.backgroundColor = .clear
        
        // for views:
        
        contentView.addSubview(ViewRight)
        // labRight.backgroundColor = UIColor.init(red: 231/255/0, green: 239/255.0, blue: 251/255.0, alpha: 0.7)
        ViewRight.backgroundColor = hexStringToUIColor(hex: "#E7EFFB")
        
        // labRight.text = "lorem ispum dollar sit lorem ikspum lorem lore"
        //  labRight.backgroundColor = .clear
        
        ViewRight.layer.cornerRadius = 17
        
        ViewRightconstraints = [
            ViewRight.topAnchor.constraint(equalTo:  contentView.topAnchor, constant: 8),
            ViewRight.widthAnchor.constraint(equalToConstant: 200),
            ViewRight.heightAnchor.constraint(equalToConstant: 80),
            ViewRight.rightAnchor.constraint(equalTo:  contentView.rightAnchor, constant: -15),
            ViewRight.bottomAnchor.constraint(equalTo:  contentView.bottomAnchor, constant: -8)
        ]
        
        contentView.addSubview(Viewleft)
        Viewleft.backgroundColor = UIColor.init(red: 253/255.0, green: 242/255.0, blue: 220/255.0, alpha: 1)
        Viewleft.layer.cornerRadius = 17
        
        Viewleftconstraints = [
            Viewleft.topAnchor.constraint(equalTo:  contentView.topAnchor, constant: 8),
            Viewleft.heightAnchor.constraint(equalToConstant: 80),
            Viewleft.widthAnchor.constraint(equalToConstant: 200),
            Viewleft.leftAnchor.constraint(equalTo:  contentView.leftAnchor, constant: 15),
            Viewleft.bottomAnchor.constraint(equalTo:  contentView.bottomAnchor, constant: -8)
        ]
        
        
        // FOR LABELS :
        
        
        ViewRight.addSubview(labRight)
        // labRight.backgroundColor = UIColor.init(red: 231/255/0, green: 239/255.0, blue: 251/255.0, alpha: 0.7)
        labRight.backgroundColor = hexStringToUIColor(hex: "#E7EFFB")
        
        // labRight.text = "lorem ispum dollar sit lorem ikspum lorem lore"
        //  labRight.backgroundColor = .clear
        labRight.textColor = .black
        labRight.font = UIFont(name: "Apercu-Regular", size: 15)
        labRight.numberOfLines = 0
        labRight.textAlignment = .center
        labRight.clipsToBounds = true
        // labRight.layer.cornerRadius = 17
        
        labRightconstraints = [
            labRight.topAnchor.constraint(equalTo:  ViewRight.topAnchor, constant: 8),
            labRight.leftAnchor.constraint(equalTo:  ViewRight.leftAnchor, constant: 8),
            
            labRight.rightAnchor.constraint(equalTo:  ViewRight.rightAnchor, constant: -8),
            labRight.bottomAnchor.constraint(equalTo:  ViewRight.bottomAnchor, constant: -8)
        ]
        
        Viewleft.addSubview(labLeft)
        labLeft.backgroundColor = UIColor.init(red: 253/255.0, green: 242/255.0, blue: 220/255.0, alpha: 1)
        // labLeft.text = "lorem ispum dollar sit lorem ikspum lorem ispum dollar sit lorem"
        // labLeft.backgroundColor = .clear
        labLeft.textColor = .black
        labLeft.font = UIFont(name: "Apercu-Regular", size: 15)
        labLeft.textAlignment = .center
        labLeft.numberOfLines = 0
        
        labLeft.clipsToBounds = true
        //labLeft.layer.cornerRadius = 17
        
        labLeftconstraints = [
            labLeft.topAnchor.constraint(equalTo:  Viewleft.topAnchor, constant: 8),
            labLeft.rightAnchor.constraint(equalTo:  Viewleft.rightAnchor, constant: -8),
            
            labLeft.leftAnchor.constraint(equalTo:  Viewleft.leftAnchor, constant: 8),
            labLeft.bottomAnchor.constraint(equalTo:  Viewleft.bottomAnchor, constant: -8)
        ]
        
        labRight.lineBreakMode = .byWordWrapping
        labLeft.lineBreakMode = .byWordWrapping
        
        // LAYOUT VIEW:
        
        
        NSLayoutConstraint.activate(Viewleftconstraints)
        NSLayoutConstraint.activate(ViewRightconstraints)
        
        NSLayoutConstraint.activate(labRightconstraints)
        NSLayoutConstraint.activate(labLeftconstraints)
        
        
        ViewRight.translatesAutoresizingMaskIntoConstraints = false
        Viewleft.translatesAutoresizingMaskIntoConstraints = false
        
        labRight.translatesAutoresizingMaskIntoConstraints = false
        labLeft.translatesAutoresizingMaskIntoConstraints = false
        
        
        contentView.layoutIfNeeded()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
}
extension String {
    var stringWidth: CGFloat {
        let constraintRect = CGSize(width: UIScreen.main.bounds.width, height: .greatestFiniteMagnitude)
        let boundingBox = self.trimmingCharacters(in: .whitespacesAndNewlines).boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
        return boundingBox.width
    }
    
    var stringHeight: CGFloat {
        let constraintRect = CGSize(width: UIScreen.main.bounds.width, height: .greatestFiniteMagnitude)
        let boundingBox = self.trimmingCharacters(in: .whitespacesAndNewlines).boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 14)], context: nil)
        return boundingBox.height
    }
}
