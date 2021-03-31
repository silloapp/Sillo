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
    
    var activeChats = [ActiveChat]()
    var chatsList: [String] = []
    var messages: [String: [Message]] = [:]
    var postToChat: [String: String] = [:]
    
    //pulls the chatIds of active chats for this user, sets chandHander.chatsList to this
    func coldStartChatList() {
        chatsList = []
        //updates chatList to contain chatIds of active chats for this user
        let userID = Constants.FIREBASE_USERID ?? "ERROR"
        print("PULLING CHAT ID LIST FOR \(userID)")
        db.collection("user_chats").document(userID).collection("chats").order(by: "timestamp", descending: true).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting chatList: \(err)")
                return
            } else {
                for document in querySnapshot!.documents {
                    //updating chat list
                    let chatID = document.documentID
                    chatHandler.chatsList.append(chatID)
                    print("added \(chatID) to chatlist!!!!" )
                    
                }
            }
        }
     print("chat list contains: \(chatsList)")
   
    }
    
    //fetches chat info to display in messageListVC: profile pic / alias/ latest msg and timestamp
    func fetchChatSummary(chatID: String) {
        
        //update chat metadata for message, latest message time
        db.collection("chats").document(chatID).getDocument() { (query, err) in
            if let query = query {
                if query.exists {
                    var alias = ""
                    let revealed = query.get("revealed") as! Bool
                    let participant1_uid = query.get("participant1_uid") as! String
                    //todo: if not revealed, display alias, not name
                    if participant1_uid == Constants.FIREBASE_USERID {
                        alias = query.get("participant2_name") as! String
                    }else {
                        alias = query.get("participant1_name") as! String
                    }
                    let name = "Name"
                    let attachment = UIImage()
                    let isRead = false
                    let profilePicture = UIImage(named:"avatar-4") //replacethis
                    let timestamp = Date(timeIntervalSince1970: TimeInterval((query.get("timestamp") as! Timestamp).seconds)) as! Date
                    let message = query.get("latest_message") as! String
                    
                    let conversation = ActiveChat(alias: alias, name: name, profilePicture: profilePicture, message: message, attachment: attachment, timestamp: timestamp, isRead: isRead)
                    self.activeChats.append(conversation)
                }
            }
        }
        
        print("num of active chats is \(self.activeChats.count)")
        
    }
    
    func addChat(post: Post, message: String, attachment: UIImage?, chatId: String) {
        let chatId = chatId
        let userAlias = generateAlias()
        let userImage = generateImageName()
        let messageStruct = createMessage(
            senderID: Constants.FIREBASE_USERID ?? "ERROR",
            message: message,
            attachment: attachment,
            timestamp: Date())
        
        updateUserChats(post: post, message: messageStruct, chatId: chatId)
        createChatDocument(chatId: chatId, post: post, message: messageStruct)
    }
            
    // add chat in user_chats (keeps track of active chats)
    private func updateUserChats(post: Post, message: Message, chatId: String) {
        let userId = Constants.FIREBASE_USERID!
        
        // adds chat for sender
        let senderChatDoc = db.collection("user_chats").document(userId)
            .collection("chats").document(chatId)
        let receipientId = post.posterUserID!
        senderChatDoc.setData(
            ["recipient_UID": receipientId,
             "recipient_img": "placeholderimg",
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
            "senderID": post.posterUserID!,
            "attachment": "",
            "message": post.message!,
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
            ["senderID": Constants.FIREBASE_USERID!,
            "attachment": "",
             "message": message.message!,
             "timestamp": message.timestamp!]) { err in
                if err != nil {
                    print("Error sending message: \(senderMessageId)")
                } else {
                    print("Message document written: \(senderMessageId)")
                }
        }
        
        //write chat metadata
        let chatDoc = db.collection("chats").document(chatId)
        chatDoc.setData([
            //participant 1 is the poster
            "participant1_image": "replace this img",
            "participant1_name": post.posterAlias,
            "participant1_uid": post.posterUserID,
            //participant 2 is the person who replied
            "participant2_image": "participant2",
            "participant2_name": generateAlias(),
            "participant2_uid": message.senderID,
            "post_uid": post.postID,
            "revealed" : false,
            "timestamp" : message.timestamp,
            "latest_message": message.message!
            
        ]){ err in
            if err != nil {
                print("Error sending message: \(chatId)")
            } else {
                print("Message document written: \(chatId)")
            }
        }
        
        self.fetchChatSummary(chatID: chatId)
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
            "senderID": Constants.FIREBASE_USERID,
            "attachment": "", // TODO: upload UIImage to storage, then return the path string
            "message": message,
            "timestamp": Date()
        ]) { err in
            if err != nil {
                print("Error sending message: \(opMessageId)")
            } else {
                print("Message document written: \(opMessageId). Contents say: \(message)")
            }
        }
        
        //update chat metadata for message, latest message time
        db.collection("chats").document(chatId).getDocument() { (query, err) in
            if let query = query {
                if query.exists {
                    db.collection("chats").document(chatId).updateData(["latest_message": message, "timestamp": Timestamp.init(date: Date())])
                    NotificationCenter.default.post(name: Notification.Name("refreshChatView"), object: nil) //TODO: replace this
                }
            }
        }
        
        self.fetchChatSummary(chatID: chatId)
        
    }
    
    // RECIPIENT: when a new chat request comes in
    // 1. get the chat documents and get the messages
    // 2. add listener to the chat's message subcollection
    func addNewChat(chatId: String) {
        
    }
    
    // take a new message document, and parses it
    func parseNewChat() -> Message {
        return Message(senderID: "", message: nil, attachment: nil, timestamp: nil, isRead: nil)
    }
    
    func createMessage(
        senderID: String,
        message: String,
        attachment: UIImage?,
        timestamp: Date) -> Message {
        
        return Message(
            senderID: senderID,
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
