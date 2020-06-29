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

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var breakButton: UIButton!

    @IBOutlet weak var calendarView: UIView!
    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var tableView: UITableView!
    var taskList : [Task] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        // Make the navigation bar background clear
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        
        tableView.layer.cornerRadius = 10;
        
//        // Change the date on the top
//        updateToCurrentTime()
//        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
//                self.updateToCurrentTime()
//            }
        
        // temp add date value to the to do listings
        
        // Specify date components
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy HH:mm:ss"

        let datetime = formatter.date(from: "10-05-2020 13:00:00")!

        let formatter2 = DateFormatter()
        formatter2.dateFormat = "dd-MM-yyyy HH:mm:ss"

        let datetime2 = formatter2.date(from: "10-05-2020 15:00:00")!
        
        taskList.append(Task(id: "OoWftREGKR4VQU0UNpss", name: "CGIS Practical", description: "Practical at 1PM on May 28", startTime: datetime, taskEndTime: datetime, repeatType: "Never", taskOwner: "ceewai@ceewai.com"))
        taskList.append(Task(id: "EoWftREGKc4VQU0UNpss", name: "FAI Tutorial", description: "Tutorial at 3PM on May 28", startTime: datetime, taskEndTime: datetime, repeatType: "Never", taskOwner: "ceewai@ceewai.com"))
        
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
        
        // format for the time to do the task
        let formatDateTime = "h:mm a"
        let taskFormatTime = getFormattedDate(date: p.taskStartTime, format: formatDateTime)
        cell.taskDateTimeLabel.text = taskFormatTime

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
    
    
    
    // removed this feature
//    func updateToCurrentTime(){
//        let date = Date()
//        let format = DateFormatter()
//        format.dateFormat = "MMM dd EEEE"
//        let formattedDate = format.string(from: date)
//
//        day_month_label.text = "\(formattedDate)"
//
//        format.dateFormat = "h:mm a"
//        let formattedDate2 = format.string(from: date)
//        time_label.text = "\(formattedDate2)"
//    }
    
    
    
}

