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
import TesseractOCR

protocol CanReceiveReload {
    func passReloadDataBack(data: Date)
}

class EntryViewController: UITableViewController, UITextFieldDelegate, UITextViewDelegate, CanRecieve, EndCanRecieve, CanRecieveRepeat, CanRecieveImportance, CanReceiveSubject, UIImagePickerControllerDelegate, UINavigationControllerDelegate, G8TesseractDelegate {
    
    // Below are delegate functions to get the data back from each
    // of the views that are linked to the entryViewController
    //
    var delegateSubject: CanReceiveSubject?
    var subjectData: String = ""
    func passSubjectDataBack(data: String) {
        subjectData = data
        //pickTimeButton.setTite("Time: \(chosenTime)", for: .normal)
        //startTimeLabel.text! += ": \(repeatData)"
        subjectTextField.text! = "\(subjectData)"
        print("You have picked: \(subjectData)")
        if subjectTextField.text!.isEmpty == false {
            self.predictHoursWrongPassBack()
        }
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
    @IBOutlet weak var entryTaskView: UIView!
    @IBOutlet weak var errLabel: UILabel!
    @IBOutlet weak var importanceLabel: UILabel!
    @IBOutlet weak var subjectPredictionLabel: UILabel!
    @IBOutlet weak var subjectTextField: UITextField!
    var userCurrentDate: Date?
    var taskViewController: ViewController?
    let model = TopicsClassifier()
    @IBOutlet weak var startRecognitionButton: UIButton!
    let speechRecognizer = SpeechRecognizer()
    let speechSynthesizer = SpeechSynthesizer()
    @IBOutlet weak var startCameraRecognitionButton: UIButton!
    var editTask: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // initiate the textview custom placeholder and create the borders
        descTextView.text = "Your description goes here!"
        descTextView.textColor = UIColor.lightGray
        descTextView.delegate = self
        descTextView!.layer.borderWidth = 0.5
        descTextView!.layer.borderColor = UIColor.lightGray.cgColor
        descTextView.layer.cornerRadius = 6.5
        
        // set title for the set task button
        let taskDate = self.userCurrentDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "d MMM EEEE"
        let parsedDate = dateFormatter.string(from: taskDate!)
        self.setTaskbutton.setTitle("Set Task on: \(parsedDate)", for: UIControl.State.normal)
        descTextView.delegate = self
        titleTextField.delegate = self

        // set delegate for OCR function
        //
        if let tesseract = G8Tesseract(language: "eng") {
            tesseract.delegate = self
        }
        
        if editTask != nil {
            titleTextField.text = editTask!.taskName
            descTextView.text = editTask!.taskDesc
            let dateFormatterStart = DateFormatter()
            dateFormatterStart.dateFormat = "h:mm a"
            let startDateString = dateFormatterStart.string(from: editTask!.taskStartTime)
            chosenStartTimeLabel.text = startDateString
            let dateFormatterEnd = DateFormatter()
            dateFormatterEnd.dateFormat = "h:mm a"
            let endDateString = dateFormatterEnd.string(from: editTask!.taskEndTime)
            chosenEndTimeLabel.text = endDateString
            chosenRepeatLabel.text = editTask!.repeatType
            chosenRepeatLabel.isHidden = false
            subjectTextField.text = editTask!.subject
            importanceLabel.text = editTask!.importance
            chosenStartTimeLabel.isHidden = false
            scheduleEndTimeCell.isHidden = false
            chosenEndTimeLabel.isHidden = false
            predictHoursPerTask()
            if traitCollection.userInterfaceStyle == .dark {
                descTextView.textColor = UIColor.white

            } else {
                descTextView.textColor = UIColor.black

            }
        }
    }
    
