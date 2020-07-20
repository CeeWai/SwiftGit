//
//  addtask1ViewController.swift
//  SwiftProj
//
//  Created by Sebastian on 10/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class addtask1ViewController: UIViewController {


    @IBOutlet var name: UITextField!
    @IBOutlet var startdate: UITextField!
    @IBOutlet var goal: UITextView!
    @IBOutlet var enddate: UITextField!
    var startdateraw :Date?
    var enddateraw :Date?
    let datePicker = UIDatePicker()
    var userid = "BKAoYyXFsBUzr8tKDViHw4tRrog2"
    var taskgoal = ""
    var projectItem : Project?
    @IBOutlet var nextbtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        let bottomline = CALayer()
        bottomline.frame = CGRect(x:0,y:name.frame.height - 2, width: name.frame.width,height: 2)
        bottomline.backgroundColor = UIColor.systemRed.cgColor
        let bottomline2 = CALayer()
        bottomline2.frame = CGRect(x:0,y:name.frame.height - 2, width: name.frame.width,height: 2)
        bottomline2.backgroundColor = UIColor.systemRed.cgColor
        let bottomline3 = CALayer()
        bottomline3.frame = CGRect(x:0,y:name.frame.height - 2, width: name.frame.width,height: 2)
        bottomline3.backgroundColor = UIColor.systemRed.cgColor
        name.borderStyle = .none
        name.layer.addSublayer(bottomline2)
        startdate.borderStyle = .none
        startdate.layer.addSublayer(bottomline3)
        enddate.borderStyle = .none
        enddate.layer.addSublayer(bottomline)
        goal.layer.borderWidth = 2;
        goal.layer.cornerRadius = 7
        goal.layer.borderColor = UIColor.systemRed.cgColor
        createDatePicker()
        // Do any additional setup after loading the view.
    }
    func createDatePicker(){
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed))
        toolbar.setItems([doneBtn], animated: true)
        let toolbar2 = UIToolbar()
        toolbar2.sizeToFit()
        let doneBtn2 = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressed2))
        toolbar.setItems([doneBtn], animated: true)
        toolbar2.setItems([doneBtn2], animated: true)
        startdate.inputAccessoryView = toolbar
        startdate.inputView = datePicker
        enddate.inputAccessoryView = toolbar2
        enddate.inputView = datePicker
        datePicker.datePickerMode = .date
    }
    @objc func donePressed(){
        startdateraw = datePicker.date
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        startdate.text = formatter.string(from: datePicker.date)
        self.view.endEditing(true)
        
    }
    @objc func donePressed2(){
           enddateraw = datePicker.date
           let formatter = DateFormatter()
           formatter.dateStyle = .medium
           formatter.timeStyle = .none
           enddate.text = formatter.string(from: datePicker.date)
           self.view.endEditing(true)
           
    }

    
    @IBAction func pressednextbtn(_ sender: Any) {
        var taskname = name.text
        userid = "1nC1S8cngKXT2da4CmaiV2sb4Ia2"
        taskgoal = goal.text
        ProjectTaskDataManager.insertOrReplace(projecttask: ProjectTask(taskid: 0, projectid: projectItem?.projectId!, userid: userid, taskname: taskname, taskgoal: taskgoal, startdate: startdateraw, enddate: enddateraw,status: 0, valid: 1))
    }
    
    override func prepare(for segue: UIStoryboardSegue,
        sender: Any?){
        if(segue.identifier == "seguetoassignmember")
         {
            var taskname = name.text
            userid = "1nC1S8cngKXT2da4CmaiV2sb4Ia2"
            taskgoal = goal.text
        let detailViewController = segue.destination as! addtask2ViewController
            detailViewController.projecttaskItem = ProjectTask(taskid: 0, projectid: projectItem?.projectId!, userid: userid, taskname: taskname!, taskgoal: taskgoal, startdate: startdateraw!, enddate: enddateraw!,status: 0, valid: 1)
            detailViewController.projectItem = self.projectItem!
        }
    }
}

