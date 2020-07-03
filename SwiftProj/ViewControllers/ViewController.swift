//
//  ViewController.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 7/5/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import FSCalendar
import FirebaseAuth

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate, FSCalendarDataSource {

    @IBOutlet weak var breakButton: UIButton!

    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    var taskList : [Task] = []
    
    override func viewDidLoad() {
        //print("print works")
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Make the navigation bar background clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        tableView.layer.cornerRadius = 10;
    
        // temp add date value to the to do listings
        
        // Specify date components
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"

        let datetime = formatter.date(from: "10-05-2020 13:00:00")!

        let formatter2 = DateFormatter()
        formatter2.dateFormat = "dd-MM-yyyy HH:mm:ss"

        let datetime2 = formatter2.date(from: "10-05-2020 15:00:00")!
        
        taskList.append(Task(taskID: "OoWftREGKR4VQU0UNpss", taskName: "CGIS Practical", taskDesc: "Practical at 1PM on May 28", taskStartTime: datetime, taskEndTime: datetime, repeatType: "Never", taskOwner: "ceewai@ceewai.com", importance: "Important"))
        taskList.append(Task(taskID: "EoWftREGKc4VQU0UNpss", taskName: "FAI Tutorial", taskDesc: "Tutorial at 3PM on May 28", taskStartTime: datetime, taskEndTime: datetime, repeatType: "Never", taskOwner: "ceewai@ceewai.com", importance: "Secondary"))
        
        tableView.tableFooterView = UIView()
        //breakButton.layer.cornerRadius = 10
        //breakButton.clipsToBounds = true
        calendar.scope = .week
        self.calendar.today = nil
        self.calendar.select(Date())
        
       let thickness: CGFloat = 1.0
       let bottomBorder = CALayer()
       bottomBorder.frame = CGRect(x:0, y: self.calendarView.frame.size.height - thickness, width: self.calendarView.frame.size.width, height:thickness)
       bottomBorder.backgroundColor = UIColor.lightGray.cgColor
       calendarView.layer.addSublayer(bottomBorder)
        calendarView.layer.shadowColor = UIColor.black.cgColor
       calendarView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        calendarView.layer.shadowOpacity = 0.2
       calendarView.layer.shadowRadius = 4.0
       calendarView.layer.masksToBounds = false
       //calendarView.layer.cornerRadius = 4.0
        
        calendar.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        
        let p = taskList[indexPath.row]
        cell.taskTitleLabel.text = p.taskName
        cell.taskDescLabel.text = p.taskDesc
        //cell.taskRuntimeLabel.text = "\(p.runtime/60) Hrs \(p.runtime%60) Mins"
        if p.importance == "Important" {
            cell.taskTitleLabel.textColor = UIColor.red
        } else {
            cell.taskTitleLabel.textColor = UIColor { tc in
                switch tc.userInterfaceStyle {
                case .dark:
                    return UIColor.white
                default:
                    return UIColor.black
                }
            }

        }
        
        // format for the time to do the task
        let formatDateTime = "h:mm a"
        let taskFormatTime = getFormattedDate(date: p.taskStartTime, format: formatDateTime)
        cell.taskDateTimeLabel.text = taskFormatTime

        let formatDateTimeEnd = "h:mm a"
        let taskFormatTimeEnd = getFormattedDate(date: p.taskEndTime, format: formatDateTime)
        cell.taskEndDateTimeLabel.text = taskFormatTimeEnd

        return cell
    }

    func getFormattedDate(date: Date, format: String) -> String {
            let dateformat = DateFormatter()
            dateformat.dateFormat = format
            return dateformat.string(from: date)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "taskSegue" {
            let detailViewController = segue.destination as! TaskViewController
            
            let myIndexPath = self.tableView.indexPathForSelectedRow
            if myIndexPath != nil {
                let task = taskList[myIndexPath!.section]
                detailViewController.taskItem = task
                print(task.taskName)
            }
        }
    }
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        //print("This Ran")
        loadTaskListFromDate(date: date)
    }
    
    func loadTaskListFromDate(date: Date) {
        self.taskList = []
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM-dd-YYYY h:mm a"
        let string = formatter.string(from: date)
        print("Loading tasks that are set on: \(string)")
        //var userTaskList: [Task] = []
        
        DataManager.loadTasks { fullUserTaskList in
            //userTaskList = fullUserTaskList
            
            for task in fullUserTaskList {
                //print("\(date) is being compared to task: \(task.taskName): \(task.taskStartTime)")
                if Calendar.current.isDate(date, inSameDayAs: task.taskStartTime) {
                    print("\(date) is the same day as \(task.taskStartTime)")
                    self.taskList.append(task)
                }
            }
            
            print(self.taskList)
            self.tableView.reloadData()

        }
    
    }
    
    
    
}

