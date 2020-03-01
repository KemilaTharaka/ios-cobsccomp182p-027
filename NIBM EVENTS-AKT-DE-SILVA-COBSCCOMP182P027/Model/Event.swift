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
    
}
