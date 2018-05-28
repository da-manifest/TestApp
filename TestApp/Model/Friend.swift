//
//  Friend.swift
//  TestApp
//
//  Created by Admin on 26.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation
import SwiftyJSON

final class Friend {
    
    let name: String
    let status: String
    let imageLink: String
    
    init(name: String, status: String, imageLink: String) {
        self.name = name
        self.status = status
        self.imageLink = imageLink
    }
}

final class FriendParser {
    
    static func parse(_ json: JSON) -> Friend {
        let firstName = json["first_name"].stringValue
        let lastName = json["last_name"].stringValue
        let name = "\(firstName) \(lastName)"
        let imageLink = json["photo_200"].stringValue
        let online = json["online"].intValue
        let rawLastSeen = json["last_seen"].dictionaryValue["time"]?.doubleValue ?? 0
        
        let lastSeenDate = Date(timeIntervalSince1970: rawLastSeen)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
        let lastSeen = dateFormatter.string(from: lastSeenDate)
        
        let status: String
        if online == 1 {
            status = "Online"
        } else {
            status = "last seen \(lastSeen)"
        }
        
        return Friend(name: name,
                      status: status,
                      imageLink: imageLink)
    }
    
    static func parseArray(_ jsonArray: [JSON]) -> [Friend] {
        var friendsArray: [Friend] = []
        jsonArray.forEach{ json in
            let friend = parse(json)
            friendsArray.append(friend)
        }
        return friendsArray
    }
}
