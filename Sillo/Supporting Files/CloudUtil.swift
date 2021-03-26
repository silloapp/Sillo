//
//  CloudUtil.swift
//  Sillo
//
//  Created by William Loo on 1/7/21.
//

import Firebase
import FirebaseAuth
import FirebaseFirestore
import FirebaseStorage

let cloudutil = CloudUtil()
let db =  Firestore.firestore()
let storage = Storage.storage()
let storageRef = storage.reference()

let imageCache = NSCache<NSString, UIImage>() //cache for images (key is the firebase path [ex: profiles/image.png) 

class CloudUtil {
    
    //MARK: Call the generateAuthenticationCode cloud function service
    func generateAuthenticationCode() {
        //log sending of Authentication Code
        analytics.log_passcode_verification_request()
        guard let url = URL(string: "https://us-central1-anonymous-d1615.cloudfunctions.net/generateAuthenticationCode") else {return}
        var request = URLRequest(url: url)
        let userID : String = Auth.auth().currentUser!.uid
        let payload = "{\"userID\": \"\(userID)\"}".data(using: .utf8)
        
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = payload
        
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard error == nil else { print(error!.localizedDescription); return }
            guard let data = data else { print("Empty data");return }

            if let str = String(data: data, encoding: .utf8) {
                print(str)
            }
        }.resume()
    }
    
    func uploadImages(image: UIImage, ref: String, dimension: CGFloat? = 300) {
        // Data in memory
        var croppedImage = image
        let dim = dimension! //force unwrap the dimension value since it's guaranteed
        
        //resize if necessary
        if (image.size.width > dim && image.size.height > dim) {
            croppedImage = image.resized(withPercentage: dim / image.size.width) ?? image
        }
        
        //shove into cache
        imageCache.setObject(croppedImage, forKey: ref as NSString)
        
        //upload
        let storageRef = Constants.storage.reference(withPath: ref)
        guard let imageData = croppedImage.jpegData(compressionQuality: 1.0) else {return }
        let uploadMetaData = StorageMetadata.init()
        uploadMetaData.contentType = "image/jpeg"
        storageRef.putData(imageData, metadata:uploadMetaData)
        return
    }
    //MARK: download image
    //USAGE: call and then check for "refreshPicture" callback, currently returns a placeholder
    func downloadImage(ref: String, useCache: Bool? = true) -> UIImage? {
        var resultImage = UIImage(named:"avatar-4")!
        /* fk the cache doesn't work.. 
        if useCache! == true && imageCache.object(forKey: ref as NSString) != nil {
            if let cachedVersion = imageCache.object(forKey: ref as NSString) {
                // use the cached version
                print("using cached version of image with key \(ref)")
                imageCache.setObject(cachedVersion, forKey: ref as NSString)
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "refreshPicture")))
            }
        }
        else {
            */
            // create it from scratch then store in the cache
            let imageRef = storageRef.child(ref)
            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            imageRef.getData(maxSize: 1*1024*1024) { data, error in
              if let error = error {
                // Uh-oh, an error occurred!
                print(error.localizedDescription)
                return
              } else {
                print("image success")
                resultImage = UIImage(data: data!)!
                imageCache.setObject(resultImage, forKey: ref as NSString)
                NotificationCenter.default.post(Notification(name: Notification.Name(rawValue: "refreshPicture")))
              }
            }
        //}
        return resultImage
    }
}

//https://stackoverflow.com/questions/29137488/how-do-i-resize-the-uiimage-to-reduce-upload-image-size
extension UIImage {
    func resized(withPercentage percentage: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: size.width * percentage, height: size.height * percentage)
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
    func resized(toWidth width: CGFloat, isOpaque: Bool = true) -> UIImage? {
        let canvas = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        let format = imageRendererFormat
        format.opaque = isOpaque
        return UIGraphicsImageRenderer(size: canvas, format: format).image {
            _ in draw(in: CGRect(origin: .zero, size: canvas))
        }
    }
}


