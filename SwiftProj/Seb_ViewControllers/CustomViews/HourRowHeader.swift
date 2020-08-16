//
//  HourRowHeader.swift
//  SwiftProj
//
//  Created by Sebastian on 23/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import JZCalendarWeekView

/// Custom Supplementary Hour Row Header View (No need to subclass, but **must** register and viewForSupplementaryElementOfKind)
class HourRowHeader: JZRowHeader {

    override func setupBasic() {
        // different dateFormat
        dateFormatter.dateFormat = "HH"
        lblTime.textColor = .orange
        lblTime.font = UIFont.systemFont(ofSize: 12)
    }

}
