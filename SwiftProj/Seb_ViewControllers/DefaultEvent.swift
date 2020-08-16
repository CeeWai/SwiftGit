//
//  DefaultEvent.swift
//  SwiftProj
//
//  Created by Sebastian on 23/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import Foundation
import JZCalendarWeekView

class DefaultEvent: JZBaseEvent {

    var location: String
    var title: String
    var taskid: Int
    var projectid: Int
    var isAllDay : Bool
    init(id: String,taskid:Int,projectid:Int, title: String, startDate: Date, endDate: Date, location: String, isAllDay: Bool) {
        self.location = location
        self.title = title
        self.projectid = projectid
        self.taskid = taskid
        self.isAllDay = isAllDay
        // If you want to have you custom uid, you can set the parent class's id with your uid or UUID().uuidString (In this case, we just use the base class id)
        super.init(id: id, startDate: startDate, endDate: endDate)
    }

    override func copy(with zone: NSZone?) -> Any {
        return DefaultEvent(id:id,taskid:taskid,projectid:projectid, title: title, startDate: startDate, endDate: endDate, location: location, isAllDay: isAllDay)
    }
}
