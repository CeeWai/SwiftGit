//
//  TimeViewController.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 21/5/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import FSCalendar

protocol CanRecieve {
    func passDataBack(data: String)
}

class TimeViewController: UIViewController {

    var delegate: CanRecieve?
    var data = ""
    var userCurrentDate: Date?
    @IBOutlet weak var hiddenView: UIView!
    //@IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var buttonStackView1: UIStackView!
    @IBOutlet weak var buttonStackView2: UIStackView!
    @IBOutlet weak var buttonStackView3: UIStackView!
    @IBOutlet weak var buttonStackView4: UIStackView!
    @IBOutlet weak var buttonStackView5: UIStackView!
    @IBOutlet weak var buttonStackView6: UIStackView!
    @IBOutlet weak var buttonStackView7: UIStackView!
    @IBOutlet weak var buttonStackView8: UIStackView!
    @IBOutlet weak var buttonStackView9: UIStackView!
    @IBOutlet weak var buttonStackView10: UIStackView!
    @IBOutlet weak var buttonStackView11: UIStackView!
    @IBOutlet weak var buttonStackView12: UIStackView!
    @IBOutlet weak var buttonStackView13: UIStackView!


    @IBOutlet weak var contentView: UIView!
    var myButtonArray: [String] = []
    var myButtonArray2: [String] = []
    var stack1Count = 0
    var stack2Count = 0
    var stack3Count = 0
    var stack4Count = 0
    var stack5Count = 0
    var stack6Count = 0
    var stack7Count = 0
    var stack8Count = 0
    var stack9Count = 0
    var stack10Count = 0
    var stack11Count = 0
    var stack12Count = 0
    var stack13Count = 0

    var myButtonTestArray: [String] = ["1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM"]
    @IBOutlet weak var titleCardLabel: UILabel!
    override func viewDidLoad() {
        print("userCurrentDate: \(self.userCurrentDate)")
        stack1Count = 0
        stack2Count = 0
        stack3Count = 0
        stack4Count = 0
        stack5Count = 0
        stack6Count = 0
        stack7Count = 0
        stack8Count = 0
        stack9Count = 0
        stack10Count = 0
        stack11Count = 0
        stack12Count = 0
        stack13Count = 0

        super.viewDidLoad()
        
        setTimeButtonArray()
        DataManager.loadTasks { fullUserTaskList in
            var todayTask: [Task] = []
            let currentWeekDayFormatter = DateFormatter()
            currentWeekDayFormatter.dateFormat = "EEEE"
            let currentWeekDayString = currentWeekDayFormatter.string(from: self.userCurrentDate!)
            
            for task in fullUserTaskList {
                let weekDayFormatter = DateFormatter()
                weekDayFormatter.dateFormat = "EEEE"
                let weekDayString = weekDayFormatter.string(from: task.taskStartTime)
                //print("\(date) is being compared to task: \(task.taskName): \(task.taskStartTime)")
                if Calendar.current.isDate(self.userCurrentDate!, inSameDayAs: task.taskStartTime) || task.repeatType == "Daily" {
                    print("\(Date()) is the same as \(task.taskStartTime)")
                    todayTask.append(task)
                } else if task.repeatType == "Weekly" && weekDayString == currentWeekDayString && self.userCurrentDate! >= task.taskStartTime{
                    print("Weekdaystring = \(weekDayString), currentweekdaystring = \(currentWeekDayString)")
                    todayTask.append(task)
                }
            }
            
            print(todayTask)
            
            if self.myButtonArray.count == 0 {
                self.hiddenView.isHidden = false
            } else {
                self.hiddenView.isHidden = true
            }
        
            for (index, element) in self.myButtonArray.enumerated() {
                var oneBtn : UIButton {
                    
                    let button = UIButton()
                    button.setTitle(element, for: .normal)
                    button.backgroundColor = UIColor.black
                    button.layer.borderColor = UIColor.black.cgColor
                    button.setTitleColor(UIColor.white, for: .normal)
                    //button.translatesAutoresizingMaskIntoConstraints = false
                    button.contentHorizontalAlignment = .center
                    button.contentVerticalAlignment = .center
                    button.titleLabel?.font = UIFont(name: "Arial", size: 16)
                    button.layer.cornerRadius = 5
                    button.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
                    button.clipsToBounds = true

                    button.tag = index
                    print("element = \(element)")
                    for task in todayTask {
                        let taskStartDate = task.taskStartTime
                        let dateFormatterStart = DateFormatter()
                        dateFormatterStart.dateFormat = "h:mm a"
                        let startDateString = dateFormatterStart.string(from: taskStartDate)
                        let startDate = dateFormatterStart.date(from:startDateString)!
                        
                        let taskEndDate = task.taskEndTime
                        let dateFormatterEnd = DateFormatter()
                        dateFormatterEnd.dateFormat = "h:mm a"
                        let endDateString = dateFormatterEnd.string(from: taskEndDate)
                        let endDate = dateFormatterEnd.date(from:endDateString)!

                        let isoDate = "\(element)"
                        //print("isoDate \(isoDate)")
                        
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "h:mm a"
                        let date = dateFormatter.date(from:isoDate)!
                        
                        //print("date = \(date)")
                        if date == startDate || date == endDate {
                            print("\(date) is equal to \(startDate) or \(endDate)")
                             button.backgroundColor = UIColor.lightGray
                             button.isEnabled = false
                        }
                        
                        if date >= startDate && date <= endDate {
                            print("\(date) is in between \(startDate) and \(endDate)")
                            button.backgroundColor = UIColor.lightGray
                            button.isEnabled = false
                        }
                    }

                    return button
                };()
                
                if self.stack1Count < 4 {
                    self.buttonStackView1.addArrangedSubview(oneBtn)
                    self.stack1Count += 1
                } else if self.stack2Count < 4 {
                    self.buttonStackView2.addArrangedSubview(oneBtn)
                    self.stack2Count += 1
                } else if self.stack3Count < 4 {
                    self.buttonStackView3.addArrangedSubview(oneBtn)
                    self.stack3Count += 1
                } else if self.stack4Count < 4 {
                    self.buttonStackView4.addArrangedSubview(oneBtn)
                    self.stack4Count += 1
                } else if self.stack5Count < 4 {
                    self.buttonStackView5.addArrangedSubview(oneBtn)
                    self.stack5Count += 1
                } else if self.stack6Count < 4 {
                    self.buttonStackView6.addArrangedSubview(oneBtn)
                    self.stack6Count += 1
                } else if self.stack7Count < 4 {
                    self.buttonStackView7.addArrangedSubview(oneBtn)
                    self.stack7Count += 1
                } else if self.stack4Count < 4 {
                    self.buttonStackView7.addArrangedSubview(oneBtn)
                    self.stack7Count += 1
                } else if self.stack8Count < 4 {
                    self.buttonStackView8.addArrangedSubview(oneBtn)
                    self.stack8Count += 1
                } else if self.stack9Count < 4 {
                   self.buttonStackView9.addArrangedSubview(oneBtn)
                   self.stack9Count += 1
               } else if self.stack10Count < 4 {
                   self.buttonStackView10.addArrangedSubview(oneBtn)
                   self.stack10Count += 1
               } else if self.stack11Count < 4 {
                   self.buttonStackView11.addArrangedSubview(oneBtn)
                   self.stack11Count += 1
               } else if self.stack12Count < 4 {
                   self.buttonStackView12.addArrangedSubview(oneBtn)
                   self.stack12Count += 1
               } else if self.stack13Count < 4 {
                   self.buttonStackView13.addArrangedSubview(oneBtn)
                   self.stack13Count += 1
               }
                //print(buttonStackView.frame.height)
            }

        }

    }
    
