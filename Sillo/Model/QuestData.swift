//
//  QuestData.swift
//  Sillo
//
//  Created by William Loo on 3/25/21.
//

import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage

let quests = Quests()

class Quests {
    
    struct Subtask {
        var title: String
        var type: String
        var current: Int
        var target: Int
    }
    //TODO: replaced by firebase fetched data
    var subtasks : [Subtask] = [
        Subtask(title: "Create new posts", type: "newPost", current: 5, target: 5),
        Subtask(title: "Make new connections", type: "newPost", current: 6, target: 6),
        Subtask(title: "Level up in a connection", type: "newPost", current: 2, target: 2),
    ]
    
    var subtaskTitles : [String: String] = [
        "newPost" : "Create a new post!",
        "newConnection" : "Make new connections!",
        "levelUpConnection" : "Level up connections!",
        "replyToPost" : "Reply to a post!"
        
    ]
    
    //TODO: replace this with firebase reference
    var stickerList : [String] = ["coffee", "blush", "donut", "confused", "snooze"]
    var nextSticker = "coffee"
    
    //MARK: reset quest progress
    func resetQuestPopup(){
        //pulls subtask pool, puts local
        let docRef = db.collection("quest_pool").document("subtasks")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var subtasks : [[String: Any]] = document.get("subtaskArray") as! [[String:Any]]
                subtasks = subtasks.shuffled()
                
                for i in 0...2 {
                    let taskType : String = subtasks[i]["subtaskType"] as! String
                    let minTarget : Int = subtasks[i]["minTarget"] as! Int
                    let maxTarget : Int = subtasks[i]["maxTarget"] as! Int
                    let target = Int.random(in: minTarget..<maxTarget)
                    let taskTitle = subtasks[i]["taskTitle"] as! String
                    self.subtasks[i] = Quests.Subtask(title: self.subtaskTitles[taskType] as! String, type: taskType , current: 0, target: target)
                }
            } else {
                print("Was not able to find quest pool, fallback to default subtask.")
            }
        
        //push new quest on firebase (COPY FROM LOCAL TO FIREBASE)
            /*
        let questRef = db.collection("quests").document(Constants.FIREBASE_USERID ?? "USER_ID_ERROR")
        questRef.setData([
            "subtask1": self.subtasks[0].type,
            "subtask2": self.subtasks[1].type,
            "subtask3": self.subtasks[2].type,
            "subtask1_progress" : ["current": 0, "target": self.subtasks[0].target,],
            "subtask2_progress" : ["current": 0, "target": self.subtasks[1].target,],
            "subtask3_progress" : ["current": 0, "target": self.subtasks[2].target,],
        ], merge: true) { err in
            if let err = err {
                print("Error resetting quest: \(err)")
            } else {
                print("Successfully reset quests!")
            }
        }
        */
        //TEMPORARILY SET QUESTS TO ONLY NEW POSTS
        let questRef = db.collection("quests").document(Constants.FIREBASE_USERID ?? "USER_ID_ERROR")
        questRef.setData([
            "subtask1": "newPost",
            "subtask2": "newPost",
            "subtask3": "newPost",
            "subtask1_progress" : ["current": 0, "target": self.subtasks[0].target,],
            "subtask2_progress" : ["current": 0, "target": self.subtasks[1].target,],
            "subtask3_progress" : ["current": 0, "target": self.subtasks[2].target,],
        ], merge: true) { err in
            if let err = err {
                print("Error resetting quest: \(err)")
            } else {
                print("Successfully reset quests!")
            }
        }
    }
    }
    
    //MARK: update quest progress
    func updateQuestProgress(typeToUpdate: String) -> () {
        let docRef = db.collection("quests").document(Constants.FIREBASE_USERID ?? "ERROR")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                for task in ["subtask1", "subtask2", "subtask3"] {
                    let taskType = document.get(task) as! String
                    if taskType == typeToUpdate {
                        let progress = document.get("\(task)_progress") as! [String:Int]
                        let current = progress["current"]!
                        let target = progress["target"]!
                        if current >= target {
                            //account for multiple quests with the same subtask name
                            continue
                        }
                        docRef.setData([
                            "\(task)_progress" : ["current": current + 1, "target": target],
                        ], merge: true) { err in
                            if let err = err {
                                print("Error updating quest progress: \(err)")
                            } else {
                                print("Successfully updated quest progress for subtask type: \(typeToUpdate)!")
                            }
                        }
                        break
                    }
                }
            } else {
                print("Document does not exist, create new quest document")
                quests.resetQuestPopup()
            }
        }
    }
    
    //MARK: update sticker list
    func updateStickerList() {
        let docRef = db.collection("users").document(Constants.FIREBASE_USERID ?? "ERROR")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                var ownedStickers : [String: Bool] = document.get("ownedStickers") as! [String: Bool]
                ownedStickers[self.nextSticker] = true //update sticker list
                docRef.setData([
                    "ownedStickers": ownedStickers
                ], merge: true) { err in
                    if let err = err {
                        print("Error adding new sticker to user's collection: \(err)")
                    } else {
                        print("Successfully added new sticker to user's collection!")
                    }
                }
            } else {
                print("Was not able to find document.")
            }
        }
    }
    
    //MARK: fetch next sticker
    func fetchNextSticker() {
        let docRef = db.collection("users").document(Constants.FIREBASE_USERID ?? "ERROR")
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let ownedStickers : [String: Bool] = document.get("ownedStickers") as! [String: Bool]
                for sticker in quests.stickerList {
                    if !ownedStickers.keys.contains(sticker) {
                        quests.nextSticker = sticker
                        print("next sticker prize for current quest is: \(quests.nextSticker)")
                        break
                    }
                }
            } else {
                print("Was not able to find document.")
            }
        }
    }
    //MARK: coldstart
    func coldStart() {
        updateStickerList()
        fetchNextSticker()
        
        //MARK: attach listener
        let myUserID = Constants.FIREBASE_USERID ?? "ERROR"
        let reference = db.collection("quests").document(myUserID)
        
        reference.getDocument() { (query, err) in
            if query != nil && !query!.exists {
                self.resetQuestPopup()
            }
        }
    }
}
