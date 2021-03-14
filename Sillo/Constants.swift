//
//  Constants.swift
//  Sillo
//
//  Created by Chi Tsai on 1/24/21.
//
import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage

enum Constants {
    static let db = Firestore.firestore()
    static let storage = Storage.storage()
    static let image_extension: String = ".jpeg"

    // MARK: USER DATA
    static var FIREBASE_USERID:String? = nil
    static var USERNAME:String? = nil
    static var EMAIL:String? = nil
}
