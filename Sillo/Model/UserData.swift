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
    
    var invites: [String] = [] //an array of invitations to organizations
    var invitesMapping: [String:String] = [:] //an array mapping invitations to orgaization name
    
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
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.invites.remove(at: self.invites.firstIndex(of: organizationID)!)
            self.invitesMapping[organizationID] = nil
            //delete invite
            db.collection("invites").document(myEmail).updateData(["member":self.invites,"mapping":self.invitesMapping])
        }
        //add organization to user doc
        db.collection("users").document(Constants.FIREBASE_USERID!).getDocument() { (query, err) in
            if let query = query {
                if query.exists {
                    var orgList = query.get("organizations") as! [String]
                    orgList.append(organizationID)
                    db.collection("users").document(Constants.FIREBASE_USERID!).updateData(["organizations":orgList])
                }
            }
        }
        organizationData.addMemberToOrganization(organizationID: organizationID)
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
        if !UserDefaults.standard.bool(forKey: "loggedIn") {
            return
        }
        
        guard let me = Auth.auth().currentUser else {return}
        Constants.me = me
        Constants.EMAIL = me.email
        Constants.USERNAME = me.displayName
        Constants.FIREBASE_USERID = me.uid
        
        db.collection("users").document(Constants.FIREBASE_USERID!).getDocument() { (query, err) in
            if let query = query {
                if query.exists {
                    organizationData.adminStatusMap = query.get("admin") as! [String:Bool]
                    let organizations = query.get("organizations") as! [String]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserReady"), object: nil)
                    organizationData.coldStart(organizations: organizations)
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
    }
}
