//
//  Recording.swift
//  GuessNumberAPI
//
//  Created by 吳建豪 on 2017/4/13.
//
//

import Foundation
import SwiftyJSON
import LoggerAPI
import CouchDB
import CloudFoundryEnv

#if os(Linux)
    typealias Valuetype = Any
#else
    typealias Valuetype = AnyObject
#endif

public enum APICollectionError: Error {
    case ParseError
    case AuthError
}

public class Recording {
    static let defaultDBHost = "localhost"
    static let defaultDBPort = UInt16(5984)
    static let defaultDBName = "guessnumberapi"
    static let defaultUsername = "vanness"
    static let defaultPassword = "123456"
    
    let dbName = "guessnumberapi"
    let designName = "guessnumberdesign"
    let connectionProps: ConnectionProperties
    
    
    public init(database: String = Recording.defaultDBName, host: String = Recording.defaultDBHost, port: UInt16 = Recording.defaultDBPort, username: String? = Recording.defaultUsername, password: String? = Recording.defaultPassword) {
        
        let secured = (host == Recording.defaultDBHost) ? false : true
        connectionProps = ConnectionProperties(host: host, port: Int16(port), secured: secured, username: username, password: password)
        setupDb()
    }
    
    public convenience init (service: Service) {
        let host: String
        let username: String?
        let password: String?
        let port: UInt16
        let databaseName: String = "guessnumberapi"
        
        if let credentials = service.credentials, let tempHost = credentials["host"] as? String, let tempUsername = credentials["username"] as? String, let tempPassword = credentials["password"] as? String, let tempPort = credentials["port"] as? Int {
            
            host = tempHost
            username = tempUsername
            password = tempPassword
            port = UInt16(tempPort)
            Log.info("Using CF Service Credentials")
            
        } else {
            
            host = "localhost"
            username = "vanness"
            password = "123456"
            port = UInt16(5984)
            Log.info("Using Service Development Credentials")
        }
        
        self.init(database: databaseName, host: host, port: port, username: username, password: password)
    }
    private func setupDb() {
        let couchClient = CouchDBClient(connectionProperties: self.connectionProps)
        couchClient.dbExists(dbName) { (exists, error) in
            if (exists) {
                Log.info("DB exists")
            } else {
                Log.error("DB does not exist \(error)")
                couchClient.createDB(self.dbName, callback: { (db, error) in
                    if (db != nil) {
                        Log.info("DB created!")
                        self.setupDbDesign(db: db!)
                    } else {
                        Log.error("Unable to create DB \(self.dbName): Error \(error)")
                    }
                })
            }
        }
    }
    private func setupDbDesign(db: Database) {
        let design: [String: Any] = [
            "_id": "_design/foodtruckdesign",
            "views": [
                "all_documents": [
                    "map": "function(doc) { emit(doc._id, [doc._id, doc._rev]); }"
                ],
                "all_user": [
                    "map": "function(doc) { emit(doc._id, [doc._id, doc.name, doc.foodtype, doc.avgcost, doc.latitude, doc.longitude]); }"
                ],
            ]
        ]
        
        db.createDesign(self.designName, document: JSON(design)) { (json, error) in
            if error != nil {
                Log.error("Failed to create design: \(error)")
            } else {
                Log.info("Design created: \(json)")
            }
        }
    }
    public func addUser(id: String, isPlaying: Bool, answer: Int, completion: @escaping (UserInfo?, Error?) -> Void) {
        let json: [String:Any] = [
            "id": id,
            "isPlaying": isPlaying,
            "answer": answer,
            
        ]
        let couchClient = CouchDBClient(connectionProperties: connectionProps)
        let database = couchClient.database(dbName)
        
        database.create(JSON(json)) { (id, rev, doc, err) in
            if let id = id {
                let userinfo = UserInfo(id: id, isPlaying: isPlaying, answer: answer)
                completion(userinfo, nil)
            } else {
                completion(nil, err)
            }
        }
    }

    
    
}
