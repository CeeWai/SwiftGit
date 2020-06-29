//
//  CalendarViewController.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 20/5/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import FSCalendar

class CalendarViewController: UIViewController, FSCalendarDelegate, FSCalendarDataSource {
    


    @IBOutlet weak var calendar: FSCalendar!
    var taskList : [Task] = []

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        calendar.dataSource = self
        calendar.delegate = self
        
        /*
        let upSwipe = UISwipeGestureRecognizer(target: self, action: #selector(switchCalendarScopeToWeek(sender:)))
        upSwipe.direction = .up
        view.addGestureRecognizer(upSwipe)
        
        let downSwipe = UISwipeGestureRecognizer(target: self, action: #selector(switchCalendarScopeToMonth(sender:)))
        downSwipe.direction = .down
        view.addGestureRecognizer(downSwipe)
        */
        
        self.calendar.scope = .week
        
        self.calendar.today = nil
        self.calendar.select(Date())
        
    }
    
    @objc func switchCalendarScopeToWeek(sender: UISwipeGestureRecognizer){
        if sender.state == .ended {
            //self.calendar.scope = .week
            //self.calendar.setScope(.week, animated: true)
            //calendar.setScope(.week, animated: true)
            self.calendar.setScope( .week, animated: true)
            print("changed to week")
        
        }
    }
    
    @objc func switchCalendarScopeToMonth(sender: UISwipeGestureRecognizer){
        if sender.state == .ended {
            //self.calendar.scope = .month
            self.calendar.setScope( .month, animated: true)
            print("changed to month")
        
        }
    }
    

}
