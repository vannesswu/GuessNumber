//
//  Config.swift
//  GuessNumberAPI
//
//  Created by 吳建豪 on 2017/4/13.
//
//

import Foundation
import LoggerAPI
import CouchDB
import Configuration
import CloudFoundryEnv

struct ConfigError: LocalizedError {
    var errorDescription: String? {
        return "Could not retreive config info"
    }
}

func getConfig() throws -> Service {
    
    let configManager = ConfigurationManager()
    
    do {
        Log.warning("Attempting to retreive CF Env")
     //   appEnv = try configManager.getServices()
        
        let services = configManager.getServices()
        let servicePair = services.filter { element in element.value.label == "cloudantNoSQLDB" }.first
        guard let service = servicePair?.value else {
            throw ConfigError()
        }
        return service
    } catch {
        Log.warning("An error occurred while trying to retreive configs")
        throw ConfigError()
    }
}
