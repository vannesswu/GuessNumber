//
//  FBMessage.swift
//  GuessNumberAPI
//
//  Created by 吳建豪 on 2017/4/14.
//
//

import Foundation
import SwiftyJSON

public class FBMessage {
    var textString: String?
    var sendJson: JSON?
    var id:String?
    init(message: JSON) {
        let senderJson = (message["sender"].dictionaryValue)
        let messageJson = message["message"].dictionaryValue
        self.textString = messageJson["text"]?.string
        self.id = senderJson["id"]?.string
        let idJson  = ["id": (senderJson["id"]?.string)!]
        if let textString = self.textString {
            let textJson: [String:String] = ["text": textString]
            self.sendJson = ["recipient": idJson , "message": textJson ]
        }
    }
}
