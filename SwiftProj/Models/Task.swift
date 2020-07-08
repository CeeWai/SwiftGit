//
//  Task.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 8/5/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class Task: Codable {
    
    var taskID: String
    var taskName: String
    var taskDesc: String
    var taskStartTime: Date
    var taskEndTime: Date
    var repeatType: String
    var taskOwner: String
    //var runtime = 0
    var importance: String
    var subject: String
    
    internal init(taskID: String, taskName: String, taskDesc: String, taskStartTime: Date, taskEndTime: Date, repeatType: String, taskOwner: String, importance: String, subject: String) {
        self.taskID = taskID
        self.taskName = taskName
        self.taskDesc = taskDesc
        self.taskStartTime = taskStartTime
        self.taskEndTime = taskEndTime
        self.repeatType = repeatType
        self.taskOwner = taskOwner
        self.importance = importance
        self.subject = subject
    }
}
 
