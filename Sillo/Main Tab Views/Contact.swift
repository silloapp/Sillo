//
//  Contact.swift
//  Sillo
//
//  Created by Angelica on 2/22/2021
//

import Foundation
import UIKit

struct MenuItem {
    let name:String?
    let nextVC:UIViewController?
    let withArrow:Bool?
    let fontSize:CGFloat?
}

struct Message { //testing only
    let alias: String?
    let name: String?
    let profilePicture: UIImage?
    let message: String?
    let timeSent: String?
    let isRead: Bool?
    //TODO: add image/gif, conversationID, whatever else
}

struct Post {
    let postID: String?
    let attachment: String?
    let message: String?
    let posterAlias: String?
    let posterImage: UIImage?
    let date: Date?
}
