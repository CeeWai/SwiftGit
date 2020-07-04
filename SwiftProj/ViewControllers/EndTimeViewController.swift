//
//  EndTimeViewController.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 26/6/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

protocol EndCanRecieve {
    func passEndDataBack(data: String)
}

class EndTimeViewController: UIViewController {

    var delegate: EndCanRecieve?
    var startTime: String?
    var data = ""
    
    //@IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var buttonStackView1: UIStackView!
    @IBOutlet weak var buttonStackView2: UIStackView!
    @IBOutlet weak var buttonStackView3: UIStackView!
    @IBOutlet weak var buttonStackView4: UIStackView!
    @IBOutlet weak var buttonStackView5: UIStackView!
    @IBOutlet weak var buttonStackView6: UIStackView!
    @IBOutlet weak var buttonStackView7: UIStackView!
    @IBOutlet weak var buttonStackView8: UIStackView!
    @IBOutlet weak var buttonStackView9: UIStackView!
    @IBOutlet weak var buttonStackView10: UIStackView!
    @IBOutlet weak var buttonStackView11: UIStackView!
    @IBOutlet weak var buttonStackView12: UIStackView!
    @IBOutlet weak var buttonStackView13: UIStackView!

    @IBOutlet weak var contentView: UIView!
    var myButtonArray: [String] = []
    var myButtonArray2: [String] = []
    var stack1Count = 0
    var stack2Count = 0
    var stack3Count = 0
    var stack4Count = 0
    var stack5Count = 0
    var stack6Count = 0
    var stack7Count = 0
    var stack8Count = 0
    var stack9Count = 0
    var stack10Count = 0
    var stack11Count = 0
    var stack12Count = 0
    var stack13Count = 0


