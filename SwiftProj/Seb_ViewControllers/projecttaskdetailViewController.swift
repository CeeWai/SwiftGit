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
    var projecttask : ProjectTask?
    @IBOutlet weak var duedate: UILabel!
    @IBOutlet var taskgoal: UITextView!
    @IBOutlet var statuslabel: UILabel!
    @IBOutlet var navtitile: UINavigationItem!
    @IBOutlet var editstatusbtn: UIButton!
    var popoverstatus = 0
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    var statuslist : [String] = ["Pending","Ongoing","Complete"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden=true
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "dismisspopover")
        view.addGestureRecognizer(tap)
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
        
         
      if projecttask?.enddate != nil{
                             var duedates = projecttask?.enddate!
                             duedate.text = formatter.string(from: duedates!)
                            }else{
                             duedate.text = ""
        }
        taskgoal.text = projecttask!.taskgoal!
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=true
    }
    @objc func dismisspopover() {
        popover.removeFromSuperview()
        if popover.isDescendant(of: view){
            popover.removeFromSuperview()
        }
    }
    @IBOutlet var popover: UIView!
    @IBAction func popoverpressed(_ sender: Any) {
        if popoverstatus == 1{
                                 self.popover.removeFromSuperview()
                                 popoverstatus = 0
                             }
                             if popoverstatus == 0{
                                 self.view.addSubview(popover)
                                 let superView = self.view.superview
                                 superView!.addSubview(popover)
                                 popover.translatesAutoresizingMaskIntoConstraints = false

                                 NSLayoutConstraint.activate([

                                         // 5
                                         NSLayoutConstraint(item: popover, attribute: .top, relatedBy: .equal, toItem: superView, attribute: .top, multiplier: 1.0, constant: 60),

                                         // 6
                                         NSLayoutConstraint(item: popover, attribute: .right, relatedBy: .equal, toItem: superView, attribute: .right, multiplier: 1.0, constant: 160),

                                         // 7
                                         popover.heightAnchor.constraint(equalToConstant:80),
                             
                                         //8
                                         popover.widthAnchor.constraint(equalToConstant: 300)
                                     ])
                                 popoverstatus = 1
    }
    }
    
    @IBAction func deletetask(_ sender: Any) {
        ProjectTaskDataManager.delete(projecttask: projecttask!)
        guard let optionsVC = UIStoryboard(name: "Seb_Main", bundle: nil).instantiateViewController(withIdentifier: "detailtodo") as? projectdetail1ViewController else {
            return
        }
        optionsVC.projectItem = projectItem
        optionsVC.modalPresentationStyle = .fullScreen
        self.present(optionsVC, animated: true, completion: nil)
        
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
        if(segue.identifier == "seguetoprojectdetail")
         {
        let detailViewController = segue.destination as!
         projectdetail1ViewController
            detailViewController.projectItem = self.projectItem
        }
        if(segue.identifier == "seguetoeditmemo")
                {
               let detailViewController = segue.destination as!
                addtask1ViewController
                   detailViewController.projectItem = self.projectItem
                   detailViewController.projecttask = self.projecttask
                   detailViewController.seguetype = "update"
               }
    }
}
