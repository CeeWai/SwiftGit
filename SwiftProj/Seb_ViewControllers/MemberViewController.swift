////
////  MemberViewController.swift
////  SwiftProj
////
////  Created by Sebastian on 5/7/20.
////  Copyright © 2020 Ong Chong Yong. All rights reserved.
////
//
//import UIKit
//
//class MemberViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
//    var projectItem : Project?
//    @IBOutlet var roletableview: UITableView!
//    var rolelist : [Role] = []
//    
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        var projectid : Int = (projectItem?.projectId)!
//        rolelist = RoleDataManager.loadprojectid(projectid: projectid)
//
//        // Do any additional setup after loading the view.
//    }
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//           if tableView == roletableview{
//               return rolelist.count
//           }
//        return rolelist.count
//       }
//       
//       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//           //if tableView == roletableview{
//               let cell : RoleTableViewCell = tableView
//               .dequeueReusableCell (withIdentifier: "rolecell", for: indexPath)
//               as! 	RoleTableViewCell
//               let p = rolelist[indexPath.row]
//               cell.rolename.text = p.rolename
//               return cell
//           //}
//           //return UITableViewCell()
//       }
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//    override func prepare(for segue: UIStoryboardSegue,
//        sender: Any?){
//        if(segue.identifier == "seguetoaddrole")
//         {
//        let detailViewController = segue.destination as!
//         addroleViewController
//            detailViewController.projectItem = self.projectItem
//        }
//        if(segue.identifier == "seguetoaddmember")
//                {
//               let detailViewController = segue.destination as! addmemberViewController
//                   detailViewController.projectItem = self.projectItem
//               }
//         
//    }
//
//}
