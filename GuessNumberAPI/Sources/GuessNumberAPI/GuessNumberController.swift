//
//  GuessNumberController.swift
//  GuessNumberAPI
//
//  Created by 吳建豪 on 2017/4/13.
//
//

import Foundation
import Kitura
import LoggerAPI
import SwiftyJSON

public final class GuessNumberController {
    public let recording:Recording
    public let router = Router()
    public let guessNumberPath = ""
   
    
    public init(backend: Recording) {
        self.recording = backend
        routeSetup()
    }
    
    public func routeSetup() {
        
        router.all("/*", middleware: BodyParser())
        
        // All Recording
        router.get(guessNumberPath, handler: getRecording)
        router.post(guessNumberPath, handler: postRecording)
       
  }
    func getRecording(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        
       let token = request.queryParameters["hub.verify_token"] ?? ""
        
        var fbResponse = "123"
                if let response1 = request.queryParameters["hub.challenge"] {
            fbResponse = response1
        }
        
        if token == "123456" {
            print("send response")
            do {
                try response.status(.OK).send(fbResponse).end()
            }
            catch {
                Log.error("Communications error")
            }
        } else {
            
            do {
                try response.status(.OK).send("invalis token").end()
            }
            catch {
                Log.error("Communications error")
            
          }
        }
     }
    
    func postRecording(request: RouterRequest, response: RouterResponse, next: () -> Void) {
        print("here")
       let url = "https://graph.facebook.com/v2.8/me/messages?access_token=" + "EAAGHe1swZAwsBAK4adVUvZCzG74onE5KwIAZCm04ZBSYXen1MgAWZAIEk7g04sWE2eakqtvDOcvZCZCB01uJL5Ev4e6nSBYgOnZAlj9jcZBixRKZB81GMZA5b8fVPNZBkOlyysQ1u8aexuPSEFtsLfSx6W1Mij7hNeFgXnBotuzqP6OPJgZDZD"
        let body = request.body
        let json = body?.asJSON
        guard let entryArray = (json?["entry"].array) else { return }
        let entry = entryArray[0]
        let messageArray = (entry["messaging"].array)!
        let messageJson = messageArray[0]
        
   //     print(messageJson.description)
        
        let message = FBMessage(message:messageJson)
    //    FBServer.share.sendMessage(id: message.id!, message: "hello")
        if let sendJson = message.sendJson {
            let jsonDict = sendJson.dictionaryObject
            let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict)
            var urlRequest = URLRequest(url: URL(string: url)! )
            urlRequest.httpMethod = "POST"
            urlRequest.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
            urlRequest.httpBody = jsonData
            
            let task = URLSession.shared.dataTask(with: urlRequest ) { (data, response, error) in
            }
            task.resume()
        } else {
            do {
                try response.status(.OK).send(json: JSON(["status":"error"])).end()
            }
            catch {
                Log.error("Communications error")
            }
        }
        do {
            try response.status(.OK).send(json: JSON(["text":"text message"])).end()
        }
        catch {
            Log.error("Communications error")
        }
        
    
     }
}

