//
//  TaskViewController.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 7/5/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class TaskViewController: UIViewController {

    var taskItem : Task!
//    @IBOutlet weak var runtimeLabel: UILabel!
//    @IBOutlet weak var taskDateTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    @IBOutlet weak var taskView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        //runtimeLabel.text = String(taskItem.runtime)
        //taskDateTimeLabel.text = String(taskItem.taskStartTime)
        titleLabel.text = taskItem.taskName
        descriptionLabel.text = taskItem.taskDesc
        
        taskView.layer.shadowColor = UIColor.lightGray.cgColor
        taskView.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        taskView.layer.shadowOpacity = 0.2
        taskView.layer.shadowRadius = 4.0
        taskView.layer.masksToBounds = false
        taskView.layer.borderWidth = 0.4
        taskView.layer.cornerRadius = 6

    }

}
