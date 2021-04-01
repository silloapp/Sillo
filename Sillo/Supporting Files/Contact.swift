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
//    let alias: String?
//    let name: String?
//    let profilePicture: UIImage?
    let senderID: String?
    let message: String?
    let attachment: UIImage?
    let timestamp: Date?
    let isRead: Bool?
    //TODO: add image/gif, conversationID, whatever else
}

struct ActiveChat { //testing only
    let postID: String?
    let chatID: String?
    let isRevealed: Bool?
    
    let participant1_uid: String?
    let participant1_name: String?
    let participant1_profile: String?
    
    let participant2_uid: String?
    let participant2_name: String?
    let participant2_profile: String?
    
    let latest_message: String?
    let timestamp: Date?
    let isRead: Bool?
    
    //TODO: add image/gif, conversationID, whatever else
}

struct Post {
    let postID: String?
    let attachment: String?
    let message: String?
    let posterUserID: String?
    let posterAlias: String?
    let posterImageName: String? // changed this to string
    let date: Date?
}
