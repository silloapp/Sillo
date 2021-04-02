//
//  Contact.swift
//  Sillo
//
//  Created by Angelica on 2/22/2021
//

import Foundation
import UIKit
import Firebase

struct MenuItem {
    let name:String?
    let nextVC:UIViewController?
    let withArrow:Bool?
    let fontSize:CGFloat?
}

struct Message:Equatable { //testing only
    let senderID: String?
    let message: String?
    let attachment: UIImage?
    let timestamp: Date?
    let isRead: Bool? //todo: remove this? 
}

struct ChatMetadata {

    let chatID: String?
    let postID: String?
    
    let isRead: Bool?
    let isRevealed: Bool?
    let latest_message: String? // this will be pulled from chat document
    let latestMessageTimestamp: Date?
    let recipient_image : String?
    let recipient_name : String?
    let recipient_uid : String?
    let timestamp : Date?
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
