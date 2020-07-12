//
//  projectnotificationViewController.swift
//  SwiftProj
//
//  Created by Sebastian on 8/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class projectnotificationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var inviteList : [Projectgroup] = []
    var projectList : [Project] = []
    var projectItem : Project?

    @IBOutlet var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        inviteList = ProjectgroupDataManager.loadbyprojectuseridwhensubscribe0(userid: "1nC1S8cngKXT2da4CmaiV2sb4Ia2")
        // Do any additional setup after loading the view.
        self.tableview.reloadData()
    }
    func refresh(){
        inviteList = ProjectgroupDataManager.loadbyprojectuseridwhensubscribe0(userid: "1nC1S8cngKXT2da4CmaiV2sb4Ia2")
        // Do any additional setup after loading the view.
        self.tableview.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        inviteList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : invitationnotiTableViewCell = tableView
           .dequeueReusableCell (withIdentifier: "invitecell", for: indexPath)
           as!     invitationnotiTableViewCell
           let p = inviteList[indexPath.row]
        projectList = ProjectDataManager.loadProjectsbyid(projectid: (p.projectid)!)
        let dataDecoded:NSData = NSData(base64Encoded:projectList[0].imageName!, options: .ignoreUnknownCharacters)!
        let decodedimage:UIImage = UIImage(data: dataDecoded as Data)!
        cell.imageview.image = decodedimage
        cell.textview.text = "\(p.userid) has invited you to join \(projectList[0].projectName!)."
            
           cell.acceptbuttonPressed = {
            var newprojectgroup : Projectgroup = Projectgroup(groupid: p.groupid, projectid: p.projectid, userid: p.userid, invited: 1, subscribe: 1)
            ProjectgroupDataManager.Replaceinvitedorsubscribe(projectgroup: newprojectgroup)
            self.refresh()
           }
            cell.declinebuttonPressed = {
             var newprojectgroup : Projectgroup = Projectgroup(groupid: p.groupid, projectid: p.projectid, userid: p.userid, invited: 0, subscribe: 0)
             ProjectgroupDataManager.Replaceinvitedorsubscribe(projectgroup: newprojectgroup)
                self.refresh()
            }
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

}
