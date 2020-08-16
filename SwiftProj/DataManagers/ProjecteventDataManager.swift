//
//  ProjectEventDataManager.swift
//  SwiftProj
//
//  Created by Sebastian on 26/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class ProjectEventDataManager: NSObject {
        static func createDatabase()
        {
         SQLiteDB.sharedInstance.execute(sql:
            "CREATE TABLE IF NOT EXISTS " +
            "Projectevent ( " +
            " projecteventid INTEGER primary key AUTOINCREMENT, " +
            " taskid INTEGER, " +
            " projectid INTEGER, " +
                " title text, " +
            " startdate text, enddate text," +
            " location text," +
            " isallday INTEGER)")
        }
        
        static func loadProjectevents() -> [AllDayEvent]
        {
            let projecteventRows = SQLiteDB.sharedInstance.query(sql:
                "SELECT projecteventid, taskid, " + "projectid,title,startdate, enddate,location,isallday" + " FROM Projectevent")
        var projectevents : [AllDayEvent] = []
            for row in projecteventRows
        {
                var bool = true
                   if row["isallday"] as! Int == 1{
                       bool = false
                       
                   }
                   projectevents.append(AllDayEvent(
                       id: row["projecteventid"] as! String,
                       taskid: row["taskid"] as! Int,
                       projectid: row["projectid"] as! Int,
                       title: row["title"] as! String,
                       startDate: ["startdate"] as! Date,
                       endDate: row["enddate"] as! Date,
                       location: row["location"] as! String,
                       isAllDay: bool))
        }
            return projectevents;
        }
        static func loadProjecteventsbyid(projecteventid:Int) -> [AllDayEvent]
        {
            let projecteventRows = SQLiteDB.sharedInstance.query(sql:
                "SELECT projecteventid, taskid, " + "projectid,title, startdate,enddate,location,isallday" + " FROM Projectevent Where projecteventid = \(projecteventid)")
            var projectevents : [AllDayEvent] = []
            for row in projecteventRows
        {
            var bool = true
            if row["isallday"] as! Int == 0{
                bool = false
                
            }
            projectevents.append(AllDayEvent(
                id: row["projecteventid"] as! String,
                taskid: row["taskid"] as! Int,
                projectid: row["projectid"] as! Int,
                title: row["title"] as! String,
                startDate: ["startdate"] as! Date,
                endDate: row["enddate"] as! Date,
                location: row["location"] as! String,
                isAllDay: bool))
        }
            return projectevents;
        }
    static func loadProjecteventsbyprojectid(projectid:Int) -> [AllDayEvent]
    {
        let projecteventRows = SQLiteDB.sharedInstance.query(sql:
            "SELECT projecteventid, taskid, " + "projectid,title, startdate,enddate,location,isallday" + " FROM Projectevent Where projectid = \(projectid)")
        var projectevents :	 [AllDayEvent] = []
        for row in projecteventRows
    {
        var bool = true
        if row["isallday"] as! Int == 0{
            bool = false
            
        }
        var idint = row["projecteventid"] as! Int
        let formmater = DateFormatter()
        let startdateString  = row["startdate"] as! String + " +0000"
        let enddateString  = row["enddate"] as! String + " +0000"
        formmater.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        projectevents.append(AllDayEvent(
            id: String(idint),
            taskid: row["taskid"] as! Int,
            projectid: row["projectid"] as! Int,
            title: row["title"] as! String,
            startDate: formmater.date(from: startdateString) as! Date,
            endDate: formmater.date(from: enddateString) as! Date,
            location: row["location"] as! String,
            isAllDay: bool))
    }
        return projectevents;
    }
    static func loadProjecteventsbyprojectidin(projectid:String) -> [AllDayEvent]
       {
           let projecteventRows = SQLiteDB.sharedInstance.query(sql:
               "SELECT projecteventid, taskid, " + "projectid,title, startdate,enddate,location,isallday" + " FROM Projectevent Where projectid IN (\(projectid))")
           var projectevents :     [AllDayEvent] = []
           for row in projecteventRows
       {
           var bool = true
           if row["isallday"] as! Int == 0{
               bool = false
               
           }
           var idint = row["projecteventid"] as! Int
           let formmater = DateFormatter()
           let startdateString  = row["startdate"] as! String + " +0000"
           let enddateString  = row["enddate"] as! String + " +0000"
           formmater.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
           projectevents.append(AllDayEvent(
               id: String(idint),
               taskid: row["taskid"] as! Int,
               projectid: row["projectid"] as! Int,
               title: row["title"] as! String,
               startDate: formmater.date(from: startdateString) as! Date,
               endDate: formmater.date(from: enddateString) as! Date,
               location: row["location"] as! String,
               isAllDay: bool))
       }
           return projectevents;
       }
    static func loadProjecteventsbyprojectidindefault(projectid:String) -> [DefaultEvent]
          {
              let projecteventRows = SQLiteDB.sharedInstance.query(sql:
                  "SELECT projecteventid, taskid, " + "projectid,title, startdate,enddate,location,isallday" + " FROM Projectevent Where projectid IN (\(projectid))")
              var projectevents :     [DefaultEvent] = []
              for row in projecteventRows
          {
              var bool = true
              if row["isallday"] as! Int == 0{
                  bool = false
                  
              }
              var idint = row["projecteventid"] as! Int
              let formmater = DateFormatter()
              let startdateString  = row["startdate"] as! String + " +0000"
              let enddateString  = row["enddate"] as! String + " +0000"
              formmater.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
              projectevents.append(DefaultEvent(
                  id: String(idint),
                  taskid: row["taskid"] as! Int,
                  projectid: row["projectid"] as! Int,
                  title: row["title"] as! String,
                  startDate: formmater.date(from: startdateString) as! Date,
                  endDate: formmater.date(from: enddateString) as! Date,
                  location: row["location"] as! String,
                  isAllDay: bool))
          }
              return projectevents;
          }
    static func loadProjecteventsbyprojectiddefault(projectid:Int) -> [DefaultEvent]
       {
           let projecteventRows = SQLiteDB.sharedInstance.query(sql:
               "SELECT projecteventid, taskid, " + "projectid,title, startdate,enddate,location,isallday" + " FROM Projectevent Where projectid = \(projectid)")
           var projectevents :     [DefaultEvent] = []
           for row in projecteventRows
       {
           var bool = true
           if row["isallday"] as! Int == 0{
               bool = false
               
           }
           var idint = row["projecteventid"] as! Int
           let formmater = DateFormatter()
           let startdateString  = row["startdate"] as! String + " +0000"
           let enddateString  = row["enddate"] as! String + " +0000"
           formmater.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
           projectevents.append(DefaultEvent(
               id: String(idint),
               taskid: row["taskid"] as! Int,
               projectid: row["projectid"] as! Int,
               title: row["title"] as! String,
               startDate: formmater.date(from: startdateString) as! Date,
               endDate: formmater.date(from: enddateString) as! Date,
               location: row["location"] as! String,
               isAllDay: bool))
       }
           return projectevents;
       }
        static func loadrecentindex() -> Int
        {
            let projectRows = SQLiteDB.sharedInstance.query(sql:
                "SELECT last_insert_rowid() From Projectevent")
            var projectevents : [String] = []
            for row in projectRows
        {
            projectevents.append("")
        }
            return projectevents.count+1;
        }
        
        static func insertOrReplace(projectevent: AllDayEvent)
        {
        var intbool = 1
            if projectevent.isAllDay == false{
                intbool = 0
            }
        SQLiteDB.sharedInstance.execute(sql:
        "INSERT OR REPLACE INTO Projectevent (taskid, " + "projectid,title, startdate,enddate,location,isallday) " + "VALUES ( ?, ?, ?, ?, ? , ? , ? ) ",
        parameters: [
        projectevent.taskid,
        projectevent.projectid,
        projectevent.title,
        projectevent.startDate,
        projectevent.endDate,
        projectevent.location,
        intbool
            ]
            )
        }
    static func update(eventid: String,startdate:Date,enddate:Date)
                   {
                   let formatter = DateFormatter()
                   formatter.dateFormat = "yyyy-MM-dd hh:mm:ss"
                    let formatter2 = DateFormatter()
                    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    print(startdate)
                    print(enddate)
                   let myString = formatter.string(from: Date()) // string purpose I add here
                   // convert your string to date
                   let yourDate = formatter.date(from: myString)
                   //then again set the date format whhich type of output you nee
                    let strstartdate = formatter.string(from: startdate.add(component: .hour, value: -8))
                   let strenddate = formatter.string(from: enddate.add(component: .hour, value: -8))
                    print(strstartdate)	
                    print(strenddate)
                    
                   SQLiteDB.sharedInstance.execute(sql:
                    "UPDATE Projectevent SET startdate = '\(strstartdate)', enddate = '\(strenddate)' WHERE projecteventid = \(eventid)")
    }
        
        static func delete(projectevent: AllDayEvent)
        {
        SQLiteDB.sharedInstance.execute(
        sql: "DELETE FROM Projectevent WHERE projecteventid = ?", parameters: [projectevent.id])
        }
        static func deletebyid(projecteventid: String)
           {
           SQLiteDB.sharedInstance.execute(
           sql: "DELETE FROM Projectevent WHERE projecteventid = ?", parameters: [projecteventid])
           }
}
