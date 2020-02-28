//
//  Category.swift
//  NIBM EVENTS-AKT DE SILVA-COBSCCOMP182P027
//
//  Created by Kemila on 2/27/20.
//  Copyright © 2020 Kemila. All rights reserved.
//

import Foundation
import FirebaseFirestore

struct Category {
    var name:String
    var id: String
    var imagUrl: String
    var isActive: Bool = true
    var timeStamp: Timestamp
}
