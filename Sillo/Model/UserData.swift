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
    
    func coldStart() {
        guard let me = Auth.auth().currentUser else {return}
        guard let userID = Auth.auth().currentUser?.uid else { return }
        Constants.me = me
        Constants.FIREBASE_USERID = userID
    }
}
