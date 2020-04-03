//
//  Activity.swift
//  LoginForm
//
//  Created by Duc on 4/3/20.
//  Copyright © 2020 Duc. All rights reserved.
//

import Foundation

class Activity {
    var id:String?
    var name:String?
    
    init (dic: [String:Any]) {
        self.id = dic["activityID"] as? String
        self.name = dic["name"] as? String
    }
}
