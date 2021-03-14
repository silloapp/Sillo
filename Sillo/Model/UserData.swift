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
        guard let userID = Auth.auth().currentUser?.uid else { return }
        Constants.FIREBASE_USERID = userID
    }
}
