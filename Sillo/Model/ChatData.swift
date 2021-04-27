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
    
    var chatSnapshot: QuerySnapshot? = nil //chats list snapshot
    let chatBatchSize = 15 //number of conversations to pull in a batch
    let messagesBatchSize = 15 //number of messages to pull in a batch
    
    //MARK: add more chats
    func getNextBatch() {
        guard let lastSnapshot = self.chatSnapshot!.documents.last else {
            // The collection is empty.
            return
        }
        
        let currentUserID = Constants.FIREBASE_USERID ?? "ERROR"
        let currentOrganization = organizationData.currOrganization ?? "NO_ORG"
        
        let next = db.collection("user_chats").document(currentUserID).collection(currentOrganization).order(by: "latestMessageTimestamp", descending: true).limit(to: chatBatchSize).start(afterDocument: lastSnapshot)
        next.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    self.handleNewUserChat(chatID: document.documentID, data: document.data())
                }
            }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshMessageListView"), object: nil)
        }
        
        //MARK: update snapshot listener
        next.addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error retreving documents: \(error.debugDescription)")
                return
            }
            self.chatSnapshot = snapshot
        }
    }
    
    
    //MARK: coldstart (pull metadata only)
    func coldStart() {
        let currentUserID = Constants.FIREBASE_USERID ?? "ERROR"
        let currentOrganization = organizationData.currOrganization ?? "NO_ORG"
        db.collection("user_chats").document(currentUserID).collection(currentOrganization).order(by: "latestMessageTimestamp", descending: true).limit(to: chatBatchSize).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting chat metadata documents: \(err)")
                return
            } else {
                for document in querySnapshot!.documents {
                    self.handleNewUserChat(chatID: document.documentID, data: document.data())
                }
            }
            self.chatSnapshot = querySnapshot
        }
        
    }
    
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
        
        //fetch the associated post if it's not loaded yet
        if feed.posts[postID] == nil {
            feed.downloadPost(postID: postID)
        }
        
        //get image and shove into cache
        let profilePictureRef = "profiles/\(recipient_uid)\(Constants.image_extension)"
        if (imageCache.object(forKey: profilePictureRef as NSString) == nil) {
            cloudutil.downloadImage(ref: profilePictureRef)
        }
        
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
                
                if isRevealed == true && self.chatMetadata[chatID]?.isRevealed == false { //if reveal changes to true, display the revealVC
                    print("this sohould happen only ONCE")
                    
                    //update quest if newConnection is a subtask
                    quests.updateQuestProgress(typeToUpdate: "newConnection")
                    
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "revealUser"), object: nil)
                }
                
                //wait until this is finished // asynchronous later
                //update chat metadata
                self.chatMetadata[chatID]  = ChatMetadata(chatID: chatID, postID: postID, isRead: isRead, isRevealed: isRevealed, latest_message: latest_message, latestMessageTimestamp: latestMessageDate, recipient_image: recipient_image, recipient_name: recipient_name, recipient_uid: recipient_uid, timestamp: timestampDate)
                self.sortedChatMetadata = self.sortChatMetadata()
                
                //update post to chat mapping
                self.postToChat[postID] = chatID
                
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshMessageListView"), object: nil)
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshChatView"), object: nil)
            }
        }
    }
    
    //MARK: documentlistener reports deleted chat
    func handleDeleteUserChat(chatID: String, data: [String:Any]) {
        let postID = data["postID"] as! String
        
        //update chat metadata
        self.chatMetadata.removeValue(forKey: chatID)
        
        //upadte post to chat mapping
        self.postToChat.removeValue(forKey: postID)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshMessageListView"), object: nil)
    }
    

    
    //NOTES: only three public functions, you're either creating a new chat (ADD), or replying to an already existing one(UPDATE), or reading a message (mark as read), and delete conversation from firebase, AND reveal
    
    //creates a new chat document with mesages
    //adds to user_chats
    func addChat(post: Post, message: String, attachment: UIImage?, chatId: String) {
        
        let userID = Constants.FIREBASE_USERID ?? "ERROR FETCHING USER ID"
        let messageID = UUID.init().uuidString
        let messageStruct = createMessage(messageID: messageID,
            senderID: userID,
            message: message,
            attachment: attachment,
            timestamp: Date())
        
        createChatDocument(chatId: chatId, post: post, message: messageStruct)
        addUserChats(chatId: chatId, post: post)
        
        
        //since addChat is only called on the first reply,
        //update quest if replyToPost is a subtask
        quests.updateQuestProgress(typeToUpdate: "replyToPost")
    }
    
    
    //Sends a message in an existing conversation, updates user_chats for both parties
    func sendMessage(chatId: String, message: String, attachment: UIImage?, recipientID: String) {
        let messageSubCol = db.collection("chats").document(chatId).collection("messages")
        
        //MARK: add message document to chat
        let opMessageId = UUID.init().uuidString
        let opMessageDoc = messageSubCol.document(opMessageId)
        
        //MARK: update latest chat message
        db.collection("chats").document(chatId).updateData(["latest_message":message])
        
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
        updateUserChats(senderID: userID, recipientID: recipientID, chatId: chatId)
        
        //analytics log chat message
        analytics.log_send_chat_message()
    }
    
    
    // user only reads chat, marks own user_chats to show isRead = true
    func readChat(userID: String, chatId: String) {
        
        //MARK: update user_chat for user
        let myChatDoc = db.collection("user_chats").document(userID)
            .collection(organizationData.currOrganization!).document(chatId)
       
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
    
    func revealChat(chatId: String) {
        let userID = Constants.FIREBASE_USERID ?? "ERROR FETCHING MY USER ID"
        let recipientID = chatMetadata[chatId]?.recipient_uid ?? "ERROR FETCHING RECIPIENT USER ID"
        
        db.collection("users").document(recipientID).getDocument() { (query, err) in
            if let query = query {
                if query.exists {
                  
                    let recipientName = query.get("username") as! String
                    
                    //MARK: update user_chat for user
                    let myChatDoc = db.collection("user_chats").document(userID)
                        .collection(organizationData.currOrganization!).document(chatId)
                   
                    //update user's own chat metadata
                    myChatDoc.getDocument() { (query, err) in
                        if let query = query {
                            if query.exists {
                                myChatDoc.updateData([
                                    "isRevealed" : true,
                                    "recipient_img" : "",
                                    "recipient_name" : recipientName
                                ])
                                print("revealed for self.")
                            }
                        }
                    }
        
                } else {
                    print("could not find document")
                }
            }
        }

        
        
        //update other person's chat metadata
        let recipientChatDoc = db.collection("user_chats").document(recipientID).collection(organizationData.currOrganization!).document(chatId)
       
        recipientChatDoc.getDocument() { (query, err) in
            if let query = query {
                if query.exists {
                    recipientChatDoc.updateData([
                        "isRevealed" : true,
                        "recipient_img" : "",
                        "recipient_name" : Constants.USERNAME
                    ])
                    print("revealed for recipient.")
                }
            }
        }
    }
    
    // user  deletes a conversation, we remove chat metadata from user's user_chats
    func deleteConversation(chatID: String, userID: String) {
        
        //MARK: deletes document corresponding to conversation in user_chat for user
        let myChatDoc = db.collection("user_chats").document(userID)
            .collection(organizationData.currOrganization!).document(chatID)
        
        myChatDoc.delete() { err in
            if let err = err {
                print("Error removing chat document: \(err)")
            } else {
                print("Chat document successfully removed!")
            }
        }
    }
        
    /////// HELPER FUNCTIONS FOR CHAT BELOW //////////////////////////////
    
    
    //adds chat to user_chat for both parties
    private func addUserChats(chatId: String, post: Post) {
        let userID = Constants.FIREBASE_USERID ?? "ERROR FETCHING USER ID"
        
        //MARK: create user_chat for sender
        let senderChatDoc = db.collection("user_chats").document(userID)
            .collection(organizationData.currOrganization!).document(chatId)
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
            .collection(organizationData.currOrganization!).document(chatId)
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
        print("UPDATE USER CHAT: \(senderID) -> \(recipientID)")
        //MARK: update user_chat for sender
        let senderChatDoc = db.collection("user_chats").document(senderID)
            .collection(organizationData.currOrganization!).document(chatId)
       
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
            .collection(organizationData.currOrganization!).document(chatId)
       
        recipientChatDoc.getDocument() { (query, err) in
            if let query = query {
                if query.exists {
                    recipientChatDoc.updateData([
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
        return Message(messageID: "", senderID: "", message: nil, attachment: nil, timestamp: nil, isRead: nil)
    }
    
    func createMessage(
        messageID: String,
        senderID: String,
        message: String,
        attachment: UIImage?,
        timestamp: Date) -> Message {
        
        return Message(
            messageID: messageID,
            senderID: senderID,
            message: message,
            attachment: attachment,
            timestamp: timestamp,
            isRead: nil)
    }
    
    func generateAlias() -> String {
        let options: [String] = ["Flamingo", "Reindeer", "T-Rex", "Dragon", "Axolotl", "Manatee", "Unicorn", "Alpaca", "Hummingbird", "Platypus", "Caterpillar", "Butterfly", "Tiger", "Rabbit", "Elephant", "Armadillo", "Kangaroo", "Chicken Turtle", "Albatross", "Barracuda", "Orangutan", "Komodo", "Caribou", "Cassowary", "Chinchilla", "Kookaburra", "Mammoth", "Nightingale", "Porcupine", "Salamander", "Vulture", "Wallaby", "Starling", "Seahorse", "Raven", "Polar Bear", "Arctic Fox", "Kingfisher", "Impala", "Grasshopper", "Gazelle", "Coyote", "Capybara", "Bluebird", "Antelope", "Aardvark", "Banana Slug", "Golden Bear", "Dust Bunny", "Sea Angel", "Sunfish", "Anemone", "Python"]
        
        
        return options.randomElement()!
    }
    
    func generateImageName() -> String {
        let options: [String] = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
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
