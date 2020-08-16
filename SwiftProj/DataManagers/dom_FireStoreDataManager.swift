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
import FirebaseStorage
import AVFoundation

class dom_FireStoreDataManager: NSObject {
    var fStore = Firestore.firestore()
    var noteList : [dom_note] = []
    var tagList : [dom_tag] = []
    let user = Auth.auth().currentUser
    
    // Get a reference to the storage service using the default Firebase App
    let storage = Storage.storage()
    
//    func pin(nID:String?){
//
//    }
    
    func addAudioLog(fileName:String, url:URL, onComplete: ((URL) -> Void)?){
        // Create a root reference
        let storageRef = storage.reference()
        print("fileName: " + fileName)
        print("URL: " + url.absoluteString)
        
        let memoRef = storageRef.child(fileName)
        
        
        let uploadTask = memoRef.putFile(from: url, metadata: nil) { metadata, error in
            guard let metadata = metadata else {
                // Uh-oh, an error occurred!
                return
            }
            // Metadata contains file metadata such as size, content-type.
            let size = metadata.size
            // You can also access to download URL after upload.
            memoRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                    // Uh-oh, an error occurred!
                    return
                }
                onComplete!(downloadURL)
            }
        }
    }
    
    func retrieveAudioLog(memoName:String, onComplete: ((URL) -> Void)?){
        let storageRef = storage.reference()
        let memoRef = storageRef.child(memoName)
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let localURL = documentsDirectory.appendingPathComponent(memoName)
        
        // Download to the local filesystem
        let downloadTask = memoRef.write(toFile: localURL) { url, error in
            if let error = error {
                print(error)
                // Uh-oh, an error occurred!
            } else {
                
            }
        }
    }
    
    func deleteAudioLog(memoName:String){
        let storageRef = storage.reference()
        // Create a reference to the file to delete
        let memoRef = storageRef.child(memoName)
        
        // Delete the file
        memoRef.delete { error in
            if let error = error {
                print(error)
                // Uh-oh, an error occurred!
            } else {
                // File deleted successfully
            }
        }
    }
    
    func loadNotesDB(onComplete: (([dom_note]) -> Void)?){
        noteList = []
        let notesRef =  self.fStore.collection("notes").whereField("uID" , isEqualTo: user?.uid)// change to load only 1 user data
        notesRef.getDocuments(completion: { (snapshot, error) in
            if let error = error {
                print("Error reading document: \(error)")
            }
            else{
                self.noteList = []
                for doc in (snapshot?.documents)!{
                    let currentNote = dom_note(notetitle:  doc.get("title") as? String, notebody:doc.get("body") as? String, notetags:doc.get("tags") as? String, noteUserid: doc.get("uID") as? String, noteid: doc.documentID, noteupdateDate: doc.get("noteUpdateDate") as? String)
                    //print("current Note: " + currentNote.noteTitle! + ", body:" +   currentNote.noteBody!)
                    self.noteList.append(currentNote)
                }
            }
            onComplete?(self.noteList)
        })
    }
    
    func loadSelectedNotes(filter:String?, onComplete: (([dom_note]) -> Void)?){
        noteList = []
         let notesRef =  self.fStore.collection("notes").whereField("uID" , isEqualTo: user?.uid)// change to load only 1 user data
        notesRef.whereField("tags", isEqualTo: filter!).getDocuments(completion: { (snapshot, error) in
            if let error = error {
                print("Error reading document: \(error)")
            }
            else{
                self.noteList = []
                for doc in (snapshot?.documents)!{
                    let currentNote = dom_note(notetitle:  doc.get("title") as? String, notebody:doc.get("body") as? String, notetags:doc.get("tags") as? String, noteUserid: doc.get("uID") as? String, noteid: doc.documentID, noteupdateDate: doc.get("noteUpdateDate") as? String)
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
    }
    
    func loadTagsDB(onComplete: (([dom_tag]) -> Void)?){
        let notesRef = self.fStore.collection("notes_tags").whereField("uID" , isEqualTo: user?.uid)
        notesRef.getDocuments(completion: { (snapshot, error) in
            if let error = error {
                print("Error reading document: \(error)")
            }
            else{
                self.tagList = []
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
    
    
    
    func addNote(titleStr:String?, bodyStr:String?, tagStr:String?, uid:String?, noteUpdateDate:String?){
        fStore.collection("notes").addDocument(data: ["title":titleStr , "body":bodyStr, "tags": tagStr  , "uID":uid, "noteUpdateDate":noteUpdateDate]){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    func addTag(titleStr:String?, uid:String?){
        fStore.collection("notes_tags").addDocument(data: ["title":titleStr , "uID":uid]){ err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    
    func updateNote(noteID:String?, titleStr:String?, bodyStr:String?, tagStr:String?, noteUpdateDate:String?){
        let noteRef = self.fStore.collection("notes").document(noteID!)
        noteRef.updateData(["title": titleStr , "body":bodyStr, "tags":tagStr, "noteUpdateDate":noteUpdateDate ], completion: { (err) in
            if let err = err {
                print("Error updating Note: \(err)")
            } else {
                print("Note successfully updated")
            }
        })
    }
    
    func deleteNote(noteID:String?){
        let noteRef = self.fStore.collection("notes").document(noteID!)
        noteRef.delete( completion: { (err) in
            if let err = err {
                print("Error deleting Note: \(err)")
            } else {
                print("Note successfully deleted")
            }
            
        })
    }
    
    func deleteTag(tagTitle:String?){
        self.fStore.collection("notes").whereField("tags" , isEqualTo: tagTitle).getDocuments { (QuerySnapshot, Error) in
            for document in QuerySnapshot!.documents {
                //print("documentid: " + document.documentID)
                let noteRef = self.fStore.collection("notes").document(document.documentID)
                noteRef.updateData(["tags" : ""], completion: { (err) in
                           if let err = err {
                               print("Error reseting tags of notes: \(err)")
                           } else {
                               print("reseted tags of notes")
                           }
                       })
            }
        }
        
        self.fStore.collection("notes_tags").whereField("title" , isEqualTo: tagTitle).getDocuments { (QuerySnapshot, Error) in
            for document in QuerySnapshot!.documents {
                self.fStore.collection("notes_tags").document(document.documentID).delete( completion: { (err) in
                    if let err = err {
                        print("Error removing tag: \(err)")
                    } else {
                        print("Tag successfully removed")
                    }
                }
                )
            }
            
        }
        
    }
}
