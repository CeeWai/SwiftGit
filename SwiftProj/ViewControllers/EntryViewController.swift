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

class EntryViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate, CanRecieve, EndCanRecieve, CanRecieveRepeat, CanRecieveImportance, CanReceiveSubject {
    
    var delegateSubject: CanReceiveSubject?
    var subjectData: String = ""
    func passSubjectDataBack(data: String) {
        subjectData = data
        //pickTimeButton.setTite("Time: \(chosenTime)", for: .normal)
        //startTimeLabel.text! += ": \(repeatData)"
        subjectTextField.text! = "\(subjectData)"
        print("You have picked: \(subjectData)")
    }
    
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
    @IBOutlet weak var subjectPredictionLabel: UILabel!
    @IBOutlet weak var subjectTextField: UITextField!
    var userCurrentDate: Date?
    var taskViewController: ViewController?
    let model = TopicsClassifier()
    
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
        descTextView.delegate = self
        titleTextField.delegate = self
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
    //
    
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
                
        if titleTextField.text!.isEmpty || descTextView.text!.isEmpty || descTextView.text == "Your description goes here!" || chosenStartTimeLabel.text!.isEmpty || chosenEndTimeLabel.text!.isEmpty || chosenRepeatLabel.text!.isEmpty || importanceLabel.text!.isEmpty || subjectTextField.text!.isEmpty {
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
                
                var task = Task(taskID: user!.uid + "\(taskListLength)", taskName: self.titleTextField.text!, taskDesc: self.descTextView.text, taskStartTime: dateStartCurrent!, taskEndTime: dateEndCurrent!, repeatType: self.chosenRepeatLabel.text!, taskOwner: (user?.email)!, importance: self.importanceLabel.text!, subject: self.subjectTextField.text!)
                
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
        } else if segue.identifier == "subjectSegue" {
            let pickSegueVC = segue.destination as! SubjectTableViewController
            pickSegueVC.delegate = self
        }

    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        var hpt = predictHoursPerTask()

        return true
    }
    
    @IBAction func subjectEditingChanged(_ sender: Any) {
        //print(subjectTextField.text)
        do {
            let prediction = try self.model.prediction(text: "\(titleTextField.text) \(descTextView.text)" ?? "")
            //subjectTextField.text = prediction.label
            if subjectTextField.text != prediction.label { // handle what happens when the subject is wrong
                subjectPredictionLabel.text = ""
            } else {
                predictHoursPerTask()
            }
        } catch {
            print("PREDICTION ERR FOR: \(titleTextField.text) \(descTextView.text)")
        }

    }
    
    func predictHoursPerTask() {
        if titleTextField.text!.count != 0 && descTextView.text!.count != 0 {
            do {
                //let model = TopicsClassifier()
                let prediction = try self.model.prediction(text: "\(titleTextField.text) \(descTextView.text)" ?? "")
                subjectTextField.text = prediction.label
                print("PREDICTION: \(prediction.label) \(prediction)")
                
                DataManager.loadTasksBySubject(prediction.label, onComplete: { usertaskList in
                    //var avgTimePerDayPerPerson: String
                    var totalHoursSpentForTasksAtATime: Double = 0

                    for task in usertaskList {
    //                    if task.repeatType == "Never" {
    //                        let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: task.taskStartTime, to: task.taskEndTime)
    //                        var hours = Double(diffComponents.hour!)
    //                        if diffComponents.minute! > 0 {
    //                            hours += 0.5
    //                        }
    //                        print("Hours: \(hours) for task: \(task.taskName)")
    //                        totalAmtOfTimeSpentInHoursPerDay += hours
    //
    //                    } else if task.repeatType == "Daily" {
    //                        let diffComponents = Calendar.current.dateComponents([.hour], from: task.taskStartTime, to: task.taskEndTime)
    //                        var hours = Double(diffComponents.hour!)
    //                        let diffComponentsDay = Calendar.current.dateComponents([.day], from: task.taskStartTime, to: Date())
    //                        let day = Double(diffComponentsDay.day!)
    //
    //
    //                        print("Hours: \(hours) for task: \(task.taskName)")
    //                        totalAmtOfTimeSpentInHoursPerDay += hours
    //                    } else if task.repeatType == "Weekly" {
    //                        let diffComponents = Calendar.current.dateComponents([.hour], from: task.taskStartTime, to: task.taskEndTime)
    //                        var hours = Double(diffComponents.hour!)
    //                        let diffComponentsWeeks = Calendar.current.dateComponents([.weekOfYear], from: task.taskStartTime, to: task.taskEndTime)
    //                        //let weeks = Double(diffComponentsWeeks.weekOfYear!)
    //
    ////                        if weeks > 0 {
    ////                            hours = hours * weeks
    ////                        }
    //                        print("hours: \(hours) for task: \(task.taskName)")
    //                        totalAmtOfTimeSpentInHoursPerDay += hours
    //
    //                   }
                        let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: task.taskStartTime, to: task.taskEndTime)
                        var hours = Double(diffComponents.hour!)
                        if diffComponents.minute! > 0 {
                            hours += 0.5
                        }
                        totalHoursSpentForTasksAtATime += hours
                    }
                    var amtOfTasks: Double = Double(usertaskList.count)
                    var hoursSpentAtATime = totalHoursSpentForTasksAtATime/amtOfTasks
                    print("On average, people spend \(hoursSpentAtATime) hour(s) at a time on \(prediction.label)")
                    self.subjectPredictionLabel.text = "On average, people spend \(hoursSpentAtATime) hour(s) at a time on this subject"
                    self.subjectPredictionLabel.isHidden = false
                    //return hoursSpentAtATime
                })
            } catch {
                print("Error predicting for \(titleTextField.text) \(descTextView.text)")
            }
        }

    }
    
    
}

