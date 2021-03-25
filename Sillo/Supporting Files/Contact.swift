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

struct Message {
    let messageId: String?
    let senderId: String?
    let message: String?
    let attachment: UIImage?
    let timestamp: Date?
    let isRead: Bool?
}

struct Chat {
    let postId: String?
    let chatId: String?
    var recipientImage: UIImage?
    var recipientImageName: String?
    let recipientUserId: String?
    var recipientName: String?
    var revealed: Bool?
    var lastMessageSent: Date?
}


struct Post {
    let postID: String?
    let attachment: String?
    let message: String?
    let posterUserID: String?
    let posterAlias: String?
    let posterImage: UIImage?
    let posterImageName: String?
    let date: Date?
}
