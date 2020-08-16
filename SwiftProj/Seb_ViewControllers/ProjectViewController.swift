//
//  ProjectViewController.swift
//  Taskr
//
//  Created by Sebastian on 22/6/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import UIKit
import FirebaseAuth
class ProjectViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var projectList : [Project] = []
    var projectgroupList : [Projectgroup] = []
    var inviteList : [Projectgroup] = []
    @IBOutlet var tableView: UITableView!
    
    @IBOutlet weak var addbtn: UIButton!
    @IBOutlet var bell: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden=true
        addbtn.layer.cornerRadius = 40
        addbtn.layer.borderColor = UIColor.systemRed.cgColor
        addbtn.layer.borderWidth = 2;
        addbtn.layer.backgroundColor = UIColor.systemBackground.cgColor
        addbtn.imageEdgeInsets = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
        RoleDataManager.createDatabase()
        ProjectDataManager.createDatabase()
        ProjectgroupDataManager.createDatabase()
        ProjectTaskDataManager.createDatabase()
        ProjectTaskMemberDataManager.createDatabase()
        ProjectEventDataManager.createDatabase()
        //projectList.append(Project(projectId: "d", projectName: "d", projectLeader: "d", projectDescription:"d", imageName: "d"))
        let currentuser = Auth.auth().currentUser
        if (currentuser != nil) {
            //projectgroupList = ProjectgroupDataManager.loadbyprojectuseridwhensubscribe0(userid: currentuser!.uid)
        
        projectgroupList = ProjectgroupDataManager.loadbyprojectuseridwhensubscribe1(userid: currentuser!.uid)
        if projectgroupList.isEmpty{
        }
        else{
            for project in projectgroupList{
                var projectitem: [Project] = ProjectDataManager.loadProjectsbyid(projectid: project.projectid!)
                projectList.append(projectitem[0])
            }
        }
        inviteList = ProjectgroupDataManager.loadbyprojectuseridwhensubscribe0(userid: currentuser!.uid)
        }
        if inviteList.count > 0{
            
        }
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=true
    }
    override func viewDidDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=false
    }
    func tableView(_ tableView: UITableView,
    numberOfRowsInSection section: Int) -> Int {
    return projectList.count
        
    }
    func tableView(_ tableView: UITableView,
    cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell : ProjectCellTableViewCell = tableView
        .dequeueReusableCell (withIdentifier: "ProjectCell", for: indexPath)
        as! ProjectCellTableViewCell
        let p = projectList[indexPath.row]
        cell.projectnameLabel.text = p.projectName
        cell.projectleaderLabel.text = p.projectLeader
        let dataDecoded:NSData = NSData(base64Encoded:p.imageName!, options: .ignoreUnknownCharacters)!
        let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
        cell.projectImageView.image = decodedimage
        return cell
        
    }
    override func prepare(for segue: UIStoryboardSegue,
    sender: Any?){
        if(segue.identifier == "projectdetail1")
        {
            let detailViewController =
                segue.destination as!
            projectdetail1ViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            if(myIndexPath != nil)
            {
                // Set the movieItem field with the movie
                // object selected by the user.
                //
                let project : Project = projectList[myIndexPath!.row]
                detailViewController.projectItem = project
            
            }
        }
        if(segue.identifier == "seguetonoti")
         {
            let detailViewController = segue.destination as! projectnotificationViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            if(myIndexPath != nil)
            {
                // Set the movieItem field with the movie
                // object selected by the user.
                //
                let project : Project = projectList[myIndexPath!.row]
                detailViewController.projectItem = project
            }
        }
    }
}


