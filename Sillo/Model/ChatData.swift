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
    
    
    //TODO: need a better way of checking postToChat, maybe add it to user_chats?
    var chatMetadata = [String: ChatMetadata]() // a dictionary mapping chatid to chat metadata
    var sortedChatMetadata = [ChatMetadata]() // sorted chatMetadata
    
    var messages: [String: [Message]] = [:] //a dictionary mapping chatid to chat messages
    var postToChat: [String: String] = [:]


    
    //fetches chat info to display in messageListVC: profile pic / alias/ latest msg and timestamp
    
    
    // for new
    func handleNewUserChat(chatID: String, data: [String:Any]) {
        let postID = data["postID"] as! String
        let isRead = data["isRead"] as! Bool
        let isRevealed = data["isRevealed"] as! Bool
        let latestMessageTimestamp = data["latestMessageTimestamp"] as! Timestamp
        let recipient_image = data["recipient_image"] as! String
        let recipient_name = data["recipient_name"] as! String
        let recipient_uid = data["recipient_uid"] as! String
        let timestamp = data["timestamp"] as! Timestamp
        
        let latestMessageDate = Date(timeIntervalSince1970: TimeInterval(latestMessageTimestamp.seconds))
        let timestampDate = Date(timeIntervalSince1970: TimeInterval(timestamp.seconds))
        
        //get the latest message for this chat
        //SLOW???
        var latest_message = "Replace this "
        db.collection("chats").document(chatID).collection("messages").order(by: "timestamp", descending: true).limit(to: 1).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            } else {
                let newestMessageDoc = querySnapshot!.documents[0] // THE MESSAGE DOC DOES NOT EXIST YET BU THE TIME USER_CHAT IS UPDATED
                latest_message = newestMessageDoc.get("message") as! String
                
                //wait until this is finished // asynchronous later
                //update chat metadata
                self.chatMetadata[chatID]  = ChatMetadata(chatID: chatID, postID: postID, isRead: isRead, isRevealed: isRevealed, latest_message: latest_message, latestMessageTimestamp: latestMessageDate, recipient_image: recipient_image, recipient_name: recipient_name, recipient_uid: recipient_uid, timestamp: timestampDate)
                
                //update post to chat mapping
                self.postToChat[postID] = chatID
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshMessageListView"), object: nil)
            }
        }
        
        
    }
    
    //MARK: documentlistener reports deleted post
    func handleDeleteUserChat(chatID: String, data: [String:Any]) {
        let postID = data["postID"] as! String
        
        //update chat metadata
        self.chatMetadata.removeValue(forKey: chatID)
        
        //upadte post to chat mapping
        self.postToChat.removeValue(forKey: postID)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshMessageListView"), object: nil)
    }
    

    
    //NOTES: only two public functions, you're either creating a new chat (ADD), or replying to an already existing one(UPDATE)
    
    //creates a new chat document with mesages
    //adds to user_chats
    func addChat(post: Post, message: String, attachment: UIImage?, chatId: String) {
        let userID = Constants.FIREBASE_USERID ?? "ERROR FETCHING USER ID"
        let messageStruct = createMessage(
            senderID: userID,
            message: message,
            attachment: attachment,
            timestamp: Date())
        
        createChatDocument(chatId: chatId, post: post, message: messageStruct)
        addUserChats(chatId: chatId, post: post)
    }
    
    
    //Sends a message in an existing conversation, updates user_chats for both parties
    func sendMessage(chatId: String, message: String, attachment: UIImage?, recipientID: String) {
        let messageSubCol = db.collection("chats").document(chatId).collection("messages")
        
        //MARK: add message document to chat
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
        
        //update user_chat for sender and for recipient
        let userID = Constants.FIREBASE_USERID!
        print("recipientID is ", recipientID)
        updateUserChats(senderID: userID, recipientID: recipientID, chatId: chatId)
    }
    
    
    // user only reads chat, marks own user_chats to show isRead = true
    func readChat(userID: String, chatId: String) {
        
        //MARK: update user_chat for user
        let myChatDoc = db.collection("user_chats").document(userID)
            .collection("chats").document(chatId)
       
        myChatDoc.getDocument() { (query, err) in
            if let query = query {
                if query.exists {
                    myChatDoc.updateData([
                        "isRead": true,
                    ])
                    print("marked conversation \(chatId) as read.")
                }
            }
        }
    }
        
    
    
    
    /////// HELPER FUNCTIONS FOR CHAT BELOW //////////////////////////////
    
    
    //adds chat to user_chat for both parties
    private func addUserChats(chatId: String, post: Post) {
        let userID = Constants.FIREBASE_USERID ?? "ERROR FETCHING USER ID"
        
        //MARK: create user_chat for sender
        let senderChatDoc = db.collection("user_chats").document(userID)
            .collection("chats").document(chatId)
        senderChatDoc.setData([
            "postID" : post.postID,
            "recipient_uid": post.posterUserID!,
            "recipient_name" : post.posterAlias!,
            "recipient_image": post.posterImageName!,
            "latestMessageTimestamp": Date(),
            "isRevealed": false,
            "isRead" : true,
            "timestamp": Timestamp.init(date: Date())
            
        ]){ err in
            if err != nil {
                print("Error adding to user_chat: \(chatId)")
            } else {
                print("User_chat written: \(chatId)")
            }
        }
       
       
        //MARK: create user_chat for recipient
        let recipientChatDoc = db.collection("user_chats").document(post.posterUserID!)
            .collection("chats").document(chatId)
        recipientChatDoc.setData([
            "postID" : post.postID,
            "recipient_uid": userID,
            "recipient_name" : generateAlias(),
            "recipient_image": generateImageName(),
            "latestMessageTimestamp": Date(),
            "isRevealed": false,
            "isRead" : false,
            "timestamp": Timestamp.init(date: Date())
        ]){ err in
            if err != nil {
                print("Error adding to user_chat: \(chatId)")
            } else {
                print("User_chat written:  \(chatId)")
            }
        }
    }
            
    // updates chat in user_chats for both parties (latest msg time etc)
    private func updateUserChats(senderID: String, recipientID: String, chatId: String) {
        
        //MARK: update user_chat for sender
        let senderChatDoc = db.collection("user_chats").document(senderID)
            .collection("chats").document(chatId)
       
        senderChatDoc.getDocument() { (query, err) in
            if let query = query {
                if query.exists {
                    senderChatDoc.updateData([
                        "isRead": true,
                        "latestMessageTimestamp": Timestamp.init(date: Date())
                    ])
                }
            }
        }
        
        //MARK: update user_chat for recipient
        let recipientChatDoc = db.collection("user_chats").document(recipientID)
            .collection("chats").document(chatId)
       
        recipientChatDoc.getDocument() { (query, err) in
            if let query = query {
                if query.exists {
                    db.collection("chats").document(chatId).updateData([
                        "isRead": false,
                        "latestMessageTimestamp": Timestamp.init(date: Date())
                    ])
                }
            }
        }

    }
    
    // creates a new chat document
    // includes the post message and first message sent by user
    private func createChatDocument(chatId: String, post: Post, message: Message) {
        
        //MARK: write chat document
        let chatDoc = db.collection("chats").document(chatId)
        chatDoc.setData([
            "postID": post.postID,
            "timestamp" : message.timestamp,
            "latest_message": message.message!
            
        ]){ err in
            if err != nil {
                print("Error sending message: \(chatId)")
            } else {
                print("Message document written: \(chatId)")
            }
        }
        
        let messageSubCol = db.collection("chats").document(chatId)
            .collection("messages")
        
        //MARK: add original post as first message to document
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
        
        //MARK: add reply as message to document
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
    }
    
    
    ////////////////////////////////   UTILITY FUNCTIONS BELOW /////////////////////////////   /////////////////////////////   /////////////////////////////   /////////////////////////////
    
    
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
    
    //MARK: sort by time with recent on top, returns sorted list
    func sortChatMetadata() -> [ChatMetadata] {
        return chatMetadata.values.sorted(by: { $0.latestMessageTimestamp! > $1.latestMessageTimestamp! })
    }
    
    func sortMessages(messages: [Message]) -> [Message] {
        return messages.sorted(by: { $0.timestamp! < $1.timestamp! })
    }
    
    //MARK: sign out helper function, reinstantiate
    func clearChatData() {
        chatHandler = ChatHandler()
    }

}
