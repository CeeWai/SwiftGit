//
//  IndividualTaskViewController.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 16/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class IndividualTaskViewController: UIViewController {

    var individualTask: Task?
    var userCurrentDate: Date?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var dayTimeLabel: UILabel!
    @IBOutlet weak var hourTimeLabel: UILabel!
    @IBOutlet weak var timeView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        titleLabel.text = individualTask?.taskName
        //dayTimeLabel.text = individualTask
        let weekDayFormatter = DateFormatter()
        weekDayFormatter.dateFormat = "d EEEE YYYY"
        let weekDayString = weekDayFormatter.string(from: individualTask!.taskStartTime)
        dayTimeLabel.text = weekDayString
        
        let hourTimeFormatter = DateFormatter()
        hourTimeFormatter.dateFormat = "h:mm a"
        let hourStartTimeString = hourTimeFormatter.string(from: individualTask!.taskStartTime)
        let hourEndTimeString = hourTimeFormatter.string(from: individualTask!.taskEndTime)
        var dateTime = "\(hourStartTimeString) - \(hourEndTimeString)"
        hourTimeLabel.text = dateTime
        timeView.layer.cornerRadius = 10
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addBottomSheetView()
    }
    
    func addBottomSheetView() {
        let bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.task = individualTask
        //print(individualTask)
        
        self.addChild(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: self)
        
        let height = view.frame.height
        let width = view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0, y: view.frame.maxY + 20, width: width, height: height)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editTaskSegue" {
            let editViewController = segue.destination as! EntryViewController
            editViewController.editTask = individualTask
            editViewController.userCurrentDate = userCurrentDate
        }
    }
}
