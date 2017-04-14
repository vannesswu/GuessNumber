// swift-tools-version:3.1

import PackageDescription

let package = Package(
    name: "GuessNumberAPI",
    targets:[
      Target(
          name:"GuessNumberServer",
          dependencies:[.Target(name:"GuessNumberAPI")]
    ),
      Target(
        name:"GuessNumberAPI"
      )
   ],
   dependencies:[
    .Package(url: "https://github.com/IBM-Swift/Kitura.git", majorVersion: 1, minor: 7),
    .Package(url: "https://github.com/IBM-Swift/Kitura-CouchDB.git", majorVersion: 1, minor: 7),
    .Package(url: "https://github.com/IBM-Swift/Swift-cfenv.git", majorVersion: 4, minor: 0),
    .Package(url: "https://github.com/Alamofire/Alamofire.git", majorVersion: 4, minor: 4),
]

)
