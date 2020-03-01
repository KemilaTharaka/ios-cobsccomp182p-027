//
//  Event.swift
//  NIBM EVENTS-AKT-DE-SILVA-COBSCCOMP182P027
//
//  Created by Kemila on 2/28/20.
//  Copyright © 2020 Kemila. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Event {
    var name: String
    var id: String
    var category: String
    var location: String
    var eventDescription: String
    var imageUrl: String
    var timeStamp: Timestamp
    var date: String
    var time: String
    
    init(
        name: String,
        id: String,
        imageUrl: String,
        category: String,
        location: String,
        eventDescription: String,
        date: String,
        time: String,
        timeStamp: Timestamp = Timestamp()
        ) {
        
        self.name = name
        self.category = category
        self.id = id
        self.imageUrl = imageUrl
        self.location = location
        self.eventDescription = eventDescription
        self.date = date
        self.time = time
        self.timeStamp = timeStamp
    }
    
    
    init(data: [String: Any]) {
        
        name = data["name"] as? String ?? ""
        id = data["id"] as? String ?? ""
        category = data["category"] as? String ?? ""
        location = data["location"] as? String ?? ""
        eventDescription = data["eventDescription"] as? String ?? ""
        imageUrl = data["imageUrl"] as? String ?? ""
        timeStamp = data["timeStamp"] as? Timestamp ?? Timestamp()
        date = data["date"] as? String ?? ""
        time = data["time"] as? String ?? ""

    }
    
    static func modelToData(event: Event) -> [String: Any] {
        
        let data : [String: Any] = [
            "name": event.name,
            "id": event.id,
            "imageUrl": event.imageUrl,
            "category": event.category,
            "location": event.location,
            "eventDescription": event.eventDescription,
            "date": event.date,
            "time": event.time,
            "timeStamp": event.timeStamp
        ]
        
        return data
        
    }
    
    
}

extension Event : Equatable {
    
    static func == (lhs: Event, rhs: Event) -> Bool {
        return lhs.id == rhs.id
    }
    
}
