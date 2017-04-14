//
//  UserInfo.swift
//  GuessNumberAPI
//
//  Created by 吳建豪 on 2017/4/14.
//
//

import Foundation

typealias JSONDictionary = [String: Any]

protocol DictionaryConvertible {
    func toDict() -> JSONDictionary
}

public struct UserInfo {
    
    let id:String
    let isPlaying:Bool
    let answer:Int
    let number:Int
    
    init(id:String, isPlaying:Bool, answer:Int , number:Int = 0) {
        self.id = id
        self.isPlaying = isPlaying
        self.answer = answer
        self.number = number
    }
}

extension UserInfo: DictionaryConvertible {
    func toDict() -> JSONDictionary {
        var result = JSONDictionary()
        result["id"] = self.id
        result["isPlaying"] = self.isPlaying
        result["answer"] = self.answer
        result["number"] = self.number
        return result
    }
}

extension Array where Element: DictionaryConvertible {
    func toDict() -> [JSONDictionary] {
        return self.map { $0.toDict() }
    }
}
