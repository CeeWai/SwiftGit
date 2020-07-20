//
//  projecttaskdetailViewController.swift
//  SwiftProj
//
//  Created by Sebastian on 9/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class projecttaskdetailViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    @IBOutlet var taskname: UILabel!
    var projectItem : Project?
    var selectedpickervalue = ""
    var selectedpickerrow = 0
    @IBOutlet var startdatelabel: UILabel!
    @IBOutlet var enddatelabel: UILabel!
    var projecttask : ProjectTask?
    @IBOutlet var taskgoal: UITextView!
    @IBOutlet var statuslabel: UILabel!
    @IBOutlet var navtitile: UINavigationItem!
    @IBOutlet var editstatusbtn: UIButton!
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    var statuslist : [String] = ["Pending","Ongoing","Complete"]
    override func viewDidLoad() {
        super.viewDidLoad()
        navtitile.title=projectItem?.projectName!
        taskname.text = projecttask?.taskname!
        print(projecttask?.status)
        if projecttask?.status == 0{
            statuslabel.text = "Pending"
        }
        else if projecttask?.status == 1{
            statuslabel.text = "Ongoing"
        }else{
            statuslabel.text = "Complete"
        }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
      //  print(projecttask?.taskgoal)
        startdatelabel.text = formatter.string(from: (projecttask?.startdate)!)
        enddatelabel.text = formatter.string(from: (projecttask?.enddate)!)
        taskgoal.text = projecttask!.taskgoal!
    }
    

    @IBAction func pressededitstatus(_ sender: Any) {
        picker = UIPickerView.init()
           picker.delegate = self
           picker.dataSource = self
           picker.backgroundColor = UIColor.white
           picker.setValue(UIColor.black, forKey: "textColor")
           picker.autoresizingMask = .flexibleWidth
           picker.contentMode = .center
           picker.frame = CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
           self.view.addSubview(picker)

           toolBar = UIToolbar.init(frame: CGRect.init(x: 0.0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 50))
           toolBar.barStyle = .blackTranslucent
           toolBar.items = [UIBarButtonItem.init(title: "Done", style: .done, target: self, action: #selector(onDoneButtonTapped))]
           self.view.addSubview(toolBar)
    }
    @objc func onDoneButtonTapped() {
        toolBar.removeFromSuperview()
        picker.removeFromSuperview()
        statuslabel.text = selectedpickervalue
        ProjectTaskDataManager.update(taskid: (projecttask?.taskid!)!, status: selectedpickerrow)
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return statuslist.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return statuslist[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedpickervalue = statuslist[row]
        selectedpickerrow = row
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue,
           sender: Any?){
           if(segue.identifier == "seguetotaskmember")
           {
               let detailViewController =
                   segue.destination as!
               ProjecttaskmemberViewController
               detailViewController.projectItem = projectItem
               detailViewController.projecttask = projecttask!
           }
    }
}