    @IBAction func buttonAction(sender: UIButton!) {
        var txtTime = ""
        if let text: String = sender.titleLabel!.text {
           txtTime = text
        }
        print("Button tapped with tag \(sender.tag), value \(txtTime)")
        delegate?.passDataBack(data: txtTime)
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func setTimeButtonArray() {
        myButtonArray = []
        let date = Date()
        let calendar = Calendar.current

        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        //print("Hours: \(hour) Minutes: \(minute) Second: \(second)")
        
        let formatter = DateFormatter()
        var newDate = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: date)
        
        formatter.dateFormat = "h:mm a"
        
        if Calendar.current.isDate(Date(), inSameDayAs: self.userCurrentDate!) { //check if the current date is the same as the passed date
            if(minute < 29) {
                newDate = calendar.date(bySettingHour: calendar.component(.hour, from: date), minute: 30, second: 0, of: date)
            } else {
                newDate = calendar.date(bySettingHour: calendar.component(.hour, from: date) + 1, minute: 0, second: 0, of: date)
            }
            if newDate == nil {
                titleCardLabel.isHidden = false
                titleCardLabel.text = "You can't set a last minute task for today!"
                return
            } else {
                titleCardLabel.isHidden = true
            }
            let dateString = formatter.string(from: newDate!)
            print(dateString)
            
            myButtonArray.append(dateString)
            
            var currentDateString = dateString
            while (true) { // add all the timing that are in the same day
                if (currentDateString != "11:30 PM") {
                    newDate = calendar.date(byAdding: .minute, value: 30, to: newDate!)
                    let dateString = formatter.string(from: newDate!)
                    myButtonArray.append(dateString)
                    print("Date string: \(dateString)")
                    currentDateString = dateString
                } else {
                    break
                }
            }
        } else { // the parsed date is different from today
            newDate = calendar.date(bySettingHour: 0, minute: 30, second: 0, of: self.userCurrentDate!)
            let dateString = formatter.string(from: newDate!)
            print(dateString)
            
            myButtonArray.append(dateString)
            
            var currentDateString = dateString
            while (true) {
                if (currentDateString != "11:30 PM") {
                    newDate = calendar.date(byAdding: .minute, value: 30, to: newDate!)
                    let dateString = formatter.string(from: newDate!)
                    myButtonArray.append(dateString)
                    print("Date string: \(dateString)")
                    currentDateString = dateString
                } else {
                    break
                }
            }
        }


    }
    

}
