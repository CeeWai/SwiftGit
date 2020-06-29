//
//  Task.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 8/5/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class Task: Codable {
    var taskID = ""
    var taskName = ""
    var taskDesc = ""
    var taskStartTime = Date()
    var taskEndTime = Date()
    var repeatType = ""
    var taskOwner = ""
    //var runtime = 0
    
    init(
        id: String,
        name: String,
        description: String,
        startTime: Date,
        taskEndTime: Date,
        repeatType: String,
        taskOwner: String
    )
    {
        self.taskID = id
        self.taskName = name
        self.taskDesc = description
        self.taskStartTime = startTime
        self.taskEndTime = taskEndTime
        self.repeatType = repeatType
        self.taskOwner = taskOwner
    }
}
 
