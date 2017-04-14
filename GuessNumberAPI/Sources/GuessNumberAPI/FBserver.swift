//
//  FBserver.swift
//  GuessNumberAPI
//
//  Created by 吳建豪 on 2017/4/14.
//
//

import Foundation

public class FBServer {
    
    static let share = FBServer()
    
    let url = "https://graph.facebook.com/v2.8/me/messages?access_token=" + "EAAGHe1swZAwsBAK4adVUvZCzG74onE5KwIAZCm04ZBSYXen1MgAWZAIEk7g04sWE2eakqtvDOcvZCZCB01uJL5Ev4e6nSBYgOnZAlj9jcZBixRKZB81GMZA5b8fVPNZBkOlyysQ1u8aexuPSEFtsLfSx6W1Mij7hNeFgXnBotuzqP6OPJgZDZD"
    
    func sendMessage(id:String, message:String){
        let sendJson = ["recipient":["id":id],"message":["text":message]]
        let jsonData = try? JSONSerialization.data(withJSONObject: sendJson)
        var urlRequest = URLRequest(url:URL(string: url)! )
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = jsonData
        
        let task = URLSession.shared.dataTask(with: urlRequest ) { (data, response, error) in
        }
        task.resume()
    }
}
