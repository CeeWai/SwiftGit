//
//  ProjectTaskMember.swift
//  SwiftProj
//
//  Created by Sebastian on 11/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class ProjectTaskMember: NSObject {
            var taskgroupid: Int?
            var projectid: Int?
            var taskid : Int?
            var userid: String?
            var username: String?
            var assign: Int?
            var valid: Int?
             
    init(taskgroupid:Int?, projectid: Int, taskid: Int, userid: String?,username:String?,assign:Int?, valid: Int?)
             
        {
            self.taskgroupid = taskgroupid
            self.projectid = projectid
            self.taskid = taskid
            self.userid = userid
            self.username = username
            self.assign = assign
            self.valid = valid
        }
             

    }
