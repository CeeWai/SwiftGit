//
//  ProjecttaskmemberViewController.swift
//  SwiftProj
//
//  Created by Sebastian on 14/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class ProjecttaskmemberViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var taskmember : [ProjectTaskMember] = []
    var projectItem : Project?
    var projecttask : ProjectTask?
    @IBOutlet var navtitle: UINavigationItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        navtitle.title = projectItem?.projectName!
        taskmember = ProjectTaskMemberDataManager.loadprojecttaskidandprojectid(taskid: (projecttask?.taskid!)!, projectid: (projectItem?.projectId!)!, assign: 1)
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=true
    }
    func tableView(_ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
    return taskmember.count
        
    }
    func tableView(_ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : taskmemberTableViewCell = tableView
        .dequeueReusableCell (withIdentifier: "taskmembercell", for: indexPath)
        as! taskmemberTableViewCell
        let p = taskmember[indexPath.row]
        print(p.username)
        cell.membername.text = p.username
        return cell
        
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
           if(segue.identifier == "seguetotask")
           {
               let detailViewController =
                   segue.destination as!
               projecttaskdetailViewController
               detailViewController.projectItem = projectItem
               detailViewController.projecttask = projecttask!
           }
    }
}
