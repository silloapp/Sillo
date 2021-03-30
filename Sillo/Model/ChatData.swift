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
    var postToChat: [String: String] = [:]
<<<<<<< Updated upstream
    var chatIdtoChat: [String: Chat] = [:]
    var messages: [String: [Message]] = [:]
    
    // creating a chat by responding to a post
=======
    var msgBatchSize = 15 //number of messages to get per "batch"
    
    //MARK: cold start
//    func coldStart() {
//        //get list of active chat ids for user
//        self.chatsList = []
//        self.messages = [:]
//        let userID = Constants.FIREBASE_USERID ?? "ERROR"
//        print("PULLING CHAT ID LIST FOR \(userID)")
//        db.collection("user_chats").document(userID).collection("chats").order(by: "timestamp", descending: true).limit(to: msgBatchSize).getDocuments() { (querySnapshot, err) in
//            if let err = err {
//                print("Error getting documents: \(err)")
//                return
//            } else {
//                for document in querySnapshot!.documents {
//                    //print("\(document.documentID) => \(document.data())")
//                    let chatID = document.documentID
//                    let timestamp = document.get("timestamp") as! Timestamp
//
//                    self.chatsList.append(chatID)
//                    self.messages[chatID] = []
//                }
//            }
//        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshChatTableView"), object: nil)
//        }
//
//
//        //now populate messages for each active chat
//        for chatID in chatsList {
//            db.collection("chats").document(chatID).collection("messages").order(by: "timestamp", descending: true).limit(to: msgBatchSize).getDocuments() { (querySnapshot, err) in
//                if let err = err {
//                    print("Error getting documents: \(err)")
//                    return
//                } else {
//                    for document in querySnapshot!.documents {
//                        //print("\(document.documentID) => \(document.data())")
//                        let chatID = document.documentID
//                        let msg = Message(alias: "Placeholder alias", name: document.get("sender_UID") as! String, profilePicture: UIImage(named:"avatar-4"), message: document.get("message") as! String, attachment: UIImage(named:"avatar-4"), timestamp: document.get("timestamp") as? Date, isRead: false)
//                        self.messages[chatID]?.append(msg)
//                    }
//                }
//
//        }
//
//        }
//    }
    
    func coldStart() {
        //MARK: attach listener
        chatHandler.chatsList = []
        let myUserID = Constants.FIREBASE_USERID ?? "ERROR"
            
            //update chats list
            let userID = Constants.FIREBASE_USERID ?? "ERROR"
            print("PULLING CHAT ID LIST FOR \(userID)")
            db.collection("user_chats").document(userID).collection("chats").order(by: "timestamp", descending: true).limit(to: 15).getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                    return
                } else {
                    for document in querySnapshot!.documents {
                        //print("\(document.documentID) => \(document.data())")
                        let chatID = document.documentID
                        
                        chatHandler.chatsList.append(chatID)
                        print("added \(chatID) to chatlist" )
                        chatHandler.messages[chatID] = []
                    }
                    
                    print("chatlist is \(chatHandler.chatsList)")
                }
            }
            
            //gets latest message for each active chat
            print("chatsList pulled: \(chatHandler.chatsList)")
            for chatid in chatHandler.chatsList {
                self.messages[chatID]? = []
                let doc = db.collection("chats").document(chatid).collection("messages").order(by: "timestamp", descending: true).limit(to: msgBatchSize).getDocuments(){ (querySnapshot, err) in
                                   if let err = err {
                                       print("Error getting documents: \(err)")
                                      return
                                    } else {
                                        for document in querySnapshot!.documents {
                                            //print("\(document.documentID) => \(document.data())")
                                           let chatID = document.documentID
                                            let msg = Message(alias: "Placeholder alias", name: document.get("sender_UID") as! String, profilePicture: UIImage(named:"avatar-4"), message: document.get("message") as! String, attachment: UIImage(named:"avatar-4"), timestamp: document.get("timestamp") as? Date, isRead: false)
                                            self.messages[chatID]?.append(msg)
                                        }
                                    }
                    
                            }
            }
    }
    
    // adds chat to active chat list
    // adds post and original message to conversation
