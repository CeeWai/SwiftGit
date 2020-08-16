//
//  addtask2ViewController.swift
//  SwiftProj
//
//  Created by Sebastian on 11/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class addtask2ViewController: UIViewController , UITableViewDelegate, UITableViewDataSource{
    var projecttaskItem : ProjectTask?
    var newprojecttaskItem : [ProjectTask] = []
    var projectItem : Project?
    var userList : [Projectgroup] = []
    var newuserList : [Projectgroup] = []
    @IBOutlet var searchfield: UITextField!
    @IBOutlet var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        userList = ProjectgroupDataManager.loadsubscribed(projectid: projecttaskItem!.projectid!)
        var projectid : Int = projecttaskItem!.projectid!
        var userid : String = projecttaskItem!.userid!
        var taskname : String = projecttaskItem!.taskname!
        var taskgoal: String = projecttaskItem!.taskgoal!
        var startdate : Date = projecttaskItem!.startdate!
        var enddate : Date = projecttaskItem!.enddate!
        var status : Int = projecttaskItem!.status!
        var valid: Int = projecttaskItem!.valid!
        var strstartdate :String = String("\(startdate)".dropLast(6))
        var strenddate :String = String("\(enddate)".dropLast(6))
        searchfield.addTarget(self, action: #selector(addmemberViewController.searchfieldDidchange(_:)),for: .editingChanged)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : addtaskmemberTableViewCell = tableView
        .dequeueReusableCell (withIdentifier: "taskmembercell", for: indexPath)
        as!     addtaskmemberTableViewCell
        let p = userList[indexPath.row]
        cell.usernamelabel.text = p.username
         
        var projectid : Int = projectItem!.projectId!
        if(ProjectTaskMemberDataManager.loadprojecttaskidanduserid(taskid: self.newprojecttaskItem.count+1, userid: p.userid!, assign: 1).isEmpty == false){
             cell.assignbtn.setTitle("assigned", for: .normal)
         }
        cell.buttonPressed = {
            if(ProjectTaskMemberDataManager.loadprojecttaskidanduserid(taskid: self.newprojecttaskItem.count+1, userid: p.userid!, assign: 1).isEmpty){
                ProjectTaskMemberDataManager.insertOrReplace(projecttaskmember: ProjectTaskMember(taskgroupid: 0, projectid: projectid,taskid: self.newprojecttaskItem.count+1, userid: p.userid, username: p.username, assign: 1, valid: 1))
             cell.assignbtn.setTitle("Assigned", for: .normal)
         }
           
        }
        return cell
    }
    
    @IBAction func searchfielddidchange(_ sender: Any) {
        var searchtext : String = searchfield.text!
        newuserList = []
        for i in userList{
            if i.userid!.contains(searchtext){
                newuserList.append(i)
            }
        }
        userList = newuserList
        if searchtext == ""{
             userList = ProjectgroupDataManager.loadsubscribed(projectid: 1)
        }
        self.tableview.reloadData()
    }
    override func prepare(for segue: UIStoryboardSegue,
        sender: Any?){
        if(segue.identifier == "seguetotask")
        {
            let detailViewController =
                segue.destination as!
            projecttaskdetailViewController
            var projecttask : ProjectTask?
            var projectid : Int = projecttaskItem!.projectid!
            var userid : String = projecttaskItem!.userid!
            var taskname : String = projecttaskItem!.taskname!
            var taskgoal: String = projecttaskItem!.taskgoal!
            var startdate : Date = projecttaskItem!.startdate!
            var enddate : Date = projecttaskItem!.enddate!
            var status : Int = projecttaskItem!.status!
            var valid: Int = projecttaskItem!.valid!
            var strstartdate :String = String("\(startdate)".dropLast(6))
            var strenddate :String = String("\(enddate)".dropLast(6))
            projecttask = ProjectTask(taskid: self.newprojecttaskItem.count+1, projectid: projectid, userid: userid, taskname: taskname, taskgoal: taskgoal, startdate: startdate, enddate: enddate, status: status, valid: valid)
                detailViewController.projectItem = projectItem
                detailViewController.projecttask = projecttask!
            
            
        }
    }
}
