//
//  projectnotificationViewController.swift
//  SwiftProj
//
//  Created by Sebastian on 8/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import FirebaseAuth
class projectnotificationViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {
    var inviteList : [Projectgroup] = []
    var projectList : [Project] = []
    var projectItem : Project?
    var currentuser = ""
    @IBOutlet var tableview: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden=true
        currentuser = Auth.auth().currentUser?.uid as! String
        inviteList = ProjectgroupDataManager.loadbyprojectuseridwhensubscribe0(userid: currentuser)
        // Do any additional setup after loading the view.
        self.tableview.reloadData()
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=true
    }
    func refresh(){
        inviteList = ProjectgroupDataManager.loadbyprojectuseridwhensubscribe0(userid: currentuser)
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
        cell.textview.text = "\(p.username!) has invited you to join \(projectList[0].projectName!)."
            
           cell.acceptbuttonPressed = {
            var newprojectgroup : Projectgroup = Projectgroup(groupid: p.groupid, projectid: p.projectid, userid: p.userid!,username: p.username!,role:p.role, invited: 1, subscribe: 1)
            ProjectgroupDataManager.Replaceinvitedorsubscribe(projectgroup: newprojectgroup)
            self.refresh()
           }
            cell.declinebuttonPressed = {
                var newprojectgroup : Projectgroup = Projectgroup(groupid: p.groupid, projectid: p.projectid, userid: p.userid!,username: p.username!,role: p.role, invited: 0, subscribe: 0)
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