    @IBAction func cameraRecognitionPressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        // Setting this to true allows the user to crop and scale
        // the image to a square after the image is selected.
        //
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
    }
    
    // This function is called after the user took the picture,
    // or selected a picture from the photo library.
    // When that happens, we simply assign the image binary,
    // represented by UIImage, into the imageView we created.
    //
    // iOS doesn’t close the picker controller
    // automatically, so we have to do this ourselves by calling
    // dismissViewControllerAnimated.
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let chosenImage : UIImage = info[.editedImage] as! UIImage
        print()
        if let tesseract = G8Tesseract(language: "eng") {
            tesseract.delegate = self
            tesseract.image = chosenImage.g8_blackAndWhite()
            tesseract.recognize()
            
            self.descTextView.text = tesseract.recognizedText
            self.descTextView.textColor = UIColor.label
        }
        //self.imageView!.image = chosenImage
        // This saves the image selected / shot by the user
        //
        //UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil)

        // This closes the picker
        //
        picker.dismiss(animated: true)
        
    }
    
    func progressImageRecognition(for tesseract: G8Tesseract) {
        print("Recognition Progress \(tesseract.progress) %")
    }
    
    // This function is called after the user decides not to
    // take/select any picture. iOS doesn’t close the picker controller // automatically, so we have to do this ourselves by calling
    // dismissViewControllerAnimated.
    func imagePickerControllerDidCancel( _ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    @IBAction func speechRecognitionButtonPressed(_ sender: Any) {
        self.speechSynthesizer.stop()
        if !speechRecognizer.isRunning {
            // Disable the "Start Recognition" button
            // so that user cannot start another recognition
            // while the current one is in progress.
            startRecognitionButton.isEnabled = false
            
            //Start the speech recognition
            //
            speechRecognizer.startRecognition(onReceivedTranscription: {
                recognizedString in
                
                // This onReceivedTranscription closure will be
                // executed several times during the speech
                // recognition as the user speaks. So we simply
                // just retrieve the recognized string and display
                // it into our resultTextView.
                //
                self.descTextView.text = recognizedString
                
            }, onStoppedRecognizing: {
                recognizedString in
                
                // The onStoppedRecognizing closure will be executed
                // only once (when there is an error, or when the
                // recognition is deemed complete after a short period
                // of silence). Here, we display the final recognized
                // text, and process it with a simple if-else to
                // decide what to reply to the user with Siri's voice.
                //
                self.descTextView.text = recognizedString
                
                let trimmedResult = recognizedString.lowercased()
                .trimmingCharacters(in: [" "])
                
                if trimmedResult == "" {
                    self.speechSynthesizer.speak(text: "Excuse me but, nani?")
                } else if trimmedResult == "hello" {
                    self.speechSynthesizer.speak(text: "Ohaiyo Gozaimasu")
                } else if trimmedResult == "go away" {
                    // This special version of the speak function
                    // allows us to provide a closure that executes
                    // only when the synthesized text has spoken
                    // completely.
                    //
                    // In our case, we will pop the current View
                    // Controller only when that happens.
                    //
                    self.speechSynthesizer.speak(
                        text: "Ok, Sayonara Weeb",
                        onStoppedSpeaking: {
                            self.navigationController?
                            .popViewController(animated: true)
                    })
                }else
                {
                    //self.speechSynthesizer.speak(text: "You just said, \(trimmedResult)")
                    
                }
                
                // Re-enable the “Start Recognition” button again.
                //
                self.startRecognitionButton.isEnabled = true
                
            })
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        speechRecognizer.stopRecognition()
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
                
        // Validation of inputs
        //
        
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
                var task = Task(taskID: user!.uid + "\(taskListLength)", taskName: self.titleTextField.text!, taskDesc: self.descTextView.text, taskStartTime: dateStartCurrent!, taskEndTime: dateEndCurrent!, repeatType: self.chosenRepeatLabel.text!, taskOwner: (user?.email)!, importance: self.importanceLabel.text!, subject: self.subjectTextField.text!, lastStartDelayedTime: nil, lastEndDelayedTime: nil)
                
                if self.editTask != nil {
                    task.taskID = self.editTask!.taskID
                }
                print("name: \(self.titleTextField.text!), description: \(self.descTextView!.text!), startTime: \(dateStartCurrent!), taskEndTime: \(dateEndCurrent!), repeatType: \(self.chosenRepeatLabel.text!), taskOwner: \(user!.email!)")
                
                // Insert task into firebase
                DataManager.insertOrReplaceTask(task)
                self.taskViewController?.tableView.reloadData() // reload the tableview before popping back
                
                if self.editTask != nil {
                    let homeViewController = (self.storyboard?.instantiateViewController(identifier: "MainController"))
                    self.view.window?.rootViewController = homeViewController
                    self.present(homeViewController!, animated: true)
                } else {
                    
                    self.delegate?.passReloadDataBack(data: self.userCurrentDate!)
                    self.dismiss(animated: true, completion: nil)
                    self.navigationController?.popViewController(animated: true)
                }


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
            let pickSubjectVC = segue.destination as! SubjectTableViewController
            pickSubjectVC.delegate = self
        
        }

    }
    
    func textViewShouldEndEditing(_ textView: UITextView) -> Bool {
        var hpt = predictHoursPerTask()

        return true
    }
    
    @IBAction func subjectEditingChanged(_ sender: Any) {
        do {
            let prediction = try self.model.prediction(text: "\(titleTextField.text) \(descTextView.text)" ?? "")
            if subjectTextField.text != prediction.label { // handle what happens when the subject is wrong
                subjectPredictionLabel.text = ""
            } else {
                predictHoursPerTask()
            }
        } catch {
            print("PREDICTION ERR FOR: \(titleTextField.text) \(descTextView.text)")
        }

    }
    
    func predictHoursWrongPassBack() { // handle function in case the Neural net picked the wrong choice or if he picks a subject himself
        DataManager.loadTasksBySubject(subjectTextField.text!, onComplete: { usertaskList in
            var totalHoursSpentForTasksAtATime: Double = 0

            for task in usertaskList {
                let diffComponents = Calendar.current.dateComponents([.hour, .minute], from: task.taskStartTime, to: task.taskEndTime)
                var hours = Double(diffComponents.hour!)
                if diffComponents.minute! > 0 {
                    hours += 0.5
                }
                totalHoursSpentForTasksAtATime += hours
            }
            
            var amtOfTasks: Double = Double(usertaskList.count)
            var hoursSpentAtATime = totalHoursSpentForTasksAtATime/amtOfTasks
            print("On average, people spend \(hoursSpentAtATime) hour(s) at a time on \(self.subjectTextField.text)")
            self.subjectPredictionLabel.text = "On average, people spend \(hoursSpentAtATime) hour(s) at a time on this subject"
            self.subjectPredictionLabel.isHidden = false
        })

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
                        // Find avg time taken that people take for each task and their subject
                        //
                        
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

