import Foundation
import Kitura
import HeliumLogger
import LoggerAPI
import CloudFoundryEnv
import Configuration
import GuessNumberAPI


HeliumLogger.use()

let recording: Recording!

do {
    Log.info("Attempting init with CF environment")
    let service = try getConfig()
    Log.info("Init with Service")
    recording = Recording(service: service)
} catch {
    Log.info("Could not retreive CF env: init with defaults")
    recording = Recording()
}

let controller = GuessNumberController(backend: recording)


do {

    let port =  ConfigurationManager().port
    
    Log.verbose("Assigned port \(port)")
    
    Kitura.addHTTPServer(onPort: port, with: controller.router)
    Kitura.run()
} catch {
    Log.error("Server failed to start!")
}
