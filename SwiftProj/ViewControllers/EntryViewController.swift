//
//  EntryViewController.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 7/5/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import FirebaseAuth

protocol CanReceiveReload {
    func passReloadDataBack(data: Date)
}

class EntryViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate, CanRecieve, EndCanRecieve, CanRecieveRepeat, CanRecieveImportance {
    
    var delegate: CanReceiveReload?
    var repeatData: String = ""
    func passRepeatDataBack(data: String) {
        repeatData = data
        //pickTimeButton.setTite("Time: \(chosenTime)", for: .normal)
        //startTimeLabel.text! += ": \(repeatData)"
        chosenRepeatLabel.text! = "\(repeatData)"
        chosenRepeatLabel.isHidden = false
        print("You have picked: \(repeatData)")
    }
    
    var chosenTime: String = ""
    func passDataBack(data: String) {
        var currentStartTime = ""
        if chosenStartTimeLabel.text != "" && chosenStartTimeLabel.text != nil {
            currentStartTime = chosenStartTimeLabel.text!
        }
        
        chosenTime = data
        //pickTimeButton.setTite("Time: \(chosenTime)", for: .normal)
        chosenStartTimeLabel.text! = "\(chosenTime)"
        chosenStartTimeLabel.isHidden = false
        print("You have picked: \(chosenTime)")
        scheduleEndTimeCell.isHidden = false
        
        if currentStartTime != chosenTime {
            chosenEndTimeLabel.text = ""
        }
    }
    
    var chosenEndTime: String = ""
    func passEndDataBack(data: String) {
        chosenEndTime = data
        //pickTimeButton.setTite("Time: \(chosenTime)", for: .normal)
        //endTimeLabel.text! += ": \(chosenEndTime)"
        chosenEndTimeLabel.text! = "\(chosenEndTime)"
        chosenEndTimeLabel.isHidden = false
        print("You have picked: \(chosenEndTime)")
    }
    
    var chosenImportance: String = ""
    func passImportanceDataBack(data: String) {
        chosenImportance = data
        //pickTimeButton.setTite("Time: \(chosenTime)", for: .normal)
        //endTimeLabel.text! += ": \(chosenEndTime)"
        importanceLabel.text! = "\(chosenImportance)"
        print("You have picked: \(chosenImportance)")
    }
    
    @IBOutlet weak var scheduleEndTimeCell: UITableViewCell!
    @IBOutlet weak var chosenRepeatLabel: UILabel!
    @IBOutlet weak var chosenEndTimeLabel: UILabel!
    @IBOutlet weak var chosenStartTimeLabel: UILabel!
    @IBOutlet weak var startTimeLabel: UILabel!
    @IBOutlet weak var endTimeLabel: UILabel!
    @IBOutlet var field: UITextField!
    @IBOutlet weak var setTaskbutton: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descTextView: UITextView!
    //@IBOutlet weak var topTaskView: UIView!
    @IBOutlet weak var entryTaskView: UIView!
    @IBOutlet weak var errLabel: UILabel!
    @IBOutlet weak var importanceLabel: UILabel!
    var userCurrentDate: Date?
    var taskViewController: ViewController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initiate the textview custom placeholder and create the borders
        descTextView.text = "Your description goes here!"
        descTextView.textColor = UIColor.lightGray
        descTextView.delegate = self
        descTextView!.layer.borderWidth = 0.5
        descTextView!.layer.borderColor = UIColor.lightGray.cgColor
        descTextView.layer.cornerRadius = 6.5
        
        let taskDate = self.userCurrentDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM EEEE"
        let parsedDate = dateFormatter.string(from: taskDate!)
        //let startDate = dateFormatterStart.date(from:startDateString)!
        print(parsedDate)

