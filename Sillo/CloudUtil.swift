//
//  CloudUtil.swift
//  Sillo
//
//  Created by William Loo on 1/7/21.
//

import Firebase
import FirebaseAuth

let cloudutil = CloudUtil()
let db =  Firestore.firestore()

class CloudUtil {
    
    //MARK: Call the generateAuthenticationCode cloud function service
    func generateAuthenticationCode() {
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
    
}


