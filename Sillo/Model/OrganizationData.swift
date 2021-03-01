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
        inviteMembers(organization: newOrganization, emails: memberInvites ?? [String]())
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

    func inviteMembers(organization:String, emails:[String]) {
        let col = Constants.db.collection("invites")
        for address in emails {
            let docRef = col.document(address)
            var member: [String] = []
            docRef.getDocument() { (query, err) in
                if let query = query {
                    if query.exists {
                        if let unwrap_member = query.get("members") {member = unwrap_member as! [String]}
                    }
                    member.append(organization)
                }
                docRef.setData(["member": member], merge: true)
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
    
    func makeEmailArray(input: String){
        memberInvites = input.filter {$0 != " "}.components(separatedBy: ",").filter{$0 != ""}
    }
}
