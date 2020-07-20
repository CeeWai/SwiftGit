//
//  memberdetailViewController.swift
//  SwiftProj
//
//  Created by Sebastian on 15/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class memberdetailViewController: UIViewController,
UITableViewDelegate, UITableViewDataSource ,UIPickerViewDelegate, UIPickerViewDataSource{
    var popoverstatus = 0;
    var projectItem : Project?
    var projectgroup : Projectgroup?
    var ongoingtasklist : [ProjectTask] = []
    var tasklist : [ProjectTaskMember] = []
    var singletasklist : [ProjectTask] = []
    @IBOutlet var ongoingtasknolabel: UILabel!
    @IBOutlet var membernamelabel: UILabel!
    @IBOutlet var rolelabel: UILabel!
    @IBOutlet var tableview: UITableView!
    var toolBar = UIToolbar()
    var picker  = UIPickerView()
    var selectedpickervalue = ""
    var selectedpickerrow = 0
    var rolelist :[Role] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        membernamelabel.text = projectgroup?.username!
        rolelabel.text = projectgroup?.role!
        selectedpickervalue = (projectgroup?.role!)!
        tasklist = ProjectTaskMemberDataManager.loadbyprojecttaskmemberwhenprojectidanduserid(projectid: (projectItem?.projectId!)!, userid: (projectgroup?.userid!)!)
        for item in tasklist{
            singletasklist = ProjectTaskDataManager.loadtaskbyid(taskid: item.taskid!)
            ongoingtasklist.append(singletasklist[0])
            print(singletasklist[0].taskid!)
        }
        ongoingtasknolabel.text = "Ongoing Task(\(ongoingtasklist.count))"
        rolelist = RoleDataManager.loadprojectid(projectid: (projectItem?.projectId!)!)
        if rolelist.isEmpty{
            
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           var listcount : Int = 0
           if tableView == tableview{
               listcount = ongoingtasklist.count
           }
           return listcount
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell : taskTableViewCell = tableView
           .dequeueReusableCell (withIdentifier: "TaskCell", for: indexPath)
           as!     taskTableViewCell
           if tableView == tableview{
                             let p = ongoingtasklist[indexPath.row]
                             cell.tasknem.text = p.taskname!
           }
           return cell
       }
 
    @IBOutlet var popover: UIView!
    @IBAction func popovermenu(_ sender: Any) {
        //popover.frame.origin.x = CGFloat(10.0)
        //popover.frame.origin.x = CGFloat(44.0)
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
                    popover.heightAnchor.constraint(equalToConstant:35),
        
                    //8
                    popover.widthAnchor.constraint(equalToConstant: 300)
                ])
            popoverstatus = 1
        }
        
        
    }
    
    @IBAction func pressedchangerole(_ sender: Any) {
        popover.removeFromSuperview()
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
            rolelabel.text = selectedpickervalue
            ProjectgroupDataManager.update(projectid: (projectItem?.projectId!)!,userid:(projectgroup?.userid!)!, role: selectedpickervalue)
            print(selectedpickervalue)
        }
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }

        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return rolelist.count
        }

        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
            return rolelist[row].rolename
        }

        func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
            selectedpickervalue = rolelist[row].rolename!
            print(row)
            selectedpickerrow = row
        }
    override func prepare(for segue: UIStoryboardSegue,
          sender: Any?){
          if(segue.identifier == "seguetotask")
          {
              let detailViewController =
                  segue.destination as!
              projecttaskdetailViewController
              var myIndexPath : IndexPath?
              var projecttask : ProjectTask?
              myIndexPath = self.tableview.indexPathForSelectedRow
              projecttask = ongoingtasklist[myIndexPath!.row]
              if(myIndexPath != nil)
              {
                  // Set the movieItem field with the movie
                  // object selected by the user.
                  //
                  detailViewController.projectItem = projectItem
                  detailViewController.projecttask = projecttask!
              
              }
          }
            if(segue.identifier == "seguetomemberview")
                    {
                   let detailViewController = segue.destination as!
                    MemberViewController
                       detailViewController.projectItem = self.projectItem
                   }
      }
}
