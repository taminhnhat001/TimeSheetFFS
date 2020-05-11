//
//  List.swift
//  LoginForm
//
//  Created by Duc on 3/23/20.
//  Copyright © 2020 Duc. All rights reserved.
//

import Foundation

class List {
    var activityName:String?
    var projectName:String?
    var descriptionName:String?
    var durationTime:String?
    var dateMonthYear:String?
    var startTime:String?
    var endTime:String?
    var status:String?
    var duration:Int?
    
    var dateInt:Int? // De filter
    
    init(dic: [String:Any]){
        self.activityName = dic["activityName"] as? String
        self.projectName = dic["projectName"] as? String
        self.descriptionName = dic["description"] as? String
        self.durationTime = dic["formattedDuration"] as? String
        self.status = dic["status"] as? String ?? ""
        self.duration = dic["duration"] as? Int
        
        //Ngay`, Gio` bat dau
        if let StringStartTime:String = dic["start"] as? String {
            self.dateInt = Int(StringStartTime)
            if let timeStartResult:Double = Double(StringStartTime) {
                let dateStart = Date(timeIntervalSince1970: timeStartResult)
                let dateFormatter = DateFormatter()
                let timeStartFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy"
                timeStartFormatter.dateFormat = "HH:mm"
            
                self.dateMonthYear = dateFormatter.string(from: dateStart)
                self.startTime = timeStartFormatter.string(from: dateStart)
            }
        }
        
        //Gio ket thuc
        if let StringEndTime:String = dic["end"] as? String {
            if let timeEndResult:Double = Double(StringEndTime) {
                let dateEnd = Date(timeIntervalSince1970: timeEndResult)
                let timeEndFormatter = DateFormatter()
                timeEndFormatter.dateFormat = "HH:mm"
                
                self.endTime = timeEndFormatter.string(from: dateEnd)
            }
        }
        
    }
}

