//
//  DataManager.swift
//  ChongYong_Assignment
//
//  Created by Ong Chong Yong on 29/3/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

class DataManager: NSObject {
    
    static let db = Firestore.firestore()
    
    // Create a new database if it does not already exists
    //
    static func createDatabase()
    {
        SQLiteDB.sharedInstance.execute(sql:
            "CREATE TABLE IF NOT EXISTS " +
                "SavedCountry ( " +
            "country text primary key)")
    }
    
    // Loads the list of movies from the database
    // and convert it into a [Movie] array
    //
    static func loadUsers(onComplete: (([User]) -> Void)?)
    {
        db.collection("users").getDocuments()
            {
                (querySnapshot, err) in
                var userList : [User] = []
                if let err = err{
                    print("Error getting documents: \(err)")
                    
                }
                else
                {
                    for document in querySnapshot!.documents
                    {
                        var user = try? document.data(as:User.self) as! User
                        if user != nil {
                            userList.append(user!)
                        }
                    }
                }
                onComplete?(userList)
        }
    }
    static func loadCountries() -> [SavedCountry]
    {
        let countryRows = SQLiteDB.sharedInstance.query(sql:
            "SELECT country " +
            "FROM SavedCountry")
        var countries : [SavedCountry] = []
        for row in countryRows
        {
            countries.append(SavedCountry(
                country: row["country"] as! String))
        }
        return countries;
    }
    
    static func loadTasks(onComplete: (([Task]) -> Void)?) {
        
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let email = user.email
        }
        
        if user != nil {
            db.collection("tasks").whereField("taskOwner", isEqualTo: user!.email!).getDocuments {
                (querySnapshot, err) in
                var taskList : [Task] = []
                
                if let err = err
                {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents
                    {
                        var task = Task(taskID: "", taskName: "", taskDesc: "", taskStartTime: Date(), taskEndTime: Date(), repeatType: "", taskOwner: "", importance: "", subject: "", lastStartDelayedTime: Date(), lastEndDelayedTime: Date())
                        
                        if let id = document.documentID as? String {
                            //print("document ID: \(document.documentID)")
                            task.taskID = id
                        }
                        
                        if let name = document.data()["taskName"] as? String {
                            task.taskName = name
                        }
                        
                        if let description = document.data()["taskDesc"] as? String {
                            task.taskDesc = description
                        }
                        
                        if let startTime = document.data()["taskStartTime"] as? Timestamp {
                            let date = startTime.dateValue()
                            //print(date)
                            task.taskStartTime = date
                        }
                        
                        if let endtime = document.data()["taskEndTime"] as? Timestamp {
                            let date = endtime.dateValue()
                            //print(date)
                            task.taskEndTime = date
                        }
                        
                        if let repeatType = document.data()["repeatType"] as? String {
                            task.repeatType = repeatType
                        }
                        
                        if let taskOwner = document.data()["taskOwner"] as? String {
                            task.taskOwner = taskOwner
                        }
                        
                        if let importance = document.data()["importance"] as? String {
                            task.importance = importance
                        }
                        
                        if let subject = document.data()["subject"] as? String {
                            task.subject = subject
                        }
                        
                        if let lastStartDelayedTime = document.data()["lastStartDelayedTime"] as? Timestamp {
                            let date = lastStartDelayedTime.dateValue()
                            task.lastStartDelayedTime = date
                        }
                        
                        if let lastEndDelayedTime = document.data()["lastEndDelayedTime"] as? Timestamp {
                            let date = lastEndDelayedTime.dateValue()
                            task.lastEndDelayedTime = date
                        }
                        
                        if task != nil {
                            taskList.append(task)
                        }
                    }
                }
                
                onComplete?(taskList)
                
            }
        }
        
    }
    
    static func loadTasksBySubject(_ subject: String, onComplete: (([Task]) -> Void)?) {
        
        db.collection("tasks").whereField("subject", isEqualTo: subject).getDocuments() {
            (querySnapshot, err) in
            var taskList : [Task] = []
            
            if let err = err
            {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents
                {
                    var task = Task(taskID: "", taskName: "", taskDesc: "", taskStartTime: Date(), taskEndTime: Date(), repeatType: "", taskOwner: "", importance: "", subject: "", lastStartDelayedTime: Date(), lastEndDelayedTime: Date())
                    
                    if let id = document.documentID as? String {
                        //print("document ID: \(document.documentID)")
                        task.taskID = id
                    }
                    
                    if let name = document.data()["taskName"] as? String {
                        task.taskName = name
                    }
                    
                    if let description = document.data()["taskDesc"] as? String {
                        task.taskDesc = description
                    }
                    
                    if let startTime = document.data()["taskStartTime"] as? Timestamp {
                        let date = startTime.dateValue()
                        //print(date)
                        task.taskStartTime = date
                    }
                    
                    if let endtime = document.data()["taskEndTime"] as? Timestamp {
                        let date = endtime.dateValue()
                        //print(date)
                        task.taskEndTime = date
                    }
                    
                    if let repeatType = document.data()["repeatType"] as? String {
                        task.repeatType = repeatType
                    }
                    
                    if let taskOwner = document.data()["taskOwner"] as? String {
                        task.taskOwner = taskOwner
                    }
                    
                    if let importance = document.data()["importance"] as? String {
                        task.importance = importance
                    }
                    
                    if let subject = document.data()["subject"] as? String {
                        task.subject = subject
                    }
                    
                    //print(task)
                    
                    if task != nil {
                        taskList.append(task)
                    }
                }
            }
            
            onComplete?(taskList)
            
        }
        
    }
    
    // Inserts or replaces an existing Task
    // into Firestore.
    //
    static func insertOrReplaceTask(_ task: Task) {
        try? db.collection("tasks")
            .document("\(task.taskID)")
            .setData(from: task, encoder: Firestore.Encoder()) {
                err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document successfully added!")
                }
        }
    }
    
    // Deletes a Task from the Firestore database.
    //
    static func deleteTask(_ task: Task) {
        db.collection("tasks").document(task.taskID).delete() {
            err in
            if let err = err {
                print("Error removing document: \(err)")
            }
            else {
                print("Document successfully removed!")
                
            }
        }
    }
    
    // Load all of the logged in user's Docs from Firebase 
    //
    static func loadDocs(onComplete: (([Document]) -> Void)?) {
        
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let email = user.email
        }
        
        if user != nil {
            db.collection("documentation").whereField("docOwner", isEqualTo: user!.email!).getDocuments {
                (querySnapshot, err) in
                var docList : [Document] = []
                
                if let err = err
                {
                    print("Error getting documents: \(err)")
                } else {
                    for document in querySnapshot!.documents
                    {
                        var doc = Document(docID: "", title: "", body: "", docOwner: "")
                        
                        if let docID = document.documentID as? String {
                            //print("document ID: \(document.documentID)")
                            doc.docID = docID
                        }
                        
                        if let title = document.data()["title"] as? String {
                            doc.title = title
                        }
                    
                        
                        if let body = document.data()["body"] as? String {
                            doc.body = body
                        }
                        
                        if let docOwner = document.data()["docOwner"] as? String {
                            doc.docOwner = docOwner
                        }

                        if doc != nil {
                            docList.append(doc)
                        }
                    }
                }
                
                onComplete?(docList)
                
            }
        }
        
    }

    // Inserts or replaces an existing documentation
    // into Firestore.
    //
    static func insertOrReplaceDoc(_ documentation: Document) {
        try? db.collection("documentation")
            .document(documentation.docID!)
            .setData(from: documentation, encoder: Firestore.Encoder()) {
                err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document successfully added!")
                }
        }
    }
    
}
