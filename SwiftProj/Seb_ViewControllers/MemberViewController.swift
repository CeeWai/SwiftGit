//
//  MemberViewController.swift
//  SwiftProj
//
//  Created by Sebastian on 5/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class MemberViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    var projectItem : Project?
    @IBOutlet var roletableview: UITableView!
    @IBOutlet var membertableview: UITableView!
    var rolelist : [Role] = []
    var memberlist : [Projectgroup] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        var projectid : Int = (projectItem?.projectId)!
        rolelist = RoleDataManager.loadprojectid(projectid: projectid)
        memberlist = ProjectgroupDataManager.loadsubscribed(projectid: projectid)

        // Do any additional setup after loading the view.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           if tableView == roletableview{
               return rolelist.count
           }
            if tableView == membertableview{
                return memberlist.count
            }
        return 0
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           if tableView == roletableview{
               let cell : RoleTableViewCell = tableView
               .dequeueReusableCell (withIdentifier: "rolecell", for: indexPath)
               as! 	RoleTableViewCell
               let p = rolelist[indexPath.row]
               cell.rolename.text = p.rolename
               return cell
           }
            if tableView == membertableview{
                let cell : projectmemberTableViewCell = tableView
                .dequeueReusableCell (withIdentifier: "membercell", for: indexPath)
                as!     projectmemberTableViewCell
                let p = memberlist[indexPath.row]
                cell.membername.text = p.username
                return cell
            }
           return UITableViewCell()
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
        if(segue.identifier == "seguetoaddrole")
         {
        let detailViewController = segue.destination as!
         addroleViewController
            detailViewController.projectItem = self.projectItem
        }
        if(segue.identifier == "seguetoaddmember")
                {
               let detailViewController = segue.destination as!
                addmemberViewController
                   detailViewController.projectItem = self.projectItem
               }
         
    }

}