>>>>>>> Stashed changes
    func addChat(post: Post, message: String, attachment: UIImage?) {
        let chatId = UUID.init().uuidString
        let chatStruct = createChat(
            postId: post.postID!,
            chatId: chatId,
            recipientImageName: post.posterImageName!,
            recipientUserId: post.posterUserID!,
            recipientName: post.posterAlias!,
            revealed: false)
        let messageStruct = createMessage(
            senderId: Constants.FIREBASE_USERID!,
            message: message,
            attachment: attachment,
            timestamp: Date())
        
        updateUserChats(post: post, message: messageStruct, chatId: chatId)
        createChatDocument(chat: chatStruct, post: post, message: messageStruct)
        
        // update local data
        chatsList.append(chatId)
        postToChat[post.postID!] = chatId
        chatIdtoChat[chatId] = chatStruct
    }
            
    // add chat in user_chats (keeps track of active chats)
    func updateUserChats(post: Post, message: Message, chatId: String) {
        let userId = Constants.FIREBASE_USERID!
<<<<<<< Updated upstream
        let receipientId = post.posterUserID!
=======
        var receipientId = "placeholder_recipient id"
        receipientId = post.posterUserID!
>>>>>>> Stashed changes
        
        // adds chat for sender
        let senderChatDoc = db.collection("user_chats").document(userId)
            .collection("chats").document(chatId)
        
        senderChatDoc.setData(
            ["timestamp": message.timestamp!]) { err in
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
<<<<<<< Updated upstream
            ["timestamp": message.timestamp!]) {err in
=======
            ["recipient_UID": userId,
             "recipient_img": "placeholder",
             "receipient_name": message.alias ?? "Alias",
             "revealed": false,
             "timestamp": message.timestamp!]) {err in
>>>>>>> Stashed changes
            if err != nil {
                print("Error adding chat \(chatId) in userchats for recipient")
            } else {
                print("Added chat \(chatId) for recipient")
            }
        }
    }
    
    // create a new chat document that stores messages between users
    // includes the post message and first message sent by user
