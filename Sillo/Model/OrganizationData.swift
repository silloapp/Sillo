//
//  OrganizationData.swift
//  Sillo
//
//  Created by Chi Tsai on 1/16/21.
//
import Foundation
import UIKit
import FirebaseFirestore
import FirebaseStorage

var organizationData = OrganizationData()

class OrganizationData {
    // MARK: Current Organization Data
    var currOrganization:String? = nil
    var currOrganizationName:String? = nil
    
    var currOrganizationAdmins:[String?:String] = [:] //only retrieved when getRoster is called
    var currOrganizationMembers:[String?:String] = [:] //only retrieved when getRoster is called

    // MARK: Newly Created Organization Data
    var newOrganizationName:String? = nil
    var newOrganizationPic:UIImage? = nil
    var memberInvites:[String]? = nil

    // MARK: User Organization Data
    var idToName:[String?:String] = [:]
    var orgToImage:[String?:UIImage] = [:]
    var adminStatusMap:[String?:Bool] = [:]
    var organizationList:[String] = [] //for coldstarting only

    // MARK: Creating New Organizations
    func createNewOrganization() {
        let newOrganization = UUID.init().uuidString
        Constants.db.collection("organizations").document(newOrganization).setData(["admins": [Constants.FIREBASE_USERID], "members": [], "organization_name": newOrganizationName!, "image": ""]) { [self] err in
            if let err = err {
                print("error: \(err) org: \(newOrganizationName!) \(newOrganization) not created")
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OrganizationCreationFail"), object: nil)
                return
            } else {
                print("success: created \(newOrganizationName!) \(newOrganization)")
                localUser.addOrganizationtoCurrentUser(organizationID: newOrganization, isAdmin: true) //add organization to user list
                idToName[newOrganization] = newOrganizationName! //update local copy of mapping
                changeOrganization(dest: newOrganization) //switch orgs
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "OrganizationCreationSuccess"), object: nil)
                
                if newOrganizationPic != nil {
                    let imageID = UUID.init().uuidString
                    uploadOrganizationPicReference(organization: newOrganization, imageID: imageID)
                    let orgPicRef = "orgProfiles/\(imageID)\(Constants.image_extension)"
                    cloudutil.uploadImages(image: newOrganizationPic!, ref: orgPicRef)
                }
                inviteMembers(organizationID: newOrganization, organizationName: newOrganizationName!, emails: memberInvites ?? [String]())
                organizationData.memberInvites = []
            }
        }
    }

    // MARK: Changing Organization Data
    func uploadOrganizationPicReference(organization: String, imageID: String) {
        /* THIS IS HANDLED WITH CLOUDUTIL (resizing is done with CLOUDUTIL so it's actually downloadable)
        let imageID = UUID.init().uuidString

        let storageRef = Constants.storage.reference(withPath: "orgProfiles/\(imageID)\(Constants.image_extension)")
        guard let imageData = image!.jpegData(compressionQuality: 0.75) else {return }
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"
        storageRef.putData(imageData, metadata:uploadMetaData)
         */
        let orgDoc = Constants.db.collection("organizations").document(organization)
        orgDoc.getDocument() {
            (query, err) in
            if err != nil {
                print("Error uploading organization picture")
            } else {
                orgDoc.updateData(["image": "\(imageID)"])
                print("Added organization image")
            }
        }
    }

    //MARK: invite members
    func inviteMembers(organizationID:String, organizationName:String, emails:[String]) {
        let col = Constants.db.collection("invites")
        for address in emails {
            let invitesRef = col.document(address).collection("user_invites").document(organizationID)
            invitesRef.setData(["name":organizationName, "isAdmin":false, "timestamp":Date()])
        }
    }

    // MARK: Existing Organization Functions
    func changeOrganization(dest: String?) {
        if currOrganization == dest { return }
        currOrganization = dest
        currOrganizationName = idToName[currOrganization]
        currOrganizationAdmins = [:]
        currOrganizationMembers = [:]
        chatHandler.clearChatData()
    }
    
    // MARK: fast-set default organization when the app just started (DIFFERENCE IS PULLING FROM THE DATABASE, caveat is nsnotification needed)
    func coldChangeOrganization(dest: String?) {
        if currOrganization == dest { return }
        currOrganization = dest
        db.collection("organizations").document(currOrganization!).getDocument() { (query, err) in
            if (query != nil) {
                if query!.exists {
                    let name = query?.get("organization_name") as! String
                    self.currOrganizationName = name
                    self.idToName[dest] = name
                    print("COMPLETE COLD CHANGE")
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "ColdOrgChangeComplete"), object: nil)
                }
            }
        }
        
    }
    //MARK: add member to organization specified by organizationID
    func addMemberToOrganization(organizationID: String) {
        //add user to organization doc
        idToName[organizationID] = newOrganizationName //add to mapping
        
        db.collection("organizations").document(organizationID).getDocument() { (query, err) in
            if let query = query {
                if query.exists {
                    let memberToAdd = Constants.FIREBASE_USERID!
                    db.collection("organizations").document(organizationID).updateData(["members":FieldValue.arrayUnion([memberToAdd])])
                }
            }
        }
    }
    
    //MARK: remove member from current organizationID
    func removeMemberFromCurrentOrganization(userID:String) {
        //sensitive area, verify admin status again
        db.collection("users").document(Constants.FIREBASE_USERID!).getDocument() {(query, err) in
            if query != nil && query!.exists {
                let query = query!
                let mapping = query.get("admin") as! [String:Bool]
                self.adminStatusMap = mapping
                if mapping[self.currOrganization!] == true {
                    if self.currOrganization != nil && self.adminStatusMap[self.currOrganization!]! {
                        //update organization roster
                        db.collection("organizations").document(self.currOrganization!).updateData(["admins":FieldValue.arrayRemove([userID])])
                        db.collection("organizations").document(self.currOrganization!).updateData(["members":FieldValue.arrayRemove([userID])])
                        
                        //update user record
                        db.collection("users").document(userID).getDocument() { (query, err) in
                            if let query = query {
                                if query.exists {
                                    var adminMap = query.get("admin") as! [String:Bool]
                                    adminMap[self.currOrganization!] = nil
                                    db.collection("users").document(userID).updateData(["admin": adminMap, "organizations":FieldValue.arrayRemove([self.currOrganization!])])
                                    NotificationCenter.default.post(name: Notification.Name("finishUserManagementAction"), object: nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: promote member to admin for current organizationID
    func promoteMember(_ userID:String) {
        //sensitive area, verify admin status again
        db.collection("users").document(Constants.FIREBASE_USERID!).getDocument() {(query, err) in
            if query != nil && query!.exists {
                let query = query!
                let mapping = query.get("admin") as! [String:Bool]
                self.adminStatusMap = mapping
                if mapping[self.currOrganization!] == true {
                    if self.currOrganization != nil && self.adminStatusMap[self.currOrganization!]! && !self.currOrganizationAdmins.keys.contains(userID) {
                        //update organization roster
                        db.collection("organizations").document(self.currOrganization!).updateData(["members":FieldValue.arrayRemove([userID])])
                        db.collection("organizations").document(self.currOrganization!).updateData(["admins":FieldValue.arrayUnion([userID])])
                        
                        //update user record
                        db.collection("users").document(userID).getDocument() { (query, err) in
                            if let query = query {
                                if query.exists {
                                    var adminMap = query.get("admin") as! [String:Bool]
                                    adminMap[self.currOrganization!] = true
                                    db.collection("users").document(userID).updateData(["admin": adminMap])
                                    NotificationCenter.default.post(name: Notification.Name("finishUserManagementAction"), object: nil)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    //MARK: demote member from admin for current organizationID
    func demoteMember(_ userID:String) {
        //sensitive area, verify admin status again
        db.collection("users").document(Constants.FIREBASE_USERID!).getDocument() {(query, err) in
            if query != nil && query!.exists {
                let query = query!
                let mapping = query.get("admin") as! [String:Bool]
                self.adminStatusMap = mapping
                if mapping[self.currOrganization!] == true {
                    if self.currOrganization != nil && self.adminStatusMap[self.currOrganization!]! && self.currOrganizationAdmins.keys.contains(userID) {
                        //update organization roster
                        db.collection("organizations").document(self.currOrganization!).updateData(["admins":FieldValue.arrayRemove([userID])])
                        db.collection("organizations").document(self.currOrganization!).updateData(["members":FieldValue.arrayUnion([userID])])
                        
                        //update user record
                        db.collection("users").document(userID).getDocument() { (query, err) in
                            if let query = query {
                                if query.exists {
                                    var adminMap = query.get("admin") as! [String:Bool]
                                    adminMap[self.currOrganization!] = false
                                    db.collection("users").document(userID).updateData(["admin": adminMap])
                                    NotificationCenter.default.post(name: Notification.Name("finishUserManagementAction"), object: nil)
                                }
                            }
                        }
                    }
                }
            }
            
        }

    }
    
    //MARK: get roster for current organization
    func getRoster() {
        let organizationID = currOrganization ?? "ERROR"
        db.collection("organizations").document(organizationID).getDocument() { (query, err) in
        if let query = query {
            if query.exists {
                //pull roster
                let adminIDs = query.get("admins") as! [String]
                let memberIDs = query.get("members") as! [String]
                
                //do not pull if list of IDs are the same (this will cause mapped names to remain the same until memory is cleared)
                let localAdmins = Array(self.currOrganizationAdmins.keys) as! [String]
                let localMembers = Array(self.currOrganizationMembers.keys) as! [String]
                if adminIDs.sorted() == localAdmins.sorted() && memberIDs.sorted() == localMembers.sorted() {
                    NotificationCenter.default.post(name: Notification.Name("finishLoadingRoster"), object: nil)
                    return
                }
                
                //cold start roster again
                self.currOrganizationAdmins = [:]
                self.currOrganizationMembers = [:]
                
                //pull admin id-name mappings
                for adminID in adminIDs {
                    db.collection("users").document(adminID).getDocument() {(query, err) in
                        if query != nil && query!.exists {
                            let username = query?.get("username") as! String
                            self.currOrganizationAdmins[adminID] = username
                            NotificationCenter.default.post(name: Notification.Name("finishLoadingAdmin"), object: nil)
                        }
                    }
                }
                
                //pull member id-name mappings
                for memberID in memberIDs {
                    db.collection("users").document(memberID).getDocument() {(query, err) in
                        if query != nil && query!.exists {
                            let username = query?.get("username") as! String
                            self.currOrganizationMembers[memberID] = username
                            NotificationCenter.default.post(name: Notification.Name("finishLoadingMember"), object: nil)
                        }
                    }
                }
                NotificationCenter.default.post(name: Notification.Name("finishLoadingRoster"), object: nil)
                }
            }
        }
    }
    
    func coldStart(organizations: [String]) {
        print("COLDSTART ORG DATA")
        for orgID in organizations {
            db.collection("organizations").document(orgID).getDocument() { (query, err) in
                if let query = query {
                    if query.exists {
                        let name = query.get("organization_name") as! String
                        self.idToName[orgID] = name
                        let imageRef = query.get("image") as! String
                        if (imageRef != "") {
                            if let resImage = cloudutil.downloadImage(ref: "orgProfiles/\(imageRef)\(Constants.image_extension)") {
                                self.orgToImage[orgID] = resImage
                            }
                        }
                        else {
                            self.orgToImage[orgID] = UIImage(named: "avatar-2") //default avatar
                        }
                        NotificationCenter.default.post(name: Notification.Name("RefreshOrganizationListing"), object: nil)
                    }
                }
            }
        }
    }
    
    //MARK: Email Format Validation
    func isValidEmail(_ email: String) -> Bool {
        //Under the hood it uses the RFC 5322 reg ex (http://emailregex.com):
        //https://stackoverflow.com/questions/25471114/how-to-validate-an-e-mail-address-in-swift
        
        let emailRegEx = "(?:[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}~-]+(?:\\.[\\p{L}0-9!#$%\\&'*+/=?\\^_`{|}" +
            "~-]+)*|\"(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21\\x23-\\x5b\\x5d-\\" +
            "x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])*\")@(?:(?:[\\p{L}0-9](?:[a-" +
            "z0-9-]*[\\p{L}0-9])?\\.)+[\\p{L}0-9](?:[\\p{L}0-9-]*[\\p{L}0-9])?|\\[(?:(?:25[0-5" +
            "]|2[0-4][0-9]|[01]?[0-9][0-9]?)\\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-" +
            "9][0-9]?|[\\p{L}0-9-]*[\\p{L}0-9]:(?:[\\x01-\\x08\\x0b\\x0c\\x0e-\\x1f\\x21" +
            "-\\x5a\\x53-\\x7f]|\\\\[\\x01-\\x09\\x0b\\x0c\\x0e-\\x7f])+)\\])"

        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func makeEmailArray(input: String){
        memberInvites = input.filter {$0 != " " && $0 != "\n"}.components(separatedBy: ",").filter{isValidEmail($0)}
    }
    
    //adds event to organization activity log
    //currently supported events: newPost, newConnection, levelUpConnection, replyToPost, friendShipped
    func logOrgEvent(eventType: String, userID_A: String, userID_B: String){
        
    }
}

//MARK: sign out, clear organization list and mapping
func organizationSignOut() {
    organizationData = OrganizationData()
}
