//
//  TagsTableViewController.swift
//  SwiftProj
//
//  Created by Dom on 18/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import FirebaseAuth

extension TagsTableViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    let searchBar = searchController.searchBar
    filterContentForSearchText(searchBar.text!)
  }
}

class TagsTableViewController: UITableViewController {
    var prevNote : dom_note?
    var tagList : [dom_tag] = []
    var isAddNote : Bool = true
    let fsdbManager = dom_FireStoreDataManager()
    var isMainMenu: Bool = false
    let searchController = UISearchController(searchResultsController: nil)
    var filteredTags: [dom_tag] = []
    var isSearchBarEmpty: Bool {
      return searchController.searchBar.text?.isEmpty ?? true
    }
    func filterContentForSearchText(_ searchText: String) {
      filteredTags = tagList.filter { (tag: dom_tag) -> Bool in
        return tag.tagTitle!.lowercased().contains(searchText.lowercased())
      }
      
        self.tableView.reloadData()
    }
    var isFiltering: Bool {
      return searchController.isActive && !isSearchBarEmpty
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // 1
        searchController.searchResultsUpdater = self
        // 2
        searchController.obscuresBackgroundDuringPresentation = false
        // 3
        searchController.searchBar.placeholder = "Search Tags"
        // 4
        navigationItem.searchController = searchController
        // 5
        definesPresentationContext = true
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        if isMainMenu{
            self.navigationController?.navigationBar.isHidden = false
            self.navigationController?.tabBarController?.tabBar.isHidden = true
            self.navigationController?.toolbar.isHidden = false
            print("isMainMenu: " + String(isMainMenu))
        }
        
        fsdbManager.loadTagsDB(){tagList in
            self.tagList = tagList
            //print("tagList Count:", tagList.count)
            if self.isMainMenu{
            // if it's from tag edit btn aka main menu LOAD EVERYTHING
            }
            else if !self.isAddNote{
                 // if its from existing note check for duplicate tag and remove it so they cant select it again
                    var counter = 0
                    self.tagList.forEach(){tag in
                        print(tag.tagTitle! + " vs " + (self.prevNote?.noteTags)!)
                        if tag.tagTitle == self.prevNote?.noteTags{
                            self.tagList.remove(at: counter)//remove the dup tag that's already selected
                            
                        }
                        counter+=1
                    }
            }
            
            self.tableView.reloadData()
        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    @IBAction func addTagsButnPressed(_ sender: Any) {
        let addTagAlert = UIAlertController(title: "Add Tag", message: "Add a new tag to the list of tags.", preferredStyle: UIAlertController.Style.alert)
        addTagAlert.addTextField { (textField) in
            textField.placeholder = "Tag name"
        }
        addTagAlert.addAction(UIAlertAction(title: "Add Tag", style: .default, handler: { (action: UIAlertAction!) in
            var userID = ""
            let textField = addTagAlert.textFields![0]
            let user = Auth.auth().currentUser
            if let user = user {
                userID = user.uid
            }
            var isDupe = false
            self.tagList.forEach(){tag in
                if tag.tagTitle?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines) == textField.text?.lowercased().trimmingCharacters(in: .whitespacesAndNewlines){
                    isDupe = true
                }
            }
            if isDupe{
                let addTagAlertError = UIAlertController(title: "Duplicate Tag", message: "A tag with this name already exists!", preferredStyle: UIAlertController.Style.alert)
                addTagAlertError.addAction(UIAlertAction(title: "ok", style: .destructive, handler: { (action: UIAlertAction!) in
                    
                }))
                self.present(addTagAlertError, animated: true, completion: nil)
            }
            else{
                self.fsdbManager.addTag(titleStr: textField.text, uid: userID)
                self.fsdbManager.loadTagsDB(){tagList in
                    self.tagList = []
                    self.tagList = tagList
                    //print("tagList Count:", tagList.count)
                    if !self.isAddNote{ // if its from existing note check for duplicate tag and remove it so they cant select it again
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
            }
            
        }))
        
        addTagAlert.addAction(UIAlertAction(title: "cancel", style: .destructive, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(addTagAlert, animated: true, completion: nil)
    }
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if isFiltering {
          return filteredTags.count
        }
        return self.tagList.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tagReuseIdentifier", for: indexPath)
        
        // Configure the cell...
         if isFiltering {
            cell.textLabel!.text = self.filteredTags[indexPath.row].tagTitle
        }
         else{
            cell.textLabel!.text = self.tagList[indexPath.row].tagTitle
        }
        
        if self.isMainMenu{
            cell.selectionStyle = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // print(tagList[indexPath.row].tagTitle)
        //print(self.isAddNote)
        if self.isMainMenu{
            //print("mainmenu triggered")
            UserDefaults.standard.set(tagList[indexPath.row].tagTitle, forKey: "dom_tag_category_mainmenu")
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: "updateNoteTableTagMenu"), object: nil)
        }
        else if self.isAddNote{
             if isFiltering {
                UserDefaults.standard.set(filteredTags[indexPath.row].tagTitle, forKey: "addNoteTag")
            }
             else{
                UserDefaults.standard.set(tagList[indexPath.row].tagTitle, forKey: "addNoteTag")
            }
        }
        else{
             if isFiltering {
                fsdbManager.updateTag(noteID: prevNote?.noteID, tagStr: filteredTags[indexPath.row].tagTitle)
            }
             else{
                fsdbManager.updateTag(noteID: prevNote?.noteID, tagStr: tagList[indexPath.row].tagTitle)
            }
            
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
            if isMainMenu{
                self.navigationController?.navigationBar.isHidden = true
                self.navigationController?.tabBarController?.tabBar.isHidden = false
                self.navigationController?.toolbar.isHidden = true
                //print("isMainMenu: " + String(isMainMenu))
            }
        }
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            fsdbManager.deleteTag(tagTitle: self.tagList[indexPath.row].tagTitle)
            self.tagList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)

        }
    }
    
    
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
