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
    
    // Insert a new movie record, or replace an existing with
    // the same movie ID.
    //
    static func insertOrReplaceMovie(country: SavedCountry)
    {
        SQLiteDB.sharedInstance.execute(sql:
            "INSERT OR REPLACE INTO SavedCountry (country) " +
            "VALUES (?) ",
                                        parameters: [
                                            country.country
            ]
        )
    }
    
    // Deletes an existing movie using the movie
    // object's movieID.
    //
    static func deleteMovie(country: SavedCountry)
    {
        SQLiteDB.sharedInstance.execute(
            sql: "DELETE FROM SavedCountry WHERE country = ?",
            parameters: [country.country])
    }
    
//    static func loadUsers(onComplete: (([User]) -> Void)?) {
//        db.collection("users").getDocuments() {
//            (querySnapshot, err) in
//            
//            var userList
//        }
//    }
    
    static func loadTasks(onComplete: (([Task]) -> Void)?) {
        
        let user = Auth.auth().currentUser
        if let user = user {
          let uid = user.uid
          let email = user.email
        }
        
        print(user!.email!)
        db.collection("tasks").whereField("taskOwner", isEqualTo: user!.email!).getDocuments {
            (querySnapshot, err) in
            var taskList : [Task] = []

            if let err = err
            {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents
                {
                    var task = Task(id: "", name: "", description: "", startTime: Date(), taskEndTime: Date(), repeatType: "", taskOwner: "")

                    if let id = document.documentID as? String {
                        print("document ID: \(document.documentID)")
                        task.taskID = id
                    }
                    
                    if let name = document.data()["taskName"] as? String {
                        task.taskName = name
                    }
                    
                    if let description = document.data()["taskDesc"] as? String {
                        task.taskDesc = description
                    }
                    
                    if let startTime = document.data()["taskStartTime"] as? String {
                        let dateAsString = startTime
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
                        let dateCurrent = dateFormatter.date(from: dateAsString)
                        //print("Changed date: \(startTime)")
                        task.taskStartTime = dateCurrent!
                    }
                    
                    if let endtime = document.data()["taskEndTime"] as? String {
                        let dateAsString = endtime
                        let dateFormatter = DateFormatter()
                        dateFormatter.dateFormat = "dd/MM/yyyy hh:mm a"
                        let dateCurrent = dateFormatter.date(from: dateAsString)
                        //print("Changed date: \(endtime)")
                        task.taskEndTime = dateCurrent!
                    }
                    
                    if let repeatType = document.data()["repeatType"] as? String {
                        task.repeatType = repeatType
                    }
                    
                    if let taskOwner = document.data()["taskOwner"] as? String {
                        task.taskOwner = taskOwner
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
    
     // Inserts or replaces an existing movie
     // into Firestore. //
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
    
     // Deletes a movie from the Firestore database. //
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
    
}
