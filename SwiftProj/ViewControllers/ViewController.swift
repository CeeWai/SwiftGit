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
import GoogleSignIn

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate, FSCalendarDataSource, CanReceiveReload {
    func passReloadDataBack(data: Date) {
        DispatchQueue.main.async {
            print("passed back reload data")
            self.loadTaskListFromDate(date: data)
        }
    }
    
    @IBOutlet weak var breakButton: UIBarButtonItem!
    @IBOutlet weak var addTaskButton: UIBarButtonItem!
    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var noFilterView: UIView!
    @IBOutlet weak var noFilterLabel: UILabel!
    var taskList : [Task] = []
    var completedTaskList: [Task] = []
    var currentTaskList: [Task] = []
    var upcomingTaskList: [Task] = []
    var userCurrentDate = Date()
    var taskListInAdvance: [Task] = []
    override func viewDidLoad() {
        //print("print works")
        super.viewDidLoad()
        
        if Auth.auth().currentUser == nil { // checks if user is logged in
             DispatchQueue.main.async {
                 let welcViewController = (self.storyboard?.instantiateViewController(identifier: "WelcomeController"))
                 self.view.window?.rootViewController = welcViewController
                 self.present(welcViewController!, animated: true)
             }
         }
    
        // Do any additional setup after loading the view.
        // Make the navigation bar background clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        tableView.layer.cornerRadius = 10;
        
        tableView.tableFooterView = UIView()
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
        calendar.dataSource = self
        tableView.delegate = self
        // instantiate default tasks (today's task)
        loadTaskListFromDate(date: Date())
        //loadTaskInAdvance()


    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        tableView.reloadData()

    }
    
    override func viewDidAppear(_ animated: Bool) {
        //calendar.reloadData()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("section: \(section)")
        // set the tasks for each of the diff titles
        if section == 0 {
            return completedTaskList.count
        } else if section == 1 {
            return currentTaskList.count
        } else {
            return upcomingTaskList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "taskCell", for: indexPath) as! TaskCell
        
        var p: Task? = nil

        if indexPath.section == 0 {
            if self.completedTaskList.count > 0 {
                p = self.completedTaskList[indexPath.row]
            }
        } else if indexPath.section == 1 {
            if self.currentTaskList.count > 0 {
                p = self.currentTaskList[indexPath.row]
            }
        } else {
            if self.upcomingTaskList.count > 0 {
                p = self.upcomingTaskList[indexPath.row]
            }
        }
        
        cell.taskTitleLabel.text = p?.taskName
        cell.taskDescLabel.text = p?.taskDesc
        //cell.taskRuntimeLabel.text = "\(p.runtime/60) Hrs \(p.runtime%60) Mins"
        if p?.importance == "Important" { // Differenciate between important and secondary tasks
            cell.taskTitleLabel.textColor = UIColor.systemTeal
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
        let taskFormatTime = getFormattedDate(date: p!.taskStartTime, format: formatDateTime)
        cell.taskDateTimeLabel.text = taskFormatTime

        let formatDateTimeEnd = "h:mm a"
        let taskFormatTimeEnd = getFormattedDate(date: p!.taskEndTime, format: formatDateTime)
        cell.taskEndDateTimeLabel.text = taskFormatTimeEnd
        
        if Calendar.current.isDate(Date(), inSameDayAs: p!.taskStartTime) { // set changes for the UI when user in different day
            cell.taskDateTimeLabel.textColor = UIColor.label
            cell.taskEndDateTimeLabel.textColor = UIColor.label
            if Date() > p!.taskEndTime {
                cell.taskEndDateTimeLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
                cell.taskDateTimeLabel.font = cell.taskDateTimeLabel.font.withSize(15)
                cell.taskDateTimeLabel.textColor = UIColor.systemGray3
                cell.taskEndDateTimeLabel.textColor = UIColor.systemGray3
            } else if Date() > p!.taskStartTime && Date() < p!.taskEndTime {
                cell.taskEndDateTimeLabel.font = cell.taskDateTimeLabel.font.withSize(15)
                cell.taskDateTimeLabel.font = UIFont.boldSystemFont(ofSize: 20.0)
            } else {
                cell.taskDateTimeLabel.font = cell.taskDateTimeLabel.font.withSize(20)
                cell.taskEndDateTimeLabel.font = cell.taskDateTimeLabel.font.withSize(18)
            }
        } else {
            cell.taskEndDateTimeLabel.font = cell.taskDateTimeLabel.font.withSize(18)
            cell.taskDateTimeLabel.font = cell.taskDateTimeLabel.font.withSize(18)
            cell.taskDateTimeLabel.textColor = UIColor.systemGray3
            cell.taskEndDateTimeLabel.textColor = UIColor.systemGray3
        }

        return cell
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Completed"
        } else if section == 1 {
            return "Current"
        } else {
            return "Upcoming"
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if completedTaskList.count == 0 && currentTaskList.count == 0 && upcomingTaskList.count == 0 {
            return 0
        }
        return 3
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
        } else if segue.identifier == "addTaskSegue" {
            let entryViewController = segue.destination as! EntryViewController
            entryViewController.userCurrentDate = self.userCurrentDate
            entryViewController.taskViewController = self
            //print(self.userCurrentDate)
            entryViewController.delegate = self
        }
    }

    
    // Calendar on date change function
    //
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        
        //print("This Ran")
        self.taskList = []
        self.completedTaskList = []
        self.currentTaskList = []
        self.upcomingTaskList = []
        self.userCurrentDate = date
        print("Set userCurrentDate to \(self.userCurrentDate)")
        loadTaskListFromDate(date: date)
        
        // Check if the date pressed is the same as today and then proceed with UI changes
        //
        
        if Calendar.current.isDate(date, inSameDayAs: Date()) {
            print("Same Day")
            breakButton.isEnabled = true
            addTaskButton.isEnabled = true
        } else if date < Date() {
            print("Less than today")
            breakButton.isEnabled = false
            addTaskButton.isEnabled = false
        } else {
            print("More than today")
            breakButton.isEnabled = false
            addTaskButton.isEnabled = true
        }
        
        tableView.reloadData()
//        if completedTaskList.count == 0 && currentTaskList.count == 0 && upcomingTaskList.count == 0 {
//            tableView.isHidden = true
//            print("tableView is hidden")
//        } else {
//            tableView.isHidden = false
//            print("tableView is not hidden")
//
//        }
    }
    
    func calendar(_ calendar: FSCalendar, willDisplay cell: FSCalendarCell, for date: Date, at monthPosition: FSCalendarMonthPosition) {
        var cellEvents = 0

        DataManager.loadTasks { fullUserTaskList in
            var isDaily = false
            
            for task in fullUserTaskList {
                if task.repeatType == "Daily" {
                    print("MATCHED DAILY")
                    isDaily = true
                }
                
                let currentWeekDayFormatter = DateFormatter()
                currentWeekDayFormatter.dateFormat = "EEEE"
                let currentWeekDayString = currentWeekDayFormatter.string(from: date)

                let weekDayFormatter = DateFormatter()
                weekDayFormatter.dateFormat = "EEEE"
                let weekDayString = weekDayFormatter.string(from: task.taskStartTime)
                //print("\(date) is being compared to task: \(task.taskName): \(task.taskStartTime)")

                if task.repeatType == "Weekly" && weekDayString == currentWeekDayString && date >= task.taskStartTime{ // check if weekly
                    print("MATCHED WEEKLY on \(date)")
                    cellEvents += 1
                }
                
                if Calendar.current.isDate(date, inSameDayAs: task.taskStartTime) {
                    print("MATCHED DAY on \(date)")
                    cellEvents += 1
                }
            }
//
//            if fullUserTaskList.contains(where: {Calendar.current.isDate(date, inSameDayAs: $0.taskStartTime) }) {
//
//            }
            
            if isDaily == true {
                if date >= Date() {
                    cellEvents += 1
                }
            }

            print("\(date) has \(cellEvents)")
            if cellEvents > 0 {
                cell.eventIndicator.numberOfEvents = cellEvents
                cell.eventIndicator.isHidden = false
                cell.eventIndicator.color = UIColor.systemRed
            } else {
                cell.eventIndicator.isHidden = true
            }
        }
    }
    
    // Load task from firebase
    func loadTaskListFromDate(date: Date) {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM-dd-YYYY h:mm a"
        let string = formatter.string(from: date)
        print("Loading tasks that are set on: \(string)")
        //var userTaskList: [Task] = []
        
        let currentWeekDayFormatter = DateFormatter()
        currentWeekDayFormatter.dateFormat = "EEEE"
        let currentWeekDayString = currentWeekDayFormatter.string(from: date)
        
        DataManager.loadTasks { fullUserTaskList in
            //userTaskList = fullUserTaskList
            self.taskList = []

            for task in fullUserTaskList {
                
                let weekDayFormatter = DateFormatter()
                weekDayFormatter.dateFormat = "EEEE"
                let weekDayString = weekDayFormatter.string(from: task.taskStartTime)
                //print("\(date) is being compared to task: \(task.taskName): \(task.taskStartTime)")
                
                // Code for if the task is due to call daily or if its the same day for weekly
                //
                
                if Calendar.current.isDate(date, inSameDayAs: task.taskStartTime) || task.repeatType == "Daily" { // check if daily
                    //print("\(date) is the same day as \(task.taskStartTime)")
                    self.taskList.append(task)
                } else if task.repeatType == "Weekly" && weekDayString == currentWeekDayString && date >= task.taskStartTime{ // check if weekly
                    //print("Weekdaystring = \(weekDayString), currentweekdaystring = \(currentWeekDayString)")
                    self.taskList.append(task)
                }
            }
                        
            if self.taskList.count == 0 { // show the illustrations in the case of no task
                if Calendar.current.isDate(date, inSameDayAs: Date()) {
                    self.noFilterView.isHidden = false
                    self.noFilterLabel.text = "No task for today! \n Add one by pressing the '+' button!"
                } else if date < Date() {
                    self.noFilterView.isHidden = false
                    self.noFilterLabel.text = "No task scheduled on this day!"
                } else {
                    self.noFilterView.isHidden = false
                    self.noFilterLabel.text = "No task for today! \n Add one by pressing the '+' button!"
                }
            } else {
                self.noFilterView.isHidden = true
                self.taskList.sort(by: { $0.taskStartTime.compare($1.taskStartTime) == .orderedAscending })
            }
            
            for t in self.taskList {
                if t.taskEndTime < Date() {
                    self.completedTaskList.append(t)
                } else if t.taskStartTime < Date() && Date() < t.taskEndTime {
                    self.currentTaskList.append(t)
                } else {
                    self.upcomingTaskList.append(t)
                }
            }
            
            self.tableView.reloadData()
            print("completed: \(self.completedTaskList), current: \(self.currentTaskList), upcoming: \(self.upcomingTaskList)")

        }
    
    }
    
}

