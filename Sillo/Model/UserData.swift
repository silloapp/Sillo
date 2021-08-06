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
    
    let inviteBatchSize = 10
    var snapshot:QuerySnapshot? = nil
    
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
                docRef.setData(["admin": NSDictionary(), "organizations": [], "username": Constants.USERNAME ?? "", "ownedStickers": NSDictionary(), "email": Constants.EMAIL ?? ""]) { err in
                if let err = err {
                    print("error: \(err) user: \(newUser) \(newUser) not created")
                } else {
                    print("success: created \(newUser) \(newUser)")
                }
                //log creation of new firebase document
                analytics.log_create_firebase_doc()
                if organizationData.currOrganization != nil {
                    let userChatsCol = db.collection("user_chats").document(Constants.FIREBASE_USERID!)
                        .collection(organizationData.currOrganization!)
            
                    userChatsCol.addSnapshotListener {
                        (querySnapshot, err) in
                        guard let documents = querySnapshot?.documents else {
                            print("Error fetching new chat documents. ")
                            return
                        }
                    }
                // TODO : get the chatId name, and call add new Chat
                }
            }
            cloudutil.uploadImages(image: UIImage(named:"avatar-4")!, ref: "profiles/\(newUser)\(Constants.image_extension)")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "NewUserCreated"), object: nil)
                
        }
    }
    }
        
    //MARK: update firebase document username
    func updateUserName(name: String) {
        db.collection("users").document(Constants.FIREBASE_USERID!).updateData(["username":name])
    }
    
    //MARK: handle new invite
    func handleNewInvite(id: String, data: [String:Any]) {
        let orgID = id
        let orgName = data["name"] as! String
        self.invites.append(orgID)
        organizationData.idToName["invite-"+orgID] = orgName
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "InvitationsReady"), object: nil)
    }
    
    //MARK: handle deleted invite
    func handleDeleteInvite(id: String, data: [String:Any]) {
        let orgID = id
        if self.invites.contains(orgID) {
            self.invites.remove(at: self.invites.firstIndex(of: orgID)!)
        }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "InvitationsReady"), object: nil)
    }
    
    //MARK: get next invites through pagination
    func getNextInvites() {
        if self.snapshot == nil {
            return
        }
        guard let lastSnapshot = self.snapshot!.documents.last else {
            // The collection is empty.
            return
        }
        let email = Constants.EMAIL ?? ""
        let next = db.collection("invites").document(email).collection("user_invites").order(by: "timestamp", descending: true).limit(to: inviteBatchSize).start(afterDocument: lastSnapshot)
        next.getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
                return
            } else {
                for document in querySnapshot!.documents {
                    //print("\(document.documentID) => \(document.data())")
                    let organizationID = document.documentID
                    let organizationName = document.get("name") as! String
                    self.invites.append(organizationID)
                    organizationData.idToName[organizationID] = organizationName
                }
            }
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "InvitationsReady"), object: nil)
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
    
    //MARK: accept invitation given organizatioNID
    func acceptInvite(organizationID:String) {
        let myEmail = Constants.EMAIL ?? "ERROR"
        if !self.invites.contains(organizationID) {return}
        
        feed.clearPostData() //clear posts in preparation for switching orgs
        
        //a delay is needed because the invites table briefly refreshes
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            self.invites.remove(at: self.invites.firstIndex(of: organizationID)!)
            organizationData.idToName["invite-"+organizationID] = nil //delete temporary dictionary name mapping for invite
            //delete invite on firebase
            db.collection("invites").document(myEmail).collection("user_invites").document(organizationID).delete() {err in
                if err != nil {
                    print("could not accept invite, invite document not deleted")
                }
                else {
                    //invitation successfully deleted
                    self.addOrganizationtoCurrentUser(organizationID: organizationID, isAdmin: false)
                    organizationData.addMemberToOrganization(organizationID: organizationID)
                    organizationData.coldChangeOrganization(dest: organizationID) //inside this is a notification to segue
                }
            }
        }
    }
    
    //MARK: add organization to user doc, AND update local copy of organization list
    func addOrganizationtoCurrentUser(organizationID: String, isAdmin: Bool) {
        db.collection("users").document(Constants.FIREBASE_USERID!).getDocument() { (query, err) in
            if let query = query {
                if query.exists {
                    organizationData.adminStatusMap = query.get("admin") as! [String:Bool]
                    organizationData.organizationList.append(organizationID)
                    organizationData.adminStatusMap[organizationID] = isAdmin
                    db.collection("users").document(Constants.FIREBASE_USERID!).updateData(["organizations": FieldValue.arrayUnion([organizationID]), "admin": organizationData.adminStatusMap])
                }
            }
        }
    }
    
    //MARK: upload notification token to user document so we can send them notifications mwahah
    func uploadFCMToken(token: String) {
        //log notifications enabled
        if Constants.FIREBASE_USERID != nil {
            Constants.db.collection("users").document(Constants.FIREBASE_USERID!).updateData(["FCMToken" : token]) { err in
                if let err = err {
                    print("error adding user info with error: \(err.localizedDescription)")
                } else {
                    print("successfully added user info")
                }
            }
        }
    }
    //MARK: set user's last active timestamp, last active organization, and sign-in status
    func setLastActiveTimestamp() {
        if Constants.FIREBASE_USERID != nil && organizationData.currOrganization != nil {
            Constants.db.collection("users").document(Constants.FIREBASE_USERID!).updateData(["lastActiveTimestamp": Date(), "lastActiveOrganization": organizationData.currOrganization!, "isSignedIn": true]) { err in
                if let err = err {
                    print("error adding user info with error: \(err.localizedDescription)")
                } else {
                    print("successfully added user info")
                }
            }
        }
    }
    
    //MARK: set user's sign-in status to false
    func setLogoutStatus() {
        if Constants.FIREBASE_USERID != nil {
            Constants.db.collection("users").document(Constants.FIREBASE_USERID!).updateData(["isSignedIn": false]) { err in
                if let err = err {
                    print("error adding user info with error: \(err.localizedDescription)")
                } else {
                    print("successfully added user info")
                }
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
        if Auth.auth().currentUser == nil || !UserDefaults.standard.bool(forKey: "loggedIn") {
            UserDefaults.standard.setValue(false, forKey: "loggedIn")
            DispatchQueue.main.asyncAfter(deadline: .now()+0.1) {
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserLoadingComplete"), object: nil)
            }
            return
        }
        
        self.setConstants()
        
        //get profile image and shove into cache
        let profilePictureRef = "profiles/\(Constants.FIREBASE_USERID!)\(Constants.image_extension)"
        if (imageCache.object(forKey: profilePictureRef as NSString) == nil) {
            cloudutil.downloadImage(ref: profilePictureRef)
        }
        
        db.collection("users").document(Constants.FIREBASE_USERID!).getDocument() { (query, err) in
            if let query = query {
                if query.exists {
                    if query.get("email") == nil {
                        //late addition, so this will upload email to a user document if it doesn't exist.
                        db.collection("users").document(Constants.FIREBASE_USERID!).updateData(["email":Constants.EMAIL!]) //update email
                    }
                    organizationData.adminStatusMap = query.get("admin") as! [String:Bool]
                    organizationData.organizationList = query.get("organizations") as! [String]
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserLoadingComplete"), object: nil)
                    organizationData.coldStart(organizations: organizationData.organizationList) //pull the rest
                    return
                }
                else {
                    //user document not found
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "UserLoadingComplete"), object: nil)
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
        UserDefaults.standard.removeObject(forKey: "defaultOrganization")
        UserDefaults.standard.set(false, forKey: "loggedIn")
        self.setLogoutStatus()
        organizationSignOut()
        clearUserConstants()
        chatHandler.clearChatData()
        feed.clearPostData()
    }
    
    //MARK: delete self
    func deleteUser() {
        print("BYE BYE DELETING USER")
        Constants.me!.delete(completion: nil)
        UserDefaults.standard.removeObject(forKey: "defaultOrganization")
        UserDefaults.standard.set(false, forKey: "loggedIn")
        self.setLogoutStatus()
        chatHandler.clearChatData()
        feed.clearPostData()
        organizationSignOut()
        cloudutil.deleteUser(userID: Constants.FIREBASE_USERID!)
        clearUserConstants()
    }
}

//MARK: sign out helper function, reinstantiate
func clearUserConstants() {
    Constants.USERNAME = nil
    Constants.FIREBASE_USERID = nil
    Constants.EMAIL = nil
    Constants.me = nil
    localUser = LocalUser()
}
