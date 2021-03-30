//
//  ChatData.swift
//  Sillo
//
//  Created by Chi Tsai on 3/20/21.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage

let chatHandler = ChatHandler()

class ChatHandler {
    var chatsList: [String] = []
    var messages: [String: [Message]] = [:]
    var postToChat: [String: String] = [:]
    
    func addChat(post: Post, message: String, attachment: UIImage?, chatId: String) {
        let chatId = chatId
        let userAlias = generateAlias()
        let userImage = generateImageName()
        let messageStruct = createMessage(
            alias: userAlias,
            name: Constants.USERNAME!,
            profilePicture: userImage,
            message: message,
            attachment: attachment,
            timestamp: Date())
        
        updateUserChats(post: post, message: messageStruct, chatId: chatId)
        createChatDocument(chatId: chatId, post: post, message: messageStruct)
    }
            
    // add chat in user_chats (keeps track of active chats)
    private func updateUserChats(post: Post, message: Message, chatId: String) {
        let userId = Constants.FIREBASE_USERID!
        let receipientId = "placeholder"
        
        // adds chat for sender
        let senderChatDoc = db.collection("user_chats").document(userId)
            .collection("chats").document(chatId)
        
        senderChatDoc.setData(
            ["recipient_UID": receipientId,
             "recipient_img": "placeholder",
             "receipient_name": post.posterAlias!,
             "revealed": false,
             "timestamp": message.timestamp!]) { err in
            if err != nil {
                print("Error adding chat \(chatId) in userchats for sender")
            } else {
                print("Added chat \(chatId) for sender")
            }
        }
        
        // adds chat for recipient
        let recipientChatDoc = db.collection("user_chats").document(receipientId)
            .collection("chats").document(chatId)
        
        recipientChatDoc.setData(
            ["recipient_UID": userId,
             "recipient_img": "placeholder",
             "receipient_name": post.posterAlias!,
             "revealed": false,
             "timestamp": message.timestamp!]) {err in
            if err != nil {
                print("Error adding chat \(chatId) in userchats for recipient")
            } else {
                print("Added chat \(chatId) for recipient")
            }
        }
    }
    
    // create a new chat document that stores messages between users
    // includes the post message and first message sent by user
    private func createChatDocument(chatId: String, post: Post, message: Message) {
        let messageSubCol = db.collection("chats").document(chatId)
            .collection("messages")
        
        // write data for OP
        let opMessageId = UUID.init().uuidString
        let opMessageDoc = messageSubCol.document(opMessageId)
        
        opMessageDoc.setData([
            "attachment": "",
            "message": post.message!,
            "sender_UID": "placeholder",
            "timestamp": post.date!]) { err in
            if err != nil {
                print("Error sending message: \(opMessageId)")
            } else {
                print("Message document written: \(opMessageId)")
            }
        }
        
        
        // write data for user's reply
        let senderMessageId = UUID.init().uuidString
        let senderMessageDoc = messageSubCol.document(senderMessageId)
        
        var imagePath: String? = nil
        if (message.attachment != nil) {
            let imageId = UUID.init().uuidString
            imagePath = "images/\(imageId).jpeg"
            let storageRef = Constants.storage.reference(withPath: imagePath!)
            guard let attachment = message.attachment!.jpegData(compressionQuality: 0.75) else {return }
            let uploadMetaData = StorageMetadata.init()
            uploadMetaData.contentType = "image/jpeg"
            storageRef.putData(attachment, metadata:uploadMetaData)
        }
        
        senderMessageDoc.setData(
            ["attachment": "",
             "message": message.message!,
             "sender_UID": Constants.FIREBASE_USERID!,
             "timestamp": message.timestamp!]) { err in
                if err != nil {
                    print("Error sending message: \(senderMessageId)")
                } else {
                    print("Message document written: \(senderMessageId)")
                }
        }
        
        
        // add query listner for the chat's message collection
        messageSubCol.addSnapshotListener {
            (querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching new messages documents for chat \(chatId)")
                return
            }
            
            // TODO : fetch new messages, create struct, and add to list/dict in call back
            // add sender alias, name, and pfp in backend
        }
    }
    
    // send message in an existing conversation
    func sendMessage(chatId: String, message: String, attachment: UIImage?) {
        let messageSubCol = db.collection("chats").document(chatId)
            .collection("messages")
        
        // write data for OP
        let opMessageId = UUID.init().uuidString
        let opMessageDoc = messageSubCol.document(opMessageId)
        
        opMessageDoc.setData([
            "attachment": "", // TODO: upload UIImage to storage, then return the path string
            "message": message,
            "sender_UID": Constants.FIREBASE_USERID,
            "timestamp": Date()
        ]) { err in
            if err != nil {
                print("Error sending message: \(opMessageId)")
            } else {
                print("Message document written: \(opMessageId). Contents say: \(message)")
            }
        }
        
    }
    
    // RECIPIENT: when a new chat request comes in
    // 1. get the chat documents and get the messages
    // 2. add listener to the chat's message subcollection
    func addNewChat(chatId: String) {
        
    }
    
    // take a new message document, and parses it
    func parseNewChat() -> Message {
        return Message(alias: nil, name: nil, profilePicture: nil, message: nil, attachment: nil, timestamp: nil, isRead: nil)
    }
    
    func createMessage(
        alias: String,
        name: String,
        profilePicture: String,
        message: String,
        attachment: UIImage?,
        timestamp: Date) -> Message {
        
        return Message(
            alias: alias,
            name: name,
            profilePicture: UIImage(named: profilePicture),
            message: message,
            attachment: attachment,
            timestamp: timestamp,
            isRead: nil)
    }
    
    func generateAlias() -> String {
        let options: [String] = ["Beets", "Cabbage", "Watermelon", "Bananas", "Oranges", "Apple Pie", "Bongo", "Sink", "Boop", "Flamingo", "Tiger", "Rabbit", "Rhino", "Eagle", "Tomato", "Dinosaur", "Cherry", "Violin", "Dolphin"]
        return options.randomElement()!
    }
    
    func generateImageName() -> String {
        let options: [String] = ["1","2","3","4"]
        return "avatar-\(options.randomElement()!)"
    }
}
