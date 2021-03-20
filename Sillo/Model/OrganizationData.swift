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

    // MARK: Newly Created Organization Data
    var newOrganizationName:String? = nil
    var newOrganizationPic:UIImage? = nil
    var memberInvites:[String]? = nil

    // MARK: User Organization Data
    var idToName:[String?:String] = [:]

    // MARK: Creating New Organizations
    func createNewOrganization() {
        let newOrganization = UUID.init().uuidString
        Constants.db.collection("organizations").document(newOrganization).setData(["admins": [Constants.FIREBASE_USERID], "members": [], "org-name": newOrganizationName!, "posts": [], "image": ""]) { [self] err in
            if let err = err {
                print("error: \(err) org: \(newOrganizationName!) \(newOrganization) not created")
            } else {
                print("success: created \(newOrganizationName!) \(newOrganization)")
            }
        }
        idToName[newOrganization] = newOrganizationName
        changeOrganization(dest: newOrganization)
        if newOrganizationPic != nil {
            uploadOrganizationPic(organization: newOrganization, image: newOrganizationPic)
        }
        inviteMembers(organizationID: newOrganization, organizationName: newOrganizationName!, emails: memberInvites ?? [String]())
    }

    // MARK: Changing Organization Data
    func uploadOrganizationPic(organization: String, image: UIImage?) {
        let imageID = UUID.init().uuidString

        let storageRef = Constants.storage.reference(withPath: "images/\(imageID).jpeg")
        guard let imageData = image!.jpegData(compressionQuality: 0.75) else {return }
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"
        storageRef.putData(imageData, metadata:uploadMetaData)

        let orgDoc = Constants.db.collection("organizations").document(organization)
        orgDoc.getDocument() {
            (query, err) in
            if err != nil {
                print("Error uploading organization picture")
            } else {
                orgDoc.updateData(["image": "\(imageID).jpeg"])
                print("Added organization image")
            }
        }
    }

    func inviteMembers(organizationID:String, organizationName:String, emails:[String]) {
        let col = Constants.db.collection("invites")
        for address in emails {
            let docRef = col.document(address)
            var member: [String] = []
            var mapping: [String:String] = [:]
            docRef.getDocument() { (query, err) in
                if let query = query {
                    if query.exists {
                        if let unwrap_member = query.get("members") {member = unwrap_member as! [String]}
                        if let unwrap_mapping = query.get("mapping") {mapping = unwrap_mapping as! [String:String]}
                    }
                    member.append(organizationID)
                    mapping[organizationID] = organizationName
                }
                docRef.setData(["member": member, "mapping":mapping], merge: true)
            }
        }
    }

    // MARK: Existing Organization Functions
    func changeOrganization(dest: String?) {
        if currOrganization == dest { return }
        currOrganization = dest
        currOrganizationName = idToName[currOrganization]

        // TODO: Pull dest organization data and posts
    }
    
    //MARK: Email Format Validation
    func isValidEmail(_ email: String) -> Bool {
        //Behind the hood it uses the RFC 5322 reg ex (http://emailregex.com):
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
        memberInvites = input.filter {$0 != " "}.components(separatedBy: ",").filter{isValidEmail($0)}
    }
}
