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

class EntryViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate, CanRecieve, EndCanRecieve, CanRecieveRepeat {
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initiate the textview custom placeholder and create the borders
        descTextView.text = "Your description goes here!"
        descTextView.textColor = UIColor.lightGray
        descTextView.delegate = self
        descTextView!.layer.borderWidth = 0.5
        descTextView!.layer.borderColor = UIColor.lightGray.cgColor
        descTextView.layer.cornerRadius = 6.5
        
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
        
        if titleTextField.text!.isEmpty || descTextView.text!.isEmpty || descTextView.text == "Your description goes here!" || chosenStartTimeLabel.text!.isEmpty || chosenEndTimeLabel.text!.isEmpty || chosenRepeatLabel.text!.isEmpty {
                errLabel.text = "Enter all fields!"
                errLabel.isHidden = false
        } else
        {
            //print(user!.email)
            DataManager.loadTasks() {
                taskListFromFirestore in
                //print("\(taskListFromFirestore)")
                
                let now = Date()
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
                
                var task = Task(id: user!.uid + "\(taskListLength)", name: self.titleTextField.text!, description: self.descTextView.text, startTime: dateStartCurrent!, taskEndTime: dateEndCurrent!, repeatType: self.chosenRepeatLabel.text!, taskOwner: (user?.email)!)
                
                print("name: \(self.titleTextField.text!), description: \(self.descTextView!.text!), startTime: \(dateStartCurrent!), taskEndTime: \(dateEndCurrent!), repeatType: \(self.chosenRepeatLabel.text!), taskOwner: \(user!.email!)")
                
                DataManager.insertOrReplaceTask(task)
                
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
//                print(dateAsString)
//                print(endDateAsString)
//
//                let df = DateFormatter()
//                df.dateFormat = "yyyy-MM-dd h:mm a"
//                let nowAF = df.string(from: Date())
//                print("date: \(Date())")
//                print(nowAF)

            }
        }
        


    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickTimeSegue" {
            let pickTimeVC = segue.destination as! TimeViewController
            pickTimeVC.delegate = self
        } else if segue.identifier == "pickEndTimeSegue" {
            let pickEndTimeVC = segue.destination as! EndTimeViewController
            pickEndTimeVC.delegate = self
            pickEndTimeVC.startTime = chosenStartTimeLabel.text
        } else if segue.identifier == "repeatSegue" {
           let pickRepeatVC = segue.destination as! RepeatTableViewController
           pickRepeatVC.delegate = self
       }

    }

}

