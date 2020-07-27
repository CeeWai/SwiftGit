//
//  NotesTableViewController.swift
//  SwiftProj
//
//  Created by Dom on 5/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SideMenu

class NotesTableViewController: UITableViewController{
    var fStore : Firestore?
    let fsdbManager = dom_FireStoreDataManager()
    @IBOutlet weak var noteListTabBar: UINavigationItem!
    //@IBOutlet var dom_tableView: UITableView!
    var noteList : [dom_note] = []
    var category: String?
    let name = Notification.Name("didReceiveData")
    override func viewDidLoad() {
        super.viewDidLoad()
        fStore = Firestore.firestore()
        UserDefaults.standard.set("All Notes",  forKey: "dom_tag_category") // reset title on 1st load
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        /*fStore?.collection("notes").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }*/

//        let notesRef = fStore?.collection("notes")// change to load only 1 user data
//         notesRef?.getDocuments(completion: { (snapshot, error) in
//             if let error = error {
//                    print("Error reading document: \(error)")
//                }
//             else{
//              for doc in (snapshot?.documents)!{
//                let currentNote = dom_note(notetitle:  doc.get("title") as? String, notebody:doc.get("body") as? String, noteUserid: doc.get("uID") as? String, noteid: doc.documentID)
//                print("viewDidLoad current Note: " + currentNote.noteTitle! + ", body:" +   currentNote.noteBody!)
//                  self.noteList.append(currentNote)
//              }
//             }
//             self.dom_tableView.reloadData()
//          })
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fStore = Firestore.firestore()
        NotificationCenter.default.addObserver(self, selector: #selector(refreshTB), name: NSNotification.Name(rawValue: "updateNoteTable"), object: nil)
        noteList = []
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        /*fStore?.collection("notes").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents {
                    print("\(document.documentID) => \(document.data())")
                }
            }
        }*/
        refreshTB()
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationController?.tabBarController?.tabBar.isHidden = false
    }
    
    // refreshes tableview with all notes or filtered notes
    @objc func refreshTB(){
        category = UserDefaults.standard.string(forKey: "dom_tag_category")
        if let category = category{
            print("catTitle: " + category)
            self.noteList = []
            if (category == "All Notes"){
                noteListTabBar.title = ("Notes")
                fsdbManager.loadNotesDB(){notesList in
                    self.noteList = notesList
                    print("noteList count (normal):" + String(self.noteList.count))
                    self.tableView.reloadData()
                }
            }
            else{
                noteListTabBar.title = ("Notes - " + category)
                fsdbManager.loadSelectedNotes(filter:category){ noteList2 in
                    self.noteList = noteList2
                    print("noteList count (filtered):" + String(self.noteList.count))
                    self.tableView.reloadData()
                }
            }
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.noteList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath)
        cell.textLabel!.text = self.noteList[indexPath.row].noteTitle
        
        // Configure the cell...

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showNote")
         {
            let addNoteViewController = segue.destination as! AddNoteViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            if(myIndexPath != nil) {
                let note = noteList[myIndexPath!.row]
                print("Selected row: " + String(myIndexPath!.row))
                addNoteViewController.currentNote = note
            }
         }
        else if(segue.identifier == "addNote")
         {
            let addNoteViewController = segue.destination as! AddNoteViewController
                addNoteViewController.addNoteBool = true
            
         }
    }
    
    
    @IBAction func sideMenuButtonPressed(_ sender: Any) {
        let menu = storyboard!.instantiateViewController(withIdentifier: "LeftMenu") as! SideMenuNavigationController
        present(menu, animated: true, completion: nil)
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
