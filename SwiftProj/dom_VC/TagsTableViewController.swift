//
//  TagsTableViewController.swift
//  SwiftProj
//
//  Created by Dom on 18/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class TagsTableViewController: UITableViewController {
    var prevNote : dom_note?
    var tagList : [dom_tag] = []
    var isAddNote : Bool?
    let fsdbManager = dom_FireStoreDataManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        

        fsdbManager.loadTagsDB(){tagList in
            self.tagList = tagList
            //print("tagList Count:", tagList.count)
            if self.isAddNote != nil && !self.isAddNote!{ // if its existing note check for duplicate tag and remove it so they cant select it again
                var counter = 0
                self.tagList.forEach(){tag in
                    if tag.tagTitle == self.prevNote?.noteTags{
                        self.tagList.remove(at: counter)//remove the dup tag that's already selected
                        //print(tag.tagTitle! + " vs " + (self.prevNote?.noteTags)!)
                    }
                    counter+=1
                }
            }

            self.tableView.reloadData()
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.tagList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagReuseIdentifier", for: indexPath)
        
        // Configure the cell...
        cell.textLabel!.text = self.tagList[indexPath.row].tagTitle
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(tagList[indexPath.row].tagTitle)
        print(self.isAddNote)
        if self.isAddNote != nil && self.isAddNote!{
            UserDefaults.standard.set(tagList[indexPath.row].tagTitle, forKey: "addNoteTag")
        }
        else{
            fsdbManager.updateTag(noteID: prevNote?.noteID, tagStr: tagList[indexPath.row].tagTitle)
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    //    func tableView(_ tableView: UITableView, didSelectRowAtIndexPath indexPath: IndexPath) {
    //        print(tagList[indexPath.row])
    //        self.navigationController?.popViewController(animated: true)
    //    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if self.isMovingFromParent {
            // for back btn
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
