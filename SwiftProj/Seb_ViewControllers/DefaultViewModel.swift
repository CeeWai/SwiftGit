//
//  DefaultViewModel.swift
//  SwiftProj
//
//  Created by Sebastian on 23/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class DefaultViewModel: NSObject {

    private let firstDate = Date().add(component: .hour, value: 1)
    private let secondDate = Date().add(component: .day, value: 1)
    private let thirdDate = Date().add(component: .day, value: 2)

    lazy var events = [DefaultEvent(id: "0",taskid: 1,projectid: 1, title: "One", startDate: firstDate, endDate: firstDate.add(component: .day, value: 3), location: "Melbourne", isAllDay: false)]

    lazy var eventsByDate = JZWeekViewHelper.getIntraEventsByDate(originalEvents: events)

    var currentSelectedData: OptionsSelectedData!
}
