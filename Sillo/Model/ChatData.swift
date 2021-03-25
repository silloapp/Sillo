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
    let chatBatchSize = 15
    var chatsList: [Chat] = []
    var messages: [String: [Message]] = [:]
    var postToChat: [String: String] = [:]
    var chatIdtoChat: [String: Chat] = [:]
    var chatCursor: [String: QuerySnapshot?] = [:]
    var snapshot:QuerySnapshot? = nil
    
    // coldstart will pull the first 15 recent chats, with previews
    func coldStart() {
        let userId = Constants.FIREBASE_USERID!
        let next = db.collection("user_chats").document(userId)
            .collection("chats")
            .order(by: "timestamp", descending: true)
            .limit(to: chatBatchSize)
        next.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            } else {
                for document in querySnapshot!.documents {
                    self.addNewChat(chatId: document.documentID)
                }
            }
        }

        next.addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error retreving documents: \(error.debugDescription)")
                return
            }
            self.snapshot = snapshot
        }
    }
    
    /* After scrolling past the first 15 conversations, load more chat previews */
    func fetchChat() {
        let userId = Constants.FIREBASE_USERID!
        guard let lastSnapshot = self.snapshot!.documents.last else {
            return
        }
        let next = db.collection("user_chats").document(userId)
            .collection("chats")
            .order(by: "timestamp", descending: true)
            .limit(to: chatBatchSize)
            .start(afterDocument: lastSnapshot)
        next.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            } else {
                for document in querySnapshot!.documents {
                    // addNewChat should take care of refresh the list via fetchPreviewMessage
                    self.addNewChat(chatId: document.documentID)
                }
            }
        }

        next.addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error retreving documents: \(error.debugDescription)")
                return
            }
            self.snapshot = snapshot
        }
    }
    
    /* Used when creating a NEW conversation with someone */
    func startChat(post: Post, message: String, attachment: UIImage?) {
        let chatId = UUID.init().uuidString
        let timestamp = Date()
        
        let chatStruct = createChat(
            postId: post.postID!,
            chatId: chatId,
            recipientImage: post.posterImage!,
            recipientImageName: post.posterImageName!,
            recipientUserId: post.posterUserID!,
            recipientName: post.posterAlias!,
            revealed: false,
            lastMessageSent: timestamp)
        
        // add chat to database
        createUserChats(post: post, chatId: chatId, timestamp: timestamp)
        createChatDocument(chatId: chatId, post: post, message: message, attachment: attachment)
        
        // update changes locally
        chatsList.append(chatStruct)
        chatsList.sort { $0.lastMessageSent! > $1.lastMessageSent!}
        postToChat[post.postID!] = chatId
        chatIdtoChat[chatId] = chatStruct
    }
        
    /* Helper to create convo */
    func createUserChats(post: Post, chatId: String, timestamp: Date) {
        let userId = Constants.FIREBASE_USERID!
        let receipientId = post.posterUserID!
        
        // adds chat for sender
        let senderChatDoc = db.collection("user_chats").document(userId)
            .collection("chats").document(chatId)
        
        senderChatDoc.setData(
            ["timestamp": timestamp]) { err in
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
            ["timestamp": timestamp]) {err in
            if err != nil {
                print("Error adding chat \(chatId) in userchats for recipient")
            } else {
                print("Added chat \(chatId) for recipient")
            }
        }
    }
    
    /* Helper to create chat:
     - create a new chat document that stores messages between users
      includes the post message and first message sent by user
     */
    func createChatDocument(chatId: String, post: Post, message: String, attachment: UIImage?) {
        let userId = Constants.FIREBASE_USERID!
        let userAlias = generateAlias()
        let userImage = generateImageName()
        
        let recipientId = post.posterUserID!
        
        let chatDoc = db.collection("chats").document(chatId)
        
        chatDoc.setData(
            ["participant1_image": "images/\(post.posterImageName!)",
             "participant1_name": post.posterAlias!,
             "participant1_uid": post.posterUserID!,
             "participant2_image": "images/\(userImage)",
             "participant2_name": userAlias,
             "participant2_uid": userId,
             "revealed": false,
             "timestamp": post.date!]) {err in
            if err != nil {
                print("Error adding chat document \(chatId)")
            } else {
                print("Added chat document \(chatId)")
            }
        }
      
        sendMessage(recipientId: userId, chatId: chatId, message: post.message!, attachment: nil)
        sendMessage(recipientId: recipientId, chatId: chatId, message: message, attachment: attachment)
    }
    
    /* Use to send a new message in a conversation. */
    func sendMessage(recipientId: String, chatId: String, message: String, attachment: UIImage?) {
        let userId = Constants.FIREBASE_USERID!
        let messageId = UUID.init().uuidString
        let timestamp = Date()
        
        let chatDoc = db.collection("chats").document(chatId)
        
        chatDoc.updateData(["timestamp":timestamp]) { err in
            if err != nil  {
                print("Error updating chat document timestamp \(chatId)")
            }
        }
        
        // create message document
        let messageDoc = chatDoc.collection("messages").document(messageId)
        
        var imagePath: String? = nil
        if (attachment != nil) {
            let imageId = UUID.init().uuidString
            imagePath = "images/\(imageId).jpeg"
            let storageRef = Constants.storage.reference(withPath: imagePath!)
            guard let attachment = attachment!.jpegData(compressionQuality: 0.75) else {return}
            let uploadMetaData = StorageMetadata.init()
            uploadMetaData.contentType = "image/jpeg"
            storageRef.putData(attachment, metadata:uploadMetaData)
        }
        
        messageDoc.setData(
            ["attachment": imagePath!,
             "message": message,
             "sender_UID": userId,
             "timestamp": timestamp]) { err in
                if err != nil {
                    print("Error sending message: \(messageId)")
                } else {
                    print("Message document written: \(messageId)")
                }
        }
        
        let message = createMessage(
            messageId: messageId,
            senderId: userId,
            message: message,
            attachment: attachment,
            timestamp: timestamp)
        
        if (messages[chatId] == nil) {
            messages[chatId] = [message]
        } else {
            messages[chatId]!.append(message)
            messages[chatId]!.sort {$0.timestamp! > $1.timestamp!}
        }
    }

    /* Called when a chat is modified (new messages), this function will reorder that chatsList
     so that the chat shows up first, and fetch the LATEST message for preview. */
    func reorderChat(chatId: String) {
        let userId = Constants.FIREBASE_USERID!
        let chatDoc = db.collection("user_chats").document(userId)
            .collection("chats").document(chatId)
        var chat = self.chatIdtoChat[chatId]!
        chatDoc.getDocument { (document, error) in
            if let document = document, document.exists {
                let timestamp = document.get("timestamp") as! Date
                let revealed = document.get("revealed") as! Bool
                
                if (revealed == true) {
                    let participant1 = document.get("participant1_uid") as! String
                    
                    var recipientName:String? = nil
                    var recipientImagePath:String? = nil
                    var recipientImage:UIImage? = nil
                    
                    if (participant1 == userId) {
                        recipientName = document.get("participant2_name") as? String
                        recipientImagePath = document.get("participant2_image") as? String
                        recipientImage = cloudutil.downloadImage(ref: recipientImagePath!)
                    } else {
                        recipientName = document.get("participant1_name") as? String
                        recipientImagePath = document.get("participant1_image") as? String
                        recipientImage = cloudutil.downloadImage(ref: recipientImagePath!)
                    }
                    
                    chat.recipientImage = recipientImage
                    chat.recipientName = recipientName
                    chat.recipientImageName = recipientImagePath
                    chat.revealed = true
                }
                self.fetchPreviewMessage(chatId: chatId)
                chat.lastMessageSent = timestamp
                self.chatsList.sort {$0.lastMessageSent! > $1.lastMessageSent!}
                // TODO: tell chat list vc to refresh
            } else {
                print("Chat document \(chatId) does not exist.")
            }
        }
    }
    
    /*
     when a new chat is added:
     1. add to list and create mappings
     2. load ONE message for preview
     NOTE: this differs from addNewChat in that this will only be called
     when a user signs in and need to reconstruct instances OR a brand new chat is added
     */
    func addNewChat(chatId: String)
    {
        let userId = Constants.FIREBASE_USERID!
        let chatDoc = db.collection("chats").document(chatId)
        
        // this is lowkey embarrassing and will be cleaned up at a future date
        chatDoc.getDocument { (document, error) in
            if let document = document, document.exists {
                let postId = document.get("post_uid") as! String
                let revealed = document.get("revealed") as! Bool
                let timestamp = document.get("timestamp") as! Date
                
                let participant1 = document.get("participant1_uid") as! String
                let participant2 = document.get("participant2_uid") as! String
                
                var recipientId:String? = nil
                var recipientName:String? = nil
                var recipientImagePath:String? = nil
                var recipientImage:UIImage? = nil
                
                if (participant1 == userId) {
                    recipientId = participant2
                    recipientName = document.get("participant2_name") as? String
                    recipientImagePath = document.get("participant2_image") as? String
                    recipientImage = cloudutil.downloadImage(ref: recipientImagePath!)
                } else {
                    recipientId = participant1
                    recipientName = document.get("participant1_name") as? String
                    recipientImagePath = document.get("participant1_image") as? String
                    recipientImage = cloudutil.downloadImage(ref: recipientImagePath!)
                }
                
                let chat = self.createChat(
                    postId: postId,
                    chatId: chatId,
                    recipientImage: recipientImage,
                    recipientImageName: recipientImagePath,
                    recipientUserId: recipientId,
                    recipientName: recipientName,
                    revealed: revealed,
                    lastMessageSent: timestamp)
                
                self.chatsList.append(chat)
                self.chatsList.sort {$0.lastMessageSent! > $1.lastMessageSent!}
                
                // update other local data
                self.postToChat[postId] = chatId
                self.chatIdtoChat[chatId] = chat
                
                self.fetchPreviewMessage(chatId: chatId)
            } else {
                print("Chat document \(chatId) does not exist.")
            }
        }
    }
    
    /* Helper to load ONE message for preview purposes when loading the chats list.
     Also used to help set the cursor for pagination*/
    func fetchPreviewMessage(chatId: String) {
        let messageCol = db.collection("chats").document(chatId)
            .collection("messages")
        
        let lastMessage = messageCol.order(by: "timestamp").limit(to: 1)
        
        lastMessage.getDocuments() { (snapshot, err) in
            guard let snapshot = snapshot else {
                print("Error retreving last message for \(chatId): \(err.debugDescription)")
                return
            }
            
            for document in snapshot.documents {
                let senderId = document.get("sender_UID") as! String
                let message = document.get("message") as! String
                let attachmentPath = document.get("attachment") as! String
                let timestamp = document.get("timestamp") as! Date
                
                let attachmentImage:UIImage? = cloudutil.downloadImage(ref: attachmentPath)
                
                let messageStruct = self.createMessage(
                    messageId: document.documentID,
                    senderId: senderId,
                    message: message,
                    attachment: attachmentImage,
                    timestamp: timestamp)
                

                if (self.messages[chatId] == nil) {
                    self.messages[chatId] = [messageStruct]
                } else if (self.messages[chatId]!.contains(where: {$0.messageId == document.documentID})){
                    self.messages[chatId]!.append(messageStruct)
                    self.messages[chatId]!.sort {$0.timestamp! > $1.timestamp!}
                }
            }
            self.chatCursor[chatId] = snapshot
            
            // TODO: tell chat list vc to refresh, since we have loaded all data needed
        }
    }
    
    /* Fetches a BATCH of chat after scrolling up */
    func fetchMessages(chatId: String) {
        let snapshot = chatCursor[chatId]
        guard let lastSnapshot = snapshot!?.documents.last else {
            return
        }
        let next = db.collection("chats").document(chatId).collection("message")
            .order(by: "timestamp", descending: true)
            .limit(to: chatBatchSize)
            .start(afterDocument: lastSnapshot)
        next.getDocuments() { (snapshot, err) in
            guard let snapshot = snapshot else {
                print("Error retreving messages for \(chatId): \(err.debugDescription)")
                return
            }
                
            for document in snapshot.documents {
                let senderId = document.get("sender_UID") as! String
                let message = document.get("message") as! String
                let attachmentPath = document.get("attachment") as! String
                let timestamp = document.get("timestamp") as! Date
                
                let attachmentImage:UIImage? = cloudutil.downloadImage(ref: attachmentPath)
                
                let messageStruct = self.createMessage(
                    messageId: document.documentID,
                    senderId: senderId,
                    message: message,
                    attachment: attachmentImage,
                    timestamp: timestamp)
                

                if (self.messages[chatId] == nil) {
                    self.messages[chatId] = [messageStruct]
                } else if (self.messages[chatId]!.contains(where: {$0.messageId == document.documentID})){
                    self.messages[chatId]!.append(messageStruct)
                    self.messages[chatId]!.sort {$0.timestamp! > $1.timestamp!}
                }
            }
            // TODO: notify chat view controller to refresh
        }
        
        next.addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error retreving documents: \(error.debugDescription)")
                return
            }
            self.chatCursor[chatId] = snapshot
        }
    }
    
    /* After accepting AND sending message, reveal the identity.
     Note that since sending message is a requirement, the chat document in user_chat will
     be updated by the message */
    func setRevealTrue(chatId: String) {
        let userId = Constants.FIREBASE_USERID!
        var chat = chatIdtoChat[chatId]!
        let recipientId = chat.recipientUserId!
        let chatDoc = db.collection("chats").document(chatId)
        let recipientDoc = db.collection("users").document(recipientId)
        let timestamp = Date()
        // TODO: find a simpler way to do this
        recipientDoc.getDocument { (document, error) in
            if let document = document, document.exists {
                let recipientName = document.get("username") as! String
                chatDoc.getDocument { (document, error) in
                    if let document = document, document.exists {
                        let participant1 = document.get("participant1_uid") as! String
                        if (participant1 == userId) {
                            chatDoc.updateData(
                                ["participant1_image": "profiles/\(userId)\(Constants.image_extension)",
                                 "participant1_name": Constants.USERNAME!,
                                 "participant2_image": "profiles/\(recipientId)\(Constants.image_extension)",
                                 "participant2_name": recipientName,
                                 "revealed": true,
                                 "timestamp": timestamp])
                        } else {
                            chatDoc.updateData(
                                ["participant1_image": "profiles/\(recipientId)\(Constants.image_extension)",
                                 "participant1_name": recipientName,
                                 "participant2_image": "profiles/\(userId)\(Constants.image_extension)",
                                 "participant2_name": Constants.USERNAME!,
                                 "revealed": true,
                                 "timestamp": timestamp])
                        }
                        // update local chat
                        chat.lastMessageSent = timestamp
                        chat.recipientImage = cloudutil.downloadImage(ref: "profiles/\(recipientId)\(Constants.image_extension)")
                        chat.recipientImageName = "profiles/\(recipientId)\(Constants.image_extension)"
                        chat.recipientName = recipientName
                    } else {
                        print("Chat document \(chatId) does not exist.")
                    }
                }
            }
        }
    }
    
    func createMessage(
        messageId: String,
        senderId: String,
        message: String,
        attachment: UIImage?,
        timestamp: Date) -> Message {
        
        return Message(
            messageId: messageId,
            senderId: senderId,
            message: message,
            attachment: attachment,
            timestamp: timestamp,
            isRead: nil)
    }
    
    func createChat(
        postId: String?,
        chatId: String?,
        recipientImage: UIImage?,
        recipientImageName: String?,
        recipientUserId: String?,
        recipientName: String?,
        revealed: Bool?,
        lastMessageSent: Date?) -> Chat{
        return Chat(
            postId: postId,
            chatId: chatId,
            recipientImage: recipientImage,
            recipientImageName: recipientName,
            recipientUserId: recipientUserId,
            recipientName: recipientUserId,
            revealed: revealed,
            lastMessageSent: lastMessageSent)
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
