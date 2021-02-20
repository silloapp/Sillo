//
//  MenuItem.swift
//  contactsapp
//
//  Created by SoftAuthor on 2019-04-20.
//  Copyright © 2019 SoftAuthor. All rights reserved.
//

import Foundation
import UIKit

struct MenuItem {
    let name:String?
    let nextVC:String?
    let withArrow:Bool?
    let fontSize:CGFloat?
}

struct Message { //THIS IS FOR TESTING ONLY
    let alias: String?
    let name: String?
    let profilePicture: UIImage?
    let message: String?
    let timeSent: String?
    let isRead: Bool?
}
