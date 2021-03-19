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
    
    //MARK: add post
    func addPost(attachment:String, postText:String, poster:String, posterAlias:String, posterImageName: String) {
        //let organizationID = organizationData.currOrganization!
        let organizationID = "0_TEST_ORGANIZATION_ID" //MARK: DELETE THIS WITH ORGANIZATION IMPLEMENTATION
        let postID = UUID.init().uuidString
        let postRef = db.collection("organization_posts").document(organizationID).collection("posts").document(postID)
        postRef.setData(["attachment":attachment,"message":postText,"poster":poster,"poster_alias":posterAlias,"poster_image":posterImageName,"timestamp":Date()]) { err in
            if err != nil {
                print("error adding post \(postID)")
            } else {
                print("successfully added post \(postID)")
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
        let posterImage = data["poster_image"] as! String
        let timestamp = data["timestamp"] as! Timestamp
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp.seconds))
        
        self.posts[postID] = self.buildPostStruct(postID: postID, attachment: attachment, postText: postText, poster: posterUserID, posterAlias: posterAlias, posterImageName: posterImage, date: date)
        
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshPostTableView"), object: nil)
    }
    
    //MARK: documentlistener reports deleted post
    func handleDeletePost(id: String, data: [String:Any]) {
        self.posts.removeValue(forKey: id)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshPostTableView"), object: nil)
    }
    
    //MARK: cold start
    func coldStart() {
        //let currentOrg = organizationData.currOrganization!
        let organizationID = "0_TEST_ORGANIZATION_ID" //MARK: DELETE THIS WITH ORGANIZATION IMPLEMENTATION
        db.collection("organization_posts").document(organizationID).collection("posts").order(by: "timestamp").limit(to: 15).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let postID = document.documentID
                    let attachment = document.get("attachment") as! String
                    let postText = document.get("message") as! String
                    let posterUserID = document.get("poster") as! String
                    let posterAlias = document.get("poster_alias") as! String
                    let posterImage = document.get("poster_image") as! String
                    let timestamp = document.get("timestamp") as! Timestamp
                    let date = Date(timeIntervalSince1970: TimeInterval(timestamp.seconds))
                    
                    self.posts[postID] = self.buildPostStruct(postID: postID, attachment: attachment, postText: postText, poster: posterUserID, posterAlias: posterAlias, posterImageName: posterImage, date: date)
                }
            }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refreshPostTableView"), object: nil)
        }
    }
    
    //MARK: build post struct
    func buildPostStruct(postID: String, attachment:String, postText:String, poster:String, posterAlias:String, posterImageName: String, date: Date) -> Post {
        return Post(postID: postID, attachment: attachment, message: postText, posterAlias: posterAlias, posterImage: UIImage(named:posterImageName), date: date)
    }
    
    //MARK: sort by time with recent on top, returns sorted list
    func sortPosts() -> [Post] {
        return posts.values.sorted(by: { $0.date! > $1.date! })
    }
}
