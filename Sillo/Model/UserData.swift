//
//  UserData.swift
//  Sillo
//
//  Created by Chi Tsai on 1/17/21.
//
import Foundation
import FirebaseAuth

var localUser = LocalUser()

class LocalUser {
    
    // MARK: Creating New User
    func createNewUser() {
        let newUser = Constants.FIREBASE_USERID
        
        let docRef = db.collection("users").document(newUser!)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                //user document exists, don't do anything
                print("document exists, do nothing")
                return
            } else {
                //create user document
                docRef.setData(["admin": NSDictionary(), "organizations": [], "username": Constants.USERNAME ?? ""]) { err in
                if let err = err {
                    print("error: \(err) user: \(newUser!) \(newUser ?? "undefined value") not created")
                } else {
                    print("success: created \(newUser!) \(newUser ?? "undefined value")")
                }
                //log creation of new firebase document
                analytics.log_create_firebase_doc()
            }
            cloudutil.uploadImages(image: UIImage(named:"placeholder profile")!, ref: "profiles/\(newUser!)\(Constants.image_extension)")
        }
    }
    }
        
    //MARK: update firebase document username
    func updateUserName(name: String) {
        db.collection("users").document(Constants.FIREBASE_USERID!).updateData(["username":name])
    }
    
    //MARK: upload notification token to user document so we can send them notifications mwahah
    func uploadFCMToken(token: String) {
        //log notifications enabled
        analytics.log_notifications_enabled()
        Constants.db.collection("users").document(Constants.FIREBASE_USERID!).updateData(["FCMToken" : token]) { err in
            if let err = err {
                print("error adding user info with error: \(err.localizedDescription)")
            } else {
                print("successfully added user info")
            }
        }
    }
    
    func coldStart() {
        guard let me = Auth.auth().currentUser else {return}
        Constants.me = me
        Constants.USERNAME = me.displayName
        Constants.FIREBASE_USERID = me.uid
    }
}
