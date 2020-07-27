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
        noteList = []
        let notesRef = fStore.collection("notes")// change to load only 1 user data
        notesRef.getDocuments(completion: { (snapshot, error) in
             if let error = error {
                    print("Error reading document: \(error)")
                }
             else{
              for doc in (snapshot?.documents)!{
                let currentNote = dom_note(notetitle:  doc.get("title") as? String, notebody:doc.get("body") as? String, notetags:doc.get("tags") as? String, noteUserid: doc.get("uID") as? String, noteid: doc.documentID)
                //print("current Note: " + currentNote.noteTitle! + ", body:" +   currentNote.noteBody!)
                  self.noteList.append(currentNote)
              }
             }
            onComplete?(self.noteList)
          })
    }
    
    func loadSelectedNotes(filter:String?, onComplete: (([dom_note]) -> Void)?){
        noteList = []
        let notesRef = fStore.collection("notes")// change to load only 1 user data
        notesRef.whereField("tags", isEqualTo: filter!).getDocuments(completion: { (snapshot, error) in
             if let error = error {
                    print("Error reading document: \(error)")
                }
             else{
              for doc in (snapshot?.documents)!{
                let currentNote = dom_note(notetitle:  doc.get("title") as? String, notebody:doc.get("body") as? String, notetags:doc.get("tags") as? String, noteUserid: doc.get("uID") as? String, noteid: doc.documentID)
                print("current note tag comparison: ", currentNote.noteTags! + " vs " + filter!)
                  self.noteList.append(currentNote)
              }
             }
            print("filtered noteList count: " + String(self.noteList.count))
            onComplete?(self.noteList)
          })
    }
    
    func loadOneNoteTag(nID:String?, onComplete: ((String) -> Void)?){
        let notesRef = fStore.collection("notes").document(nID!)// change to load only 1 user data
        notesRef.getDocument { (snapshot, error) in
            if let snapshot = snapshot {
                onComplete?(snapshot.get("tags") as! String)
            } else {
                print("Error reading document")
            }
        }
    }//
    
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
    
    func updateTag(noteID:String?, tagStr:String?){
        let noteRef = self.fStore.collection("notes").document(noteID!)
        noteRef.updateData(["tags": tagStr ], completion: { (err) in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            })
        }
    
    func addNote(titleStr:String?, bodyStr:String?, tagStr:String?, uid:String?){
        fStore.collection("notes").addDocument(data: ["title":titleStr , "body":bodyStr, "tags": tagStr  , "uID":uid]){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
        }
  
    
    func updateNote(noteID:String?, titleStr:String?, bodyStr:String?, tagStr:String?){
        let noteRef = self.fStore.collection("notes").document(noteID!)
        noteRef.updateData(["title": titleStr , "body":bodyStr, "tags":tagStr], completion: { (err) in
                if let err = err {
                    print("Error updating document: \(err)")
                } else {
                    print("Document successfully updated")
                }
            })
        }

}
