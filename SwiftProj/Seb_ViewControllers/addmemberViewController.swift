//
//  addmemberViewController.swift
//  SwiftProj
//
//  Created by Sebastian on 7/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class addmemberViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet var searchfield: UITextField!
    @IBOutlet var tableview: UITableView!
    var userList : [User] = []
    var newuserList : [User] = []
    var projectItem : Project?
    override func viewDidLoad() {
        super.viewDidLoad()
        loaduser()        // Do any additional setup after loading the view.
        searchfield.addTarget(self, action: #selector(addmemberViewController.searchfieldDidchange(_:)),for: .editingChanged)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
           return newuserList.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           let cell : addmemberTableViewCell = tableView
           .dequeueReusableCell (withIdentifier: "usercell", for: indexPath)
           as!     addmemberTableViewCell
           let p = newuserList[indexPath.row]
           cell.username.text = p.username
            
            var projectid : Int = projectItem!.projectId!
            print(projectid)
            if(ProjectgroupDataManager.loadprojectidanduserid(projectid: projectid, userid: p.uid, invited: 1).isEmpty == false){
                cell.invitebtn.setTitle("Invited", for: .normal)
            }
           cell.buttonPressed = {
            if(ProjectgroupDataManager.loadprojectidanduserid(projectid: projectid, userid: p.uid, invited: 1).isEmpty){
                 ProjectgroupDataManager.insertOrReplace(projectgroup: Projectgroup(groupid: 0, projectid: projectid, userid: p.uid, invited: 1, subscribe: 0))
                cell.invitebtn.setTitle("Invited", for: .normal)
            }
              
           }
           return cell
       }
    @IBAction func searchaction(_ sender: Any) {
        
    }
    @objc func searchfieldDidchange(_ textfield:UITextField){
        var searchtext : String = searchfield.text!
        newuserList = []
        for i in userList{
            if i.username.contains(searchtext){
                newuserList.append(i)
                
            }
        }
        self.tableview.reloadData()
    }
    
    func loaduser()
    {
    // This is a special way to call loadMovies. //
    // Even if loadMovies accepts a closure as a
    // parameter, I can pass that parameter after
    // the round brackets. In a way it is
    // easier to read.
    DataManager.loadUsers() {
        userListFromFirestore in
    // This is a closure. //
    // This block of codes is executed when the
    // async loading from Firestore is complete.
    // What it is to reassigned the new list loaded
    // from Firestore.
    
        self.userList = userListFromFirestore
    // Once done, call on the Table View to reload // all its contents
        }
    }
}
