//
//  AllDayEvent.swift
//  SwiftProj
//
//  Created by Sebastian on 23/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import JZCalendarWeekView

class AllDayEvent: JZAllDayEvent {

    var location: String
    var title: String
    var taskid: Int
    var projectid: Int
    init(id: String,taskid:Int,projectid:Int, title: String, startDate: Date, endDate: Date, location: String, isAllDay: Bool) {
        self.location = location
        self.title = title
        self.projectid = projectid
        self.taskid = taskid
        // If you want to hav	e you custom uid, you can set the parent class's id with your uid or UUID().uuidString (In this case, we just use the base class id)
        super.init(id:id,startDate: startDate, endDate: endDate, isAllDay: isAllDay)
    }

    override func copy(with zone: NSZone?) -> Any {
        return	 AllDayEvent(id:id,taskid:taskid,projectid:projectid, title: title, startDate: startDate, endDate: endDate, location: location, isAllDay: isAllDay)
    }
}