<<<<<<< Updated upstream
    func createChatDocument(chat: Chat, post: Post, message: Message) {
        let chatId = chat.chatId!
        let chatDoc = db.collection("chats").document(chatId)
        let messageSubCol = chatDoc.collection("messages")
        
        let userAlias = generateAlias()
        let userImage = generateImageName()
        
        // set metadata
        chatDoc.setData([
            "participant1_image": "images/\(post.posterImageName!)",
            "participant1_name": post.posterAlias!,
            "participant1_uid": post.posterUserID!,
            "participant2_image": "images/\(userImage)",
            "participant2_name": userAlias,
            "participant2_uid": Constants.FIREBASE_USERID!,
            "post_uid": post.postID!]) { err in
            if err != nil {
                print("Error setting metadata: \(chatId)")
            } else {
                print("Metadata set for \(chatId)")
            }
        }
        
        // write data for OP
        let opMessageId = UUID.init().uuidString
        let opMessageDoc = messageSubCol.document(opMessageId)
        
        opMessageDoc.setData([
            "attachment": "",
            "message": post.message!,
            "sender_UID": post.posterUserID!,
            "timestamp": post.date!]) { err in
            if err != nil {
                print("Error sending message: \(opMessageId)")
=======
    // called when user sends a reply to a post
    func createChatDocument(chatId: String, post: Post, message: Message) {
        let messageSubCol = db.collection("chats").document(chatId)
            .collection("messages")
        //only adds post to conversation
        sendMessage(chatId: chatId, message: post.message!, attachment: UIImage())
        
        // add query listner for the chat's message collection
        messageSubCol.addSnapshotListener {(querySnapshot, err) in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching new messages documents for chat \(chatId)")
                return
            }
            if let err = err {
                print("Error getting documents: \(err)")
                return
>>>>>>> Stashed changes
            } else {
                // TODO : fetch new messages, create struct, and add to list/dict in call back
                // add sender alias, name, and pfp in backend
                for document in querySnapshot!.documents {
                    let chatID = document.documentID
                    let msg = Message(alias: "Placeholder alias", name: (document.get("sender_UID") as! String), profilePicture: UIImage(named:"avatar-4"), message: document.get("message") as! String, attachment: UIImage(named:"avatar-4"), timestamp: document.get("timestamp") as? Date, isRead: false)
                    self.messages[chatID]?.append(msg)
                }
            }
        }
        
        let placeholder_post = Post(postID: "postid", attachment: "", message: "message", posterUserID: "posteruserid", posterAlias: "alias", posterImage: UIImage(), date: Date())
        let placeholder_msg = Message(alias: "aliasss", name: "msg name", profilePicture: UIImage(), message: "some msg", attachment: UIImage(), timestamp: Date(), isRead: false)
        updateUserChats(post: placeholder_post, message: placeholder_msg, chatId: chatId)
    }
    
    // send message in an existing conversation
    func sendMessage(chatId: String, message: String, attachment: UIImage) {
        
        let messageSubCol = db.collection("chats").document(chatId)
            .collection("messages")
        
        // write data for user's reply
        let senderMessageId = UUID.init().uuidString
        let senderMessageDoc = messageSubCol.document(senderMessageId)
        
        var imagePath: String? = nil
        if (attachment != nil) {
            let imageId = UUID.init().uuidString
            imagePath = "images/\(imageId).jpeg"
            let storageRef = Constants.storage.reference(withPath: imagePath!)
            guard let attachment = attachment.jpegData(compressionQuality: 0.75) else {return }
            let uploadMetaData = StorageMetadata.init()
            uploadMetaData.contentType = "image/jpeg"
            storageRef.putData(attachment, metadata:uploadMetaData)
        }
        
        senderMessageDoc.setData(
            ["attachment": imagePath!,
             "message": message,
             "sender_UID": Constants.FIREBASE_USERID!,
<<<<<<< Updated upstream
             "timestamp": message.timestamp!]) { err in
            if err != nil {
                print("Error sending message: \(senderMessageId)")
            } else {
                print("Message document written: \(senderMessageId)")
            }
        }
        
        addListenerToNewChat(chatId: chatId)
        
        let postMessage = createMessage(
            senderId: post.posterUserID!,
            message: post.message!,
            attachment: UIImage(named: post.attachment!),
            timestamp: post.date!)
        messages[chatId] = [postMessage]
        messages[chatId]!.append(message)
    }
    
    // send message in an existing conversation
    func sendMessage(chat: Chat, message: String, attachment: UIImage?) {
        let timestamp = Date()
        let chatId = chat.chatId!
        let messageId = UUID.init().uuidString
        let messageDoc = db.collection("chats").document(chatId)
            .collection("messages").document(messageId)
=======
             "timestamp": Date()]) { err in
                if err != nil {
                    print("Error sending message: \(senderMessageId)")
                } else {
                    print("Message document written: \(senderMessageId)")
                }
        }
       
>>>>>>> Stashed changes
        
        var imagePath: String? = nil
        if (attachment != nil) {
            let imageId = UUID.init().uuidString
            imagePath = "images/\(imageId).jpeg"
            let storageRef = Constants.storage.reference(withPath: imagePath!)
            guard let attachment = attachment!.jpegData(compressionQuality: 0.75) else {return }
            let uploadMetaData = StorageMetadata.init()
            uploadMetaData.contentType = "image/jpeg"
            storageRef.putData(attachment, metadata:uploadMetaData)
        }
        
        messageDoc.setData([
            "attachment": imagePath!,
            "message": message,
            "sender_UID": Constants.FIREBASE_USERID!,
            "timestamp": timestamp]) { err in
            if err != nil {
                print("Error sending message \(messageId)")
            } else {
                print("Sucessfully sent message \(messageId)")
            }
        }
        
        let messageStruct = createMessage(
            senderId: Constants.FIREBASE_USERID!,
            message: message,
            attachment: attachment,
            timestamp: timestamp)
        
        if messages.keys.contains(chatId) {
            messages[chatId]!.append(messageStruct)
        } else {
            messages[chatId] = [messageStruct]
        }
    }
    
    // RECIPIENT: when a new chat request comes in
    // 1. get the chat document and add to our local data
    // 2. add listener to the chat's message subcollection
    func addNewChat(chatId: String) {
        let chatDoc = db.collection("chats").document(chatId)
        
<<<<<<< Updated upstream
        chatDoc.getDocument { (document, error) in
            if let document = document, document.exists {
                let postId = document.get("post_uid") as! String
                let participant1 = document.get("participant1_uid") as! String
                let participant2 = document.get("participant2_uid") as! String
                
                if (participant1 == Constants.FIREBASE_USERID!) {
                    let recipientImage = document.get("participant2_image") as! String
                    let recipientName = document.get("participant2_name") as! String
                    let revealed = document.get("revealed") as! Bool
                    let chat = self.createChat(
                        postId: postId,
                        chatId: chatId,
                        recipientImageName: recipientImage,
                        recipientUserId: participant2,
                        recipientName: recipientName,
                        revealed: revealed)
                    self.chatsList.append(chatId)
                    self.postToChat[postId] = chatId
                    self.chatIdtoChat[chatId] = chat
                } else {
                    let recipientImage = document.get("participant1_image") as! String
                    let recipientName = document.get("participant1_name") as! String
                    let revealed = document.get("revealed") as! Bool
                    let chat = self.createChat(
                        postId: postId,
                        chatId: chatId,
                        recipientImageName: recipientImage,
                        recipientUserId: participant1,
                        recipientName: recipientName,
                        revealed: revealed)
                    self.chatsList.append(chatId)
                    self.postToChat[postId] = chatId
                    self.chatIdtoChat[chatId] = chat
                }
            }
        }
        addListenerToNewChat(chatId: chatId)
=======
        
>>>>>>> Stashed changes
    }
    
    //add query listener to a new chat to listen for messages
    func addListenerToNewChat(chatId: String) {
        let messageSubCol = db.collection("chats").document(chatId)
            .collection("messages")
        
        messageSubCol.addSnapshotListener {
            (querySnapshot, err) in
            guard let documents = querySnapshot else {
                print("Error fetching chat documents.")
                return
            }
            documents.documentChanges.forEach { diff in
                if (diff.type == .added) {
                    let messageDoc = messageSubCol.document(diff.document.documentID)
                    messageDoc.getDocument { (document, error) in
                        if let document = document, document.exists {
                            let attachment = document.get("attachment") as! String
                            let message = document.get("message") as! String
                            let senderId = document.get("sender_uid") as! String
                            let timestamp = document.get("timestamp") as! Date
                            let messageStruct = self.createMessage(
                                senderId: senderId,
                                message: message,
                                attachment: UIImage(named: attachment),
                                timestamp: timestamp)
                        }
                    }
                }
            }
        }
    }
    
    // TODO: since not all images can be found locally, we should fetch the profile pic from storage/local as a UIImage
    // then pass in a new field of createChat
    func createChat(
        postId: String,
        chatId: String,
        recipientImageName: String,
        recipientUserId: String,
        recipientName: String,
        revealed: Bool) -> Chat {
        return Chat(
            postId: postId,
            chatId: chatId,
            recipientImage: UIImage(named: recipientImageName),
            recipientImageName: recipientImageName,
            recipientUserId: recipientUserId,
            recipientName: recipientName,
            revealed: revealed)
    }
    
    //builds message struct
    func createMessage(
        senderId: String,
        message: String,
        attachment: UIImage?,
        timestamp: Date) -> Message {
        return Message(
            senderUserId: senderId,
            message: message,
            attachment: attachment,
            timestamp: timestamp,
            isRead: false)
    }
    
    func generateAlias() -> String {
        let options: [String] = ["Beets", "Cabbage", "Watermelon", "Bananas", "Oranges", "Apple Pie", "Bongo", "Sink", "Boop"]
        return options.randomElement()!
    }
    
    func generateImageName() -> String {
        let options: [String] = ["1","2","3","4"]
        return "avatar-\(options.randomElement()!)"
    }
}
