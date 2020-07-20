//
//  IndividualTaskViewController.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 12/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class IndividualTaskViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    var individualTask: Task?
    var todayTaskList: [Task] = []

    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        timeLabel.text = "Placeholder for the time label"
//        //descriptionLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam dapibus mi auctor feugiat pharetra. Phasellus id nisl id odio facilisis venenatis eget laoreet velit. Sed dictum vitae erat non maximus. Praesent eget turpis vel neque varius sollicitudin a a turpis. Pellentesque volutpat tincidunt odio at vehicula. Suspendisse varius sodales augue, sed maximus nibh maximus non. Sed semper efficitur rutrum. Nullam in lacus eget diam consequat finibus. Suspendisse tincidunt et sem a dignissim."
//        descriptionLabel.text = individualTask?.taskName
//
//        self.tableView.rowHeight = UITableView.automaticDimension;
//        infoCardView.setNeedsLayout()
//        infoCardView.layoutIfNeeded()
//        //print("the height of the card view \(infoCardView.fs_height)")
//        //infoCardCell.fs_height = infoCardView.fs_height + 30
//
        loadTodayList()

        collectionView.delegate = self

        collectionView.dataSource = self

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //loadTodayList()

        //collectionView.reloadData()
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("NUMBER OF SECTIONS TODAY LIST \(self.todayTaskList)")
        return self.todayTaskList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "taskCollectionViewCell", for: indexPath) as! IndividualTaskCollectionViewCell
        
        let task = todayTaskList[indexPath.item]
        print(task.taskName)
        cell.task = task
        cell.fs_height = cell.individualCellView.fs_height
        cell.fs_width = cell.individualCellView.fs_width
        print(cell.fs_height, cell.fs_width)
        
        
        return cell
    }
    
//    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        if indexPath.row == 0 {
//            return 110
//        } else if indexPath.row == 1 {
//            return infoCardView.fs_height + 40
//        } else {
//            return 250
//        }
//    }

    func loadTodayList() {
        var date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE MM-dd-YYYY h:mm a"
        let string = formatter.string(from: date)
        print("Loading tasks that are set on: \(string)")
    
        let currentWeekDayFormatter = DateFormatter()
        currentWeekDayFormatter.dateFormat = "EEEE"
        let currentWeekDayString = currentWeekDayFormatter.string(from: date)
        
        DataManager.loadTasks { fullUserTaskList in
            //userTaskList = fullUserTaskList
            self.todayTaskList = []

            for task in fullUserTaskList {
                
                let weekDayFormatter = DateFormatter()
                weekDayFormatter.dateFormat = "EEEE"
                let weekDayString = weekDayFormatter.string(from: task.taskStartTime)
                
                if Calendar.current.isDate(date, inSameDayAs: task.taskStartTime) || task.repeatType == "Daily" { // check if daily
                    //print("\(date) is the same day as \(task.taskStartTime)")
                    self.todayTaskList.append(task)
                } else if task.repeatType == "Weekly" && weekDayString == currentWeekDayString && date >= task.taskStartTime{ // check if weekly
                    //print("Weekdaystring = \(weekDayString), currentweekdaystring = \(currentWeekDayString)")
                    self.todayTaskList.append(task)
                }
            }
            self.todayTaskList.sort(by: { $0.taskStartTime.compare($1.taskStartTime) == .orderedAscending })
            print("=============== \(self.todayTaskList)")

            self.collectionView.reloadData()
        }
    
    }
    
}