        self.setTaskbutton.setTitle("Set Task on: \(parsedDate)", for: UIControl.State.normal)
    }
    
    // because swift doesnt have a placeholder function for textviews, i created one lol
    func textViewDidBeginEditing(_ textView: UITextView) {
        if descTextView.textColor == UIColor.lightGray {
            descTextView.text = nil
            if traitCollection.userInterfaceStyle == .dark {
                descTextView.textColor = UIColor.white

            } else {
                descTextView.textColor = UIColor.black

            }
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        print("yes hi wassup")
        if descTextView.text.isEmpty {
            descTextView.text = "Your description goes here!"
            descTextView.textColor = UIColor.lightGray
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        //saveTask()
        return true
    }
    
    @IBAction func saveTask() {
        let user = Auth.auth().currentUser
        if let user = user {
          let uid = user.uid
          let email = user.email
        }
                    
//        print(titleTextField.text!.isEmpty)
//        print(descTextView.text!.isEmpty)
//        print(chosenStartTimeLabel.text!.isEmpty)
//        print(chosenEndTimeLabel.text!.isEmpty)
//        print(chosenRepeatLabel.text!.isEmpty)
        
        if titleTextField.text!.isEmpty || descTextView.text!.isEmpty || descTextView.text == "Your description goes here!" || chosenStartTimeLabel.text!.isEmpty || chosenEndTimeLabel.text!.isEmpty || chosenRepeatLabel.text!.isEmpty || importanceLabel.text!.isEmpty {
                errLabel.text = "Enter all fields!"
                errLabel.isHidden = false
        } else
        {
            //print(user!.email)
            DataManager.loadTasks() {
                taskListFromFirestore in
                //print("\(taskListFromFirestore)")
                
                let now = self.userCurrentDate!
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yyyy "
                let date = dateFormatter.string(from: now)
                var dateStartTime = date + self.chosenStartTimeLabel.text!
                var dateEndTime = date + self.chosenEndTimeLabel.text!
                
                let dateAsString = dateStartTime
                let startDateFormatter = DateFormatter()
                startDateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
                let dateStartCurrent = startDateFormatter.date(from: dateAsString)
                
                let endDateAsString = dateEndTime
                let endDateFormatter = DateFormatter()
                endDateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
                let dateEndCurrent = endDateFormatter.date(from: endDateAsString)
                
                var taskListLength = 0
                if taskListFromFirestore != nil {
                    taskListLength = taskListFromFirestore.count
                }
                
                var task = Task(taskID: user!.uid + "\(taskListLength)", taskName: self.titleTextField.text!, taskDesc: self.descTextView.text, taskStartTime: dateStartCurrent!, taskEndTime: dateEndCurrent!, repeatType: self.chosenRepeatLabel.text!, taskOwner: (user?.email)!, importance: self.importanceLabel.text!)
                
                print("name: \(self.titleTextField.text!), description: \(self.descTextView!.text!), startTime: \(dateStartCurrent!), taskEndTime: \(dateEndCurrent!), repeatType: \(self.chosenRepeatLabel.text!), taskOwner: \(user!.email!)")
                
                DataManager.insertOrReplaceTask(task)
                self.taskViewController?.tableView.reloadData() // reload the tableview before popping back
                
                self.delegate?.passReloadDataBack(data: self.userCurrentDate!)
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)

            }
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickTimeSegue" {
            let pickTimeVC = segue.destination as! TimeViewController
            pickTimeVC.delegate = self
            pickTimeVC.userCurrentDate = self.userCurrentDate
        } else if segue.identifier == "pickEndTimeSegue" {
            let pickEndTimeVC = segue.destination as! EndTimeViewController
            pickEndTimeVC.delegate = self
            pickEndTimeVC.startTime = chosenStartTimeLabel.text
            pickEndTimeVC.userCurrentDate = self.userCurrentDate

        } else if segue.identifier == "repeatSegue" {
           let pickRepeatVC = segue.destination as! RepeatTableViewController
           pickRepeatVC.delegate = self
        } else if segue.identifier == "pickImportanceSegue" {
            let pickImportanceVC = segue.destination as! ImportanceTableViewController
            pickImportanceVC.delegate = self
        }

    }

}

