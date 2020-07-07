//
//  addmemberViewController.swift
//  SwiftProj
//
//  Created by Sebastian on 7/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class addmemberViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newuserList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : RoleTableViewCell = tableView
        .dequeueReusableCell (withIdentifier: "usercell", for: indexPath)
        as!     RoleTableViewCell
        let p = newuserList[indexPath.row]
        cell.rolename.text = p.username
        return cell
    }
    

    @IBOutlet var searchfield: UITextField!
    @IBOutlet var tableview: UITableView!
    var userList : [User] = []
    var newuserList : [User] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        loaduser()        // Do any additional setup after loading the view.
        searchfield.addTarget(self, action: #selector(addmemberViewController.searchfieldDidchange(_:)),for: .editingChanged)
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
