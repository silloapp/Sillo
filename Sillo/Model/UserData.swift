//
//  UserData.swift
//  Sillo
//
//  Created by Chi Tsai on 1/17/21.
//

import Firebase
import FirebaseAuth
import Foundation

var localUser = LocalUser()

class LocalUser {
    
    var invites: [String] = [] //an array of invitations to organizations
    var invitesMapping: [String:String] = [:] //an array mapping invitations to orgaization name
    
    // MARK: Creating New User
    func createNewUser(newUser:String) {
        self.setConstants()
        
        let docRef = db.collection("users").document(newUser)

        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                //user document exists, don't do anything
                print("document exists, set organizationList")
                organizationData.organizationList = document.get("organizations") as! [String]
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewUserCreated"), object: nil)
                return
            } else {
                //create user document
                docRef.setData(["admin": NSDictionary(), "organizations": [], "username": Constants.USERNAME ?? ""]) { err in
                if let err = err {
                    print("error: \(err) user: \(newUser) \(newUser) not created")
                } else {
                    print("success: created \(newUser) \(newUser)")
                }
                //log creation of new firebase document
                analytics.log_create_firebase_doc()
            }
            cloudutil.uploadImages(image: UIImage(named:"placeholder profile")!, ref: "profiles/\(newUser)\(Constants.image_extension)")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewUserCreated"), object: nil)
        }
    }
    }
        
    //MARK: update firebase document username
    func updateUserName(name: String) {
        db.collection("users").document(Constants.FIREBASE_USERID!).updateData(["username":name])
    }
    
    //MARK: get invitations from "invites" db
    func getInvites() {
        if !UserDefaults.standard.bool(forKey: "loggedIn") {
            return
        }
        
        let myEmail = Constants.EMAIL ?? ""
        db.collection("invites").document(myEmail).getDocument() { (query, err) in
            if let query = query {
                if query.exists {
                    self.invites = query.get("member") as! [String]
                    self.invitesMapping = query.get("mapping") as! [String:String]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "InvitationsReady"), object: nil)
                    organizationData.idToName.merge(self.invitesMapping, uniquingKeysWith: {(current, _) in current})
                }
            }
        }
    }
    
    //MARK: accept invitation given organizatioNID
    func acceptInvite(organizationID:String) {
        let myEmail = Constants.EMAIL ?? "ERROR"
        if !self.invites.contains(organizationID) {return}
        
        self.invites.remove(at: self.invites.firstIndex(of: organizationID)!)
        
        //this mapping data would be cleared on refresh
        //self.invitesMapping[organizationID] = nil
            
        //delete invite on firebase
        db.collection("invites").document(myEmail).updateData(["member":FieldValue.arrayRemove([organizationID]),"mapping":self.invitesMapping])
        
        addOrganizationtoUser(organizationID: organizationID)
        organizationData.addMemberToOrganization(organizationID: organizationID)
        organizationData.changeOrganization(dest: organizationID)
    }
    
    //MARK: add organization to user doc, AND update local copy of organization list
    func addOrganizationtoUser(organizationID: String) {
        db.collection("users").document(Constants.FIREBASE_USERID!).getDocument() { (query, err) in
            if let query = query {
                if query.exists {
                    organizationData.organizationList.append(organizationID)
                    db.collection("users").document(Constants.FIREBASE_USERID!).updateData(["organizations": FieldValue.arrayUnion([organizationID])])
                }
            }
        }
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
    
    //MARK: set constants without pulling anything
    func setConstants() {
        let me = Auth.auth().currentUser!
        Constants.me = me
        Constants.EMAIL = me.email
        Constants.USERNAME = me.displayName
        Constants.FIREBASE_USERID = me.uid
    }
    
    //MARK: coldstart
    func coldStart() {
        if !UserDefaults.standard.bool(forKey: "loggedIn") {
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserLoadingComplete"), object: nil)
            }
            return
        }
        
        self.setConstants()
        
        db.collection("users").document(Constants.FIREBASE_USERID!).getDocument() { (query, err) in
            if let query = query {
                if query.exists {
                    organizationData.adminStatusMap = query.get("admin") as! [String:Bool]
                    organizationData.organizationList = query.get("organizations") as! [String]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserLoadingComplete"), object: nil)
                    organizationData.coldStart(organizations: organizationData.organizationList) //pull the rest
                    return
                }
                else {
                    //NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserLoadingComplete"), object: nil)
                    return
                }
            }
        }
    }
    
    //MARK: sign out
    func signOut() {
        print("SIGNING OUT")
        let firebaseAuth = Auth.auth()
    do {
      try firebaseAuth.signOut()
    } catch let signOutError as NSError {
      print ("Error signing out: %@", signOutError)
    }
        self.invites = []
        self.invitesMapping = [:]
        UserDefaults.standard.removeObject(forKey: "defaultOrganization")
        UserDefaults.standard.set(false, forKey: "loggedIn")
    }
}
