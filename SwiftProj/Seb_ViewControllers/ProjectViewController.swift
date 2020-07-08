//
//  ProjectViewController.swift
//  Taskr
//
//  Created by Sebastian on 22/6/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import UIKit

class ProjectViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {
    var projectList : [Project] = []
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden=true
        RoleDataManager.createDatabase()
        ProjectDataManager.createDatabase()
        ProjectgroupDataManager.createDatabase()
        //projectList.append(Project(projectId: "d", projectName: "d", projectLeader: "d", projectDescription:"d", imageName: "d"))
        projectList = ProjectDataManager.loadProjects()

        
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
    }
}


