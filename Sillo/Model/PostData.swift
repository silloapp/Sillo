//
//  PostData.swift
//  Sillo
//
//  Created by William Loo on 3/17/21.
//

import Firebase
import Foundation

let feed = PostHandler()

class PostHandler {
    
    var posts = [String:Post]() //a dictionary
    var sortedPosts = [Post]() //a sorted post
    var snapshot: QuerySnapshot? = nil //post query snapshot
    var postBatchSize = 15 //number of posts to get per "batch"
    //MARK: add more posts
    func getNextBatch() {
        guard let lastSnapshot = self.snapshot!.documents.last else {
            // The collection is empty.
            return
        }
        let next = db.collection("organization_posts").document(organizationData.currOrganization!).collection("posts").order(by: "timestamp", descending: true).limit(to: postBatchSize).start(afterDocument: lastSnapshot)
        next.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let postID = document.documentID
                    let attachment = document.get("attachment") as! String
                    let postText = document.get("message") as! String
                    let posterUserID = document.get("poster") as! String
                    let posterAlias = document.get("poster_alias") as! String
                    let posterImageName = document.get("poster_image") as! String
                    let timestamp = document.get("timestamp") as! Timestamp
                    let date = Date(timeIntervalSince1970: TimeInterval(timestamp.seconds))
                    self.posts[postID] = self.buildPostStruct(postID: postID, attachment: attachment, postText: postText, poster: posterUserID, posterAlias: posterAlias, posterImageName: posterImageName, date: date)
                }
            }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshPostTableView"), object: nil)
        }
        
        //MARK: update snapshot listener
        next.addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else {
                print("Error retreving documents: \(error.debugDescription)")
                return
            }
            self.snapshot = snapshot
        }
    }
    
    //MARK: add post
    func addPost(attachment:String, postText:String, poster:String, posterAlias:String, posterImageName: String) {
        let organizationID = organizationData.currOrganization ?? "ERROR"
        let postID = UUID.init().uuidString
        let postRef = db.collection("organization_posts").document(organizationID).collection("posts").document(postID)
        postRef.setData(["attachment":attachment,"message":postText,"poster":poster,"poster_alias":posterAlias,"poster_image":posterImageName,"timestamp":Date()]) { err in
            if err != nil {
                print("error adding post \(postID)")
            } else {
                print("successfully added post \(postID)")
            }
        }
        
        //log new post in organization history 
        let userID = Constants.FIREBASE_USERID ?? "ERROR"
        let orgLogData: [String: Any] = [
            "eventType": "newPost",
            "eventDetails":[
            "postID": postID,
            "poster": userID,
            ]
        ]
        
        let orgID = organizationData.currOrganization ?? "ERROR"
        let orgRef = db.collection("organization_activity").document(orgID).collection("activity")
        orgRef.document(Date().description).setData(orgLogData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Successfully logged new post event in org activity!")
            }
        }
        
        //log new post in individual user activity:
        let userLogData: [String: Any] = [
            "eventType": "newPost",
            "eventDetails":[
            "postID": postID,
            "orgID": orgID,
                    ]
        ]
        
        let userRef = db.collection("users").document(userID).collection("activity")
        userRef.document(Date().description).setData(userLogData) { err in
            if let err = err {
                print("Error writing document: \(err)")
            } else {
                print("Successfully logged new post event in user activity!")
            }
        }
    }
    
    //MARK: documentlistener reports new post
    //data looks like: ["poster": cLfvv9UtacPh9isnO9dUAf67oqj2, "timestamp": <FIRTimestamp: seconds=1616036798 nanoseconds=717643022>, "attachment": , "message": Yesnoyes, "poster_image": avatar-3, "poster_alias": Cabbage]
    func handleNewPost(id: String, data: [String:Any]) {
        let postID = id
        let attachment = data["attachment"] as! String
        let postText = data["message"] as! String
        let posterUserID = data["poster"] as! String
        let posterAlias = data["poster_alias"] as! String
        let posterImageName = data["poster_image"] as! String
        let timestamp = data["timestamp"] as! Timestamp
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp.seconds))
        
        self.posts[postID] = self.buildPostStruct(postID: postID, attachment: attachment, postText: postText, poster: posterUserID, posterAlias: posterAlias, posterImageName: posterImageName, date: date)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshPostTableView"), object: nil)
    }
    
    //MARK: documentlistener reports deleted post
    func handleDeletePost(id: String, data: [String:Any]) {
        self.posts.removeValue(forKey: id)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshPostTableView"), object: nil)
    }
    
    //MARK: cold start
    func coldStart() {
        self.posts = [:]
        let organizationID = organizationData.currOrganization ?? "ERROR"
        print("PULLING POSTS FOR \(organizationID)")
        db.collection("organization_posts").document(organizationID).collection("posts").order(by: "timestamp", descending: true).limit(to: postBatchSize).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let postID = document.documentID
                    let attachment = document.get("attachment") as! String
                    let postText = document.get("message") as! String
                    let posterUserID = document.get("poster") as! String
                    let posterAlias = document.get("poster_alias") as! String
                    let posterImageName = document.get("poster_image") as! String
                    let timestamp = document.get("timestamp") as! Timestamp
                    let date = Date(timeIntervalSince1970: TimeInterval(timestamp.seconds))
                    
                    self.posts[postID] = self.buildPostStruct(postID: postID, attachment: attachment, postText: postText, poster: posterUserID, posterAlias: posterAlias, posterImageName: posterImageName, date: date)
                }
            }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshPostTableView"), object: nil)
        }
    }
    
    //MARK: build post struct
    func buildPostStruct(postID: String, attachment:String, postText:String, poster:String, posterAlias:String, posterImageName: String, date: Date) -> Post {
        return Post(postID: postID, attachment: attachment, message: postText, posterUserID: poster, posterAlias: posterAlias, posterImageName: posterImageName, date: date)
    }
    
    //MARK: sort by time with recent on top, returns sorted list
    func sortPosts() -> [Post] {
        return posts.values.sorted(by: { $0.date! > $1.date! })
    }
}
