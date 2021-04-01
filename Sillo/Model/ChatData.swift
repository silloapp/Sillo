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

var chatHandler = ChatHandler()

class ChatHandler {
    
    var activeChats = [String: ActiveChat]() // a dictionary mapping active chat to chat id
    var sortedChats = [ActiveChat]() // sorted chatIds to display in messagelistVC
    //var chatsList: [String] = []
    var messages: [String: [Message]] = [:]
    var postToChat: [String: String] = [:]
    
    //pulls the chatIds of active chats for this user, sets chandHander.chatsList to this
//    func coldStartChatList() {
//        chatsList = []
//        //updates chatList to contain chatIds of active chats for this user
//        let userID = Constants.FIREBASE_USERID ?? "ERROR"
//        print("PULLING CHAT ID LIST FOR \(userID)")
//        db.collection("user_chats").document(userID).collection("chats").order(by: "timestamp", descending: true).getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting chatList: \(err)")
//                return
//            } else {
//                for document in querySnapshot!.documents {
//                    //updating chat list
//                    let chatID = document.documentID
//                    chatHandler.chatsList.append(chatID)
//                    print("added \(chatID) to chatlist!!!!" )
//
//                }
//            }
//        }
//     print("chat list contains: \(chatsList)")
//
//    }

    //MARK: sort by time with recent on top, returns sorted list
    func sortActiveChats() -> [ActiveChat] {
        return activeChats.values.sorted(by: { $0.timestamp! > $1.timestamp! })
    }
    
    //fetches chat info to display in messageListVC: profile pic / alias/ latest msg and timestamp
    func fetchChatSummary(chatID: String) {
        
        //update chat metadata for message, latest message time
        db.collection("chats").document(chatID).getDocument() { (query, err) in
            if let query = query {
                if query.exists {
                    let postID = query.get("postID") as! String
                    let participant1_uid = query.get("participant1_uid") as! String
                    let participant1_name = query.get("participant1_name") as! String
                    let participant1_profile = query.get("participant1_profile") as! String
                    
                    let participant2_uid = query.get("participant2_uid") as! String
                    let participant2_name = query.get("participant2_name") as! String
                    let participant2_profile = query.get("participant2_profile") as! String
                    
                    let isRevealed = query.get("isRevealed") as! Bool
                    let isRead = query.get("isRead") as! Bool
                    let timestamp = Date(timeIntervalSince1970: TimeInterval((query.get("timestamp") as! Timestamp).seconds))
                    let latest_message = query.get("latest_message") as! String
                    
                    let conversation = ActiveChat(postID: postID, chatID: chatID, isRevealed: isRevealed, participant1_uid: participant1_uid, participant1_name: participant1_name, participant1_profile: participant1_profile, participant2_uid: participant2_uid, participant2_name: participant2_name, participant2_profile: participant2_profile, latest_message: latest_message, timestamp: timestamp, isRead: isRead)
                    self.activeChats[chatID] = conversation
                    self.postToChat[postID] = chatID
                }
            }
        }
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshMessageListView"), object: nil)
        
    }
    
    //creates a 
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
             "recipient_img": post.posterImageName ?? "ERROR",
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
             "recipient_img": generateImageName(),
             "receipient_name": generateAlias(),
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
            "postID": post.postID,
            //participant 1 is the poster
            "participant1_profile": post.posterImageName,
            "participant1_name": post.posterAlias,
            "participant1_uid": post.posterUserID,
            //participant 2 is the person who replied
            "participant2_profile": generateImageName(),
            "participant2_name": generateAlias(),
            "participant2_uid": message.senderID,
            
            "isRead" : true,
            "isRevealed": false,
            "timestamp" : message.timestamp,
            "latest_message": message.message!
            
        ]){ err in
            if err != nil {
                print("Error sending message: \(chatId)")
            } else {
                print("Message document written: \(chatId)")
            }
        }
        
        NotificationCenter.default.post(name: Notification.Name("refreshChatView"), object: nil) //TODO: replace this

        
    }
    
    func attachChatListener(chatID: String) {
        // add query listner for the chat's message collection
        let messageSubCol = db.collection("chats").document(chatID)
            .collection("messages")
        messageSubCol.addSnapshotListener {
            (querySnapshot, err) in
            guard let snapshot = querySnapshot else {
                print("Error fetching snapshots: \(err!)")
                return
            }
            
            snapshot.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    let chatID = diff.document.documentID
                    print("New active chat: \(chatID)")
                    //add or update active chat
                    chatHandler.fetchChatSummary(chatID: chatID)
                }
                
                if (diff.type == .modified) {
                    let chatID = diff.document.documentID
                    print("Modified active chat: \(chatID)")
                    chatHandler.fetchChatSummary(chatID: chatID)
                }
                
                if (diff.type == .removed) {
                    let chatID = diff.document.documentID
                    print("Deleted active chat: \(chatID)")
                    chatHandler.activeChats[chatID] = nil
                }
            }
            
            
            // TODO : fetch new messages, create struct, and add to list/dict in call back
            // add sender alias, name, and pfp in backend
        }
    }
    
    // send message in an existing conversation
    func sendMessage(chatId: String, message: String, attachment: UIImage?) {
        let messageSubCol = db.collection("chats").document(chatId).collection("messages")
        
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
//                    NotificationCenter.default.post(name: Notification.Name("refreshChatView"), object: nil) //TODO: replace this
                    NotificationCenter.default.post(name: Notification.Name("refreshMessageListView"), object: nil)
                    
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
    
    //MARK: sign out helper function, reinstantiate
    func clearChatData() {
        chatHandler = ChatHandler()
    }

}
