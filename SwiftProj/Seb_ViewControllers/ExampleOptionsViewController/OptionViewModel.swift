//
//  OptionViewModel.swift
//  SwiftProj
//
//  Created by Sebastian on 23/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import JZCalendarWeekView

class ExpandableData {

    var subject: OptionSectionType
    var categories: [Any]?
    lazy var categoriesStr: [String] = getCategoriesInString()
    var isExpanded: Bool = false
    var selectedValue: Any!

    var selectedIndex: Int {
        guard let cate = categories else { fatalError() }
        switch subject {
        case .numOfDays: return cate.firstIndex(where: {$0 as? Int == selectedValue as? Int})!
        case .scrollType: return cate.firstIndex(where: {$0 as? JZScrollType == selectedValue as? JZScrollType})!
        case .firstDayOfWeek: return cate.firstIndex(where: {$0 as? DayOfWeek == selectedValue as? DayOfWeek})!
        case .hourGridDivision: return cate.firstIndex(where: {$0 as? JZHourGridDivision == selectedValue as? JZHourGridDivision})!
        default:
            return 0
        }
    }

    init(subject: OptionSectionType, categories: [Any]?=nil) {
        self.subject = subject
        self.categories = categories
    }

    func getCategoriesInString() -> [String] {
        guard let cate = categories else { return [] }
        switch subject {
        case .numOfDays: return cate.map { ($0 as? Int)?.description ?? "" }
        case .scrollType: return cate.map { ($0 as? JZScrollType)?.displayText ?? "" }
        case .firstDayOfWeek: return cate.map { ($0 as? DayOfWeek)?.dayName ?? "" }
        case .hourGridDivision: return cate.map { ($0 as? JZHourGridDivision)?.displayText ?? "" }
        default:
            return []
        }
    }
}

enum ViewType: String {
    case defaultView = "Default JZBaseWeekView"
    case customView = "Custom JZBaseWeekView"
    case longPressView = "JZLongPressWeekView"
}

enum OptionSectionType: String {
    case currentDate = "Current Date"
    case numOfDays = "Number Of Days"
    case scrollType = "Scroll Type"
    case firstDayOfWeek = "First Day Of Week"
    case hourGridDivision = "Hour Grid Division"
    case scrollableRangeStart = "Scrollable Range Start Date"
    case scrollableRangeEnd = "Scrollable Range End Date"
}

struct OptionsSelectedData {

    var date: Date
    var numOfDays: Int
    var scrollType: JZScrollType
    var firstDayOfWeek: DayOfWeek?
    var hourGridDivision: JZHourGridDivision
    var scrollableRange: (startDate: Date?, endDate: Date?)

    init(date: Date, numOfDays: Int, scrollType: JZScrollType, firstDayOfWeek: DayOfWeek?, hourGridDivision: JZHourGridDivision, scrollableRange: (Date?, Date?)) {
        self.date = date
        self.numOfDays = numOfDays
        self.scrollType = scrollType
        self.firstDayOfWeek = firstDayOfWeek
        self.hourGridDivision = hourGridDivision
        self.scrollableRange = scrollableRange
    }
}

class OptionsViewModel: NSObject {

    let dateFormatter = DateFormatter()
    var optionsData: [ExpandableData] = {
        let hourDivisionCategories: [JZHourGridDivision] = [.noneDiv, .minutes_5, .minutes_10, .minutes_15, .minutes_20, .minutes_30]
        return [
            ExpandableData(subject: .currentDate),
            ExpandableData(subject: .numOfDays, categories: Array(1...10)),
            ExpandableData(subject: .scrollType, categories: [JZScrollType.pageScroll, JZScrollType.sectionScroll]),
            ExpandableData(subject: .hourGridDivision, categories: hourDivisionCategories),
            ExpandableData(subject: .scrollableRangeStart),
            ExpandableData(subject: .scrollableRangeEnd)
        ]
    }()
    let perviousSelectedData: OptionsSelectedData

    init(selectedData: OptionsSelectedData) {
        self.perviousSelectedData = selectedData
        super.init()

        optionsData[0].selectedValue = selectedData.date
        optionsData[1].selectedValue = selectedData.numOfDays
        optionsData[2].selectedValue = selectedData.scrollType
        optionsData[3].selectedValue = selectedData.hourGridDivision
        optionsData[4].selectedValue = selectedData.scrollableRange.startDate
        optionsData[5].selectedValue = selectedData.scrollableRange.endDate
        if let selectedDayOfWeek = selectedData.firstDayOfWeek {
            self.insertDayOfWeekToData(firstDayOfWeek: selectedDayOfWeek)
        }
        dateFormatter.dateFormat = "YYYY-MM-dd"
    }

    func getHeaderViewSubtitle(_ section: Int) -> String {
        let data = optionsData[section]
        var subtitle: String?

        switch data.subject {
        case .currentDate:
            if let date = data.selectedValue as? Date {
                subtitle = dateFormatter.string(from: date)
            }
        case .numOfDays:
            subtitle = (data.selectedValue as? Int)?.description
        case .scrollType:
            subtitle = (data.selectedValue! as? JZScrollType)?.displayText
        case .firstDayOfWeek:
            subtitle = (data.selectedValue! as? DayOfWeek)?.dayName
        case .hourGridDivision:
            subtitle = (data.selectedValue! as? JZHourGridDivision)?.displayText
        case .scrollableRangeStart:
            subtitle = (getScrollableRangeSubTitle(data.selectedValue as? Date))
        case .scrollableRangeEnd:
            subtitle = (getScrollableRangeSubTitle(data.selectedValue as? Date))
        }
        return subtitle ?? ""
    }

    func getScrollableRangeSubTitle(_ date: Date?) -> String {
        var str = "nil"
        if let date = date {
            str = dateFormatter.string(from: date)
        }
        return str
    }

    func insertDayOfWeekToData(firstDayOfWeek: DayOfWeek) {
        let dayOfWeekData = ExpandableData(subject: .firstDayOfWeek, categories: DayOfWeek.dayOfWeekList)
        dayOfWeekData.selectedValue = firstDayOfWeek
        optionsData.insert(dayOfWeekData, at: 3)
    }

    func removeDayOfWeekInData() {
        if optionsData[2].subject == .firstDayOfWeek {
            optionsData.remove(at: 3)
        }
    }
}
