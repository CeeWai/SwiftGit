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
    @IBOutlet var membertableview: UITableView!
    var rolelist : [Role] = []
    var memberlist : [Projectgroup] = []
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden=true
        var projectid : Int = (projectItem?.projectId)!
        rolelist = RoleDataManager.loadprojectid(projectid: projectid)
        memberlist = ProjectgroupDataManager.loadsubscribed(projectid: projectid)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        var projectid : Int = (projectItem?.projectId)!
        rolelist = RoleDataManager.loadprojectid(projectid: projectid)
        memberlist = ProjectgroupDataManager.loadsubscribed(projectid: projectid)
        membertableview.reloadData()
       self.navigationController?.isNavigationBarHidden=true
        
        
    }
    override func viewDidAppear(_ animated: Bool) {
        var projectid : Int = (projectItem?.projectId)!
        rolelist = RoleDataManager.loadprojectid(projectid: projectid)
        memberlist = ProjectgroupDataManager.loadsubscribed(projectid: projectid)
        membertableview.reloadData()
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            if tableView == membertableview{
                return memberlist.count
            }
        return 0
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

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
        if(segue.identifier == "seguetoaddmember")
                {
               let detailViewController = segue.destination as!
                addmemberViewController
                   detailViewController.projectItem = self.projectItem
               }
        if(segue.identifier == "seguetodetail")
                       {
                      let detailViewController = segue.destination as!
                       projectdetail1ViewController
                          detailViewController.projectItem = self.projectItem
                      }
        
        
    }
}
