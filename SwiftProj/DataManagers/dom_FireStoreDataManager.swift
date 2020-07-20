//
//  dom_FireStoreDataManager.swift
//  SwiftProj
//
//  Created by Dom on 18/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth

class dom_FireStoreDataManager: NSObject {
var fStore = Firestore.firestore()
var noteList : [dom_note] = []
var tagList : [dom_tag] = []
    
    
    func loadNotesDB(onComplete: (([dom_note]) -> Void)?){
        let notesRef = fStore.collection("notes")// change to load only 1 user data
        notesRef.getDocuments(completion: { (snapshot, error) in
             if let error = error {
                    print("Error reading document: \(error)")
                }
             else{
              for doc in (snapshot?.documents)!{
                let currentNote = dom_note(notetitle:  doc.get("title") as? String, notebody:doc.get("body") as? String, noteUserid: doc.get("uID") as? String, noteid: doc.documentID)
                //print("current Note: " + currentNote.noteTitle! + ", body:" +   currentNote.noteBody!)
                  self.noteList.append(currentNote)
              }
             }
            onComplete?(self.noteList)
          })
    }
    
    func loadTagsDB(onComplete: (([dom_tag]) -> Void)?){
        let notesRef = fStore.collection("notes_tags")
        notesRef.getDocuments(completion: { (snapshot, error) in
             if let error = error {
                    print("Error reading document: \(error)")
                }
             else{
              for doc in (snapshot?.documents)!{
                let currentTag = dom_tag(tagtitle: doc.get("title") as? String)
                  self.tagList.append(currentTag)
              }
             }
            onComplete?(self.tagList)
          })
    }
}
