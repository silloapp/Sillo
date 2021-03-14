//
//  Constants.swift
//  Sillo
//
//  Created by Chi Tsai on 1/24/21.
//

import AVKit
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



//added 3/14/2021, most may be extraneous
@available(iOS 13.0, *)
var appDele = UIApplication.shared.delegate as! AppDelegate

let google_APIkey = "AIzaSyDAN3bYk_WhiDvW8pHNjlvXsPiwQo-YIFg"
let img_Url = "http://mobidudes.com/Yikooo/"
let base_url = "https://mobidudes.com/Yikooo/api/R1/"


let banner = "banner"
let phone_number_register = "phone_number_register"
let otp_verification = "otp_verification"
let categorylist = "categorylist"
let sizeslist = "sizeslist"
let colorslist = "colorslist"
let brandlist = "brandlist"
let productlist_seeall = "productlist_seeall"
let productlist_filter = "productlist_filter"
let wishlist = "wishlist"
let wishlistdata = "wishlistdata"
let productdetail = "productdetail"
let addreview = "addreview"
let allreview = "allreview"
let addtocart = "addtocart"

let cartdata = "cartdata"
let removetocart = "removetocart"
let order = "order"
let myorders = "myorders"
let trackmyorders = "trackmyorders"
let myprofile = "myprofile"
let updatemyprofile = "updatemyprofile"
let shipping_address = "shipping_address"
let order_total = "order_total"
let updatetocart = "updatetocart"
let addresslist = "addresslist"
let addressdelete = "addressdelete"
let cartcount = "cartcount"
let homepage = "homepage"
let apply_coupon = "apply_coupon"

let sorting = "sorting"
let privacypolicy = "privacypolicy"
let faq = "faq"
let help = "help"


let themeColor = hexStringToUIColor(hex:"#5D83ED")
let themeStsColor = UIColor.init(red: 247/255.0, green: 57/255.0, blue: 57/255.0, alpha: 1)
//let themeBgColor = hexStringToUIColor(hex:"#f7f7f7")
let ViewBgColor = hexStringToUIColor(hex:"#FFFEFA")
let themeBgColor = UIColor.init(red: 242/255.0, green: 244/255.0, blue: 244/255.0, alpha: 1)






func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt32 = 0
    Scanner(string: cString).scanHexInt32(&rgbValue)
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}