    var myButtonTestArray: [String] = ["1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM", "1:00 AM"]
    @IBOutlet weak var titleCardLabel: UILabel!
    override func viewDidLoad() {
        stack1Count = 0
        stack2Count = 0
        stack3Count = 0
        stack4Count = 0
        stack5Count = 0
        stack6Count = 0
        stack7Count = 0
        stack8Count = 0
        stack9Count = 0
        stack10Count = 0
        stack11Count = 0
        stack12Count = 0
        stack13Count = 0

        super.viewDidLoad()
        
//        buttonScrollView.translatesAutoresizingMaskIntoConstraints = false
//        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
//        contentView.translatesAutoresizingMaskIntoConstraints = false
        
        setTimeButtonArray()
        DataManager.loadTasks { fullUserTaskList in
            var todayTask: [Task] = []
            for (index, element) in self.myButtonArray.enumerated() {
                var oneBtn : UIButton {
                    let button = UIButton()
                    button.setTitle(element, for: .normal)
                    button.backgroundColor = UIColor.black
                    button.layer.borderColor = UIColor.black.cgColor
                    button.setTitleColor(UIColor.white, for: .normal)
    //                button.translatesAutoresizingMaskIntoConstraints = false
                    button.contentHorizontalAlignment = .center
                    button.contentVerticalAlignment = .center
                    button.titleLabel?.font = UIFont(name: "Arial", size: 16)
                    button.layer.cornerRadius = 5
                    button.addTarget(self, action: #selector(self.buttonAction), for: .touchUpInside)
                    button.clipsToBounds = true
                    //button.frame.size = CGSize(width: 82, height: 35)
                    //button.widthAnchor.constraint(equalToConstant: 200).isActive = true
                    //button.heightAnchor.constraint(equalToConstant: 35).isActive = true
                    //print(index)
                    button.tag = index
                    
                    let dateAsString = self.startTime!
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "hh:mm a"
                    let date = dateFormatter.date(from: dateAsString)
                    
                    let dateAsStringCurrent = element
                    let dateFormatterCurrent = DateFormatter()
                    dateFormatterCurrent.dateFormat = "hh:mm a"
                    let dateCurrent = dateFormatterCurrent.date(from: dateAsStringCurrent)
                    
                    if dateCurrent! <= date! {
                        button.backgroundColor = UIColor.gray
                        button.isEnabled = false
                        print("\(dateCurrent) is less than or equal to \(date)")
                    }

    //                dateFormatter.dateFormat = "HH:mm"
    //                let date24 = dateFormatter.stringFromDate(date!)
                    
                    for task in todayTask {
                        let taskStartDate = task.taskStartTime
                        let dateFormatterStart = DateFormatter()
                        dateFormatterStart.dateFormat = "h:mm a"
                        let startDateString = dateFormatterStart.string(from: taskStartDate)
                        let startDate = dateFormatterStart.date(from:startDateString)!
                        
                        let taskEndDate = task.taskEndTime
                        let dateFormatterEnd = DateFormatter()
                        dateFormatterEnd.dateFormat = "h:mm a"
                        let endDateString = dateFormatterEnd.string(from: taskEndDate)
                        let endDate = dateFormatterEnd.date(from:endDateString)!

                        let isoDate = "\(element)"
                        //print("isoDate \(isoDate)")
                        
                        let dateFormatter = DateFormatter()
                        //dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
                        dateFormatter.dateFormat = "h:mm a"
                        let date = dateFormatter.date(from:isoDate)!
                        
                        print("date = \(date)")
                        if date == startDate || date == endDate {
                            print("\(date) is equal to \(startDate) or \(endDate)")
                             button.backgroundColor = UIColor.lightGray
                             button.isEnabled = false
                        }
                        
                        if date >= startDate && date <= endDate {
                            print("\(date) is in between \(startDate) and \(endDate)")
                            button.backgroundColor = UIColor.lightGray
                            button.isEnabled = false
                        }
                    }
                    
                    return button
                };()
                
    //            var view: UIView! = UIView(frame: CGRect(x: 0, y: 0, width: 300, height: 35))
    //            view.backgroundColor = UIColor.black
    //            view.addSubview(oneBtn)
                
                if self.stack1Count < 4 {
                     self.buttonStackView1.addArrangedSubview(oneBtn)
                     self.stack1Count += 1
                 } else if self.stack2Count < 4 {
                     self.buttonStackView2.addArrangedSubview(oneBtn)
                     self.stack2Count += 1
                 } else if self.stack3Count < 4 {
                     self.buttonStackView3.addArrangedSubview(oneBtn)
                     self.stack3Count += 1
                 } else if self.stack4Count < 4 {
                     self.buttonStackView4.addArrangedSubview(oneBtn)
                     self.stack4Count += 1
                 } else if self.stack5Count < 4 {
                     self.buttonStackView5.addArrangedSubview(oneBtn)
                     self.stack5Count += 1
                 } else if self.stack6Count < 4 {
                     self.buttonStackView6.addArrangedSubview(oneBtn)
                     self.stack6Count += 1
                 } else if self.stack7Count < 4 {
                     self.buttonStackView7.addArrangedSubview(oneBtn)
                     self.stack7Count += 1
                 } else if self.stack4Count < 4 {
                     self.buttonStackView7.addArrangedSubview(oneBtn)
                     self.stack7Count += 1
                 } else if self.stack8Count < 4 {
                     self.buttonStackView8.addArrangedSubview(oneBtn)
                     self.stack8Count += 1
                 } else if self.stack9Count < 4 {
                    self.buttonStackView9.addArrangedSubview(oneBtn)
                    self.stack9Count += 1
                } else if self.stack10Count < 4 {
                    self.buttonStackView10.addArrangedSubview(oneBtn)
                    self.stack10Count += 1
                } else if self.stack11Count < 4 {
                    self.buttonStackView11.addArrangedSubview(oneBtn)
                    self.stack11Count += 1
                } else if self.stack12Count < 4 {
                    self.buttonStackView12.addArrangedSubview(oneBtn)
                    self.stack12Count += 1
                } else if self.stack13Count < 4 {
                    self.buttonStackView13.addArrangedSubview(oneBtn)
                    self.stack13Count += 1
                }
                //print(buttonStackView.frame.height)
            }
        }
        
        
        //print("scrollview size \(buttonScrollView.contentSize)")
//        print("buttonstackview1 size \(buttonStackView1.frame.size)")
//        print("buttonstackview2 size \(buttonStackView2.frame.size)")
//        print("buttonstackview3 size \(buttonStackView3.frame.size)")
        //print(myButtonTestArray.count + 1)
    }
    
    @IBAction func buttonAction(sender: UIButton!) {
        var txtTime = ""
        if let text: String = sender.titleLabel!.text {
           txtTime = text
        }
        print("Button tapped with tag \(sender.tag), value \(txtTime)")
        delegate?.passEndDataBack(data: txtTime)
        dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    func setTimeButtonArray() {
        myButtonArray = []
        let date = Date()
        let calendar = Calendar.current
    //        let year = calendar.component(.year, from: date)
    //        let month = calendar.component(.month, from: date)
    //        let day = calendar.component(.day, from: date)
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        let second = calendar.component(.second, from: date)
        //print("Hours: \(hour) Minutes: \(minute) Second: \(second)")
        
        let formatter = DateFormatter()
        var newDate = calendar.date(bySettingHour: 12, minute: 0, second: 0, of: date)
        
        formatter.dateFormat = "h:mm a"
        
        if(minute < 29) {
//            newDate.year = calendar.component(.year, from: date)
//            newDate.month = calendar.component(.month, from: date)
//            newDate.day = calendar.component(.day, from: date)
//            newDate.hour = calendar.component(.hour, from: date)
//            newDate.minute = 30
            newDate = calendar.date(bySettingHour: calendar.component(.hour, from: date), minute: 30, second: 0, of: date)
        } else {
//            newDate.year = calendar.component(.year, from: date)
//            newDate.month = calendar.component(.month, from: date)
//            newDate.day = calendar.component(.day, from: date)
//            newDate.hour = calendar.component(.hour, from: date) + 1
//            newDate.minute = 0

            newDate = calendar.date(bySettingHour: calendar.component(.hour, from: date) + 1, minute: 0, second: 0, of: date)

        }
        if newDate == nil {
            titleCardLabel.isHidden = false
            titleCardLabel.text = "You can't set a last minute task for today!"
            return
        } else {
            titleCardLabel.isHidden = true
        }
        let dateString = formatter.string(from: newDate!)
        print(dateString)
        
        myButtonArray.append(dateString)
        
        //newDate.minute! += 30
        //print(newDate)
        
        var currentDateString = dateString
        while (true) {
            if (currentDateString != "11:30 PM") {
                newDate = calendar.date(byAdding: .minute, value: 30, to: newDate!)
                let dateString = formatter.string(from: newDate!)
                myButtonArray.append(dateString)
                print("Date string: \(dateString)")
                currentDateString = dateString
            } else {
                break
            }
        }

    }

}
