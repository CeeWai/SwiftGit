//
//  ProjectTask.swift
//  SwiftProj
//
//  Created by Sebastian on 11/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class ProjectTask: NSObject {
        var taskid:Int?
        var projectid: Int?
        var userid :String?
        var taskname: String?
        var taskgoal: String?
        var startdate: Date?
        var enddate: Date?
        var status:Int?
        var valid: Int?
        
         
    init(taskid:Int?, projectid: Int?, userid:String?, taskname: String?,taskgoal:String?, startdate: Date?,enddate: Date?,status:Int?,valid: Int?)
         
    {
        self.taskid = taskid
        self.projectid = projectid
        self.userid = userid
        self.taskname = taskname
        self.taskgoal = taskgoal
        self.startdate = startdate
        self.enddate = enddate
        self.status = status
        self.valid = valid
    }
         
}
