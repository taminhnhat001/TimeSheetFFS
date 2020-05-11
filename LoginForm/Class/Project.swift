//
//  Project.swift
//  LoginForm
//
//  Created by Duc on 3/30/20.
//  Copyright © 2020 Duc. All rights reserved.
//

import Foundation

class Project {
    var id:String?
    var name:String?
    
    init (dic: [String:Any]) {
        self.id = dic["projectID"] as? String
        self.name = dic["name"] as? String
    }
}
