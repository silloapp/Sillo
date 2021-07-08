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

class FacebookInputBar: MessageInputBar,UITextViewDelegate {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure() {
        self.shadowColor = .none
        backgroundView.backgroundColor = ViewBgColor
        let button = InputBarButtonItem()
        button.setSize(CGSize(width: 0, height: 0), animated: false)
      //  button.setImage(#imageLiteral(resourceName: "ic_plus").withRenderingMode(.alwaysTemplate), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = UIColor(red: 0, green: 122/255, blue: 1, alpha: 1)
        inputTextView.backgroundColor = UIColor(red: 242/255, green: 244/255, blue: 244/255, alpha: 1)
        inputTextView.placeholder = "Say something nice..."
        inputTextView.placeholderTextColor = UIColor.lightGray
        
        inputTextView.font = UIFont(name: "Apercu-Regular", size: 16)
        inputTextView.delegate = self
       
        inputTextView.textContainerInset = UIEdgeInsets(top: 8, left: 16, bottom: 8, right: 16)
        inputTextView.placeholderLabelInsets = UIEdgeInsets(top: 8, left: 20, bottom: 8, right: 20)
        inputTextView.layer.borderColor = .none
        inputTextView.layer.borderWidth = 0.0
        inputTextView.layer.cornerRadius = 16.0
        inputTextView.layer.masksToBounds = true
        inputTextView.scrollIndicatorInsets = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        setLeftStackViewWidthConstant(to: 10, animated: false)
        setStackViewItems([button], forStack: .left, animated: false)
        sendButton.setSize(CGSize(width: 52, height: 36), animated: false)
        sendButton.titleLabel?.font = UIFont(name: "Apercu-Bold", size: 15)
    }
    
    //func textViewDidEndEditing(_ textView: UITextView) {
       // textView.resignFirstResponder()
   // }
    
}
