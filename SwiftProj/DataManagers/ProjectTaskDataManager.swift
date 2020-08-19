//
//  ProjectTaskDataManager.swift
//  SwiftProj
//
//  Created by Sebastian on 11/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class ProjectTaskDataManager: NSObject {
    static func createDatabase()
        {
         SQLiteDB.sharedInstance.execute(sql:
            "CREATE TABLE IF NOT EXISTS " +
            "ProjectTask ( " +
            " taskid INTEGER primary key AUTOINCREMENT, " +
            " projectid INTERGER, " +
            " userid text, " +
            " taskname text, " +
            " taskgoal text, " +
            " startdate text, " +
            " enddate text, " +
            " status INTERGER, " +
            " valid INTERGER Default 1)")
        }
        
        static func load() -> [ProjectTask]
        {
            let projecttaskRows = SQLiteDB.sharedInstance.query(sql:
                "SELECT taskid, projectid, userid" + ",taskname, taskgoal, startdate, enddate,status, valid" + " FROM ProjectTask where valid = 1")
        var projecttasks : [ProjectTask] = []
            for row in projecttaskRows
        {
        let formmater = DateFormatter()
                   let startdateString  = row["startdate"] as? String
                   let enddateString  = row["enddate"] as? String
                   formmater.dateFormat = "yyyy-mm-dd HH:mm:ss"
                   var strstatus = row["status"]! as! String
                   var intstatus : Int = Int(strstatus)!
               projecttasks.append(ProjectTask(
                   taskid: row["taskid"] as? Int, projectid: row["projectid"] as? Int,userid: row["userid"] as? String, taskname: row["taskname"] as? String, taskgoal: row["taskgoal"] as? String, startdate: formmater.date(from: startdateString!)as? Date, enddate: formmater.date(from: enddateString!) as? Date,status: intstatus as? Int, valid: row["valid"] as? Int))
               }
                   return projecttasks;
               }
    static func loadtaskbystatusandprojectid(projectid:Int,status:Int) -> [ProjectTask]
        {
            let projecttaskRows = SQLiteDB.sharedInstance.query(sql:
                "SELECT taskid, projectid, userid" + ",taskname, taskgoal, startdate, enddate, status, valid" + " FROM ProjectTask Where projectid = \(projectid) and status = \(status) and valid = 1")
        var projecttasks : [ProjectTask] = []

            for row in projecttaskRows
        {
            let formmater = DateFormatter()
            let startdateString  = row["startdate"] as? String
            let enddateString  = row["enddate"] as? String
            formmater.dateFormat = "yyyy-mm-dd HH:mm:ss"
            var strstatus = row["status"]! as! String
            var intstatus : Int = Int(strstatus)!
        projecttasks.append(ProjectTask(
            taskid: row["taskid"] as? Int, projectid: row["projectid"] as? Int,userid: row["userid"] as? String, taskname: row["taskname"] as? String, taskgoal: row["taskgoal"] as? String, startdate: formmater.date(from: startdateString!)as? Date, enddate: formmater.date(from: enddateString!) as? Date,status: intstatus as? Int, valid: row["valid"] as? Int))
        }
            return projecttasks;
        }
        static func loadtaskbyid(taskid:Int) -> [ProjectTask]
        {
            let projecttaskRows = SQLiteDB.sharedInstance.query(sql:
                "SELECT taskid, projectid, userid" + ",taskname, taskgoal, startdate, enddate, status, valid" + " FROM ProjectTask Where taskid = \(taskid) and valid = 1")
        var projecttasks : [ProjectTask] = []
            for row in projecttaskRows
        {
       let formmater = DateFormatter()
                   let startdateString  = row["startdate"] as? String
                   let enddateString  = row["enddate"] as? String
                   formmater.dateFormat = "yyyy-MM-dd HH:mm:ss"
                   var strstatus = row["status"]! as! String
                   var intstatus : Int = Int(strstatus)!
               projecttasks.append(ProjectTask(
                taskid: row["taskid"] as? Int, projectid: row["projectid"] as? Int,userid: row["userid"] as? String, taskname: row["taskname"] as? String, taskgoal: row["taskgoal"] as? String, startdate: formmater.date(from: startdateString!)as? Date, enddate: formmater.date(from: enddateString!) as? Date,status: intstatus as? Int, valid: row["valid"] as? Int))
               }
                   return projecttasks;
               }
    static func loadtaskbyprojectid(id:Int) -> [ProjectTask]
           {
               let projecttaskRows = SQLiteDB.sharedInstance.query(sql:
                   "SELECT taskid, projectid, userid" + ",taskname, taskgoal, startdate, enddate, status, valid" + " FROM ProjectTask Where projectid = \(id) and valid = 1")
           var projecttasks : [ProjectTask] = []
               for row in projecttaskRows
           {
          let formmater = DateFormatter()
                      let startdateString  = row["startdate"] as? String
                      let enddateString  = row["enddate"] as? String
                      formmater.dateFormat = "yyyy-mm-dd HH:mm:ss"
                      var strstatus = row["status"]! as! String
                      var intstatus : Int = Int(strstatus)!
                  projecttasks.append(ProjectTask(
                      taskid: row["taskid"] as? Int, projectid: row["projectid"] as? Int,userid: row["userid"] as? String, taskname: row["taskname"] as? String, taskgoal: row["taskgoal"] as? String, startdate: formmater.date(from: startdateString!)as? Date, enddate: formmater.date(from: enddateString!) as? Date,status: intstatus as? Int, valid: row["valid"] as? Int))
                  }
                      return projecttasks;
                  }
    static func loadtaskbytask() -> Int
               {
                   let projecttaskRows = SQLiteDB.sharedInstance.query(sql:
                    "SELECT last_insert_rowid() FROM ProjectTask")
              var projecttasks : [ProjectTask] = []
                      for row in projecttaskRows
                  {
                  projecttasks.append(ProjectTask(
                                      taskid: row["taskid"] as? Int, projectid: row["projectid"] as? Int,userid: row["userid"] as? String, taskname: row["taskname"] as? String, taskgoal: row["taskgoal"] as? String, startdate: row["startdate"] as? Date, enddate: row["enddate"] as? Date,status: row["status"] as? Int, valid: row["valid"] as? Int))
                                    }
                return projecttasks.count;
                                    }
        
        static func insertOrReplace(projecttask: ProjectTask)
        {
        SQLiteDB.sharedInstance.execute(sql:
        "INSERT OR REPLACE INTO ProjectTask (projectid, userid, taskname, taskgoal, startdate, enddate,status, valid)  VALUES (?, ?, ?, ?, ?, ?, ? , ?) ",
        parameters: [
        projecttask.projectid,
        projecttask.userid,
        projecttask.taskname,
        projecttask.taskgoal,
        projecttask.startdate,
        projecttask.enddate,
        projecttask.status,
        projecttask.valid
            ]
            )
        }
    static func update(taskid: Int,status:Int)
               {
               SQLiteDB.sharedInstance.execute(sql:
               "UPDATE ProjectTask SET status = \(status) WHERE taskid = \(taskid)")
               }
   static func updatememo(taskid: Int,taskname:String,taskgoal:String,enddate:Date)
    {
    
    SQLiteDB.sharedInstance.execute(sql:
    "UPDATE ProjectTask SET taskname = ? ,taskgoal = ?,enddate = ? WHERE taskid = ?",parameters: [taskname,taskgoal,enddate,taskid])
    }
        static func delete(projecttask: ProjectTask)
        {
        SQLiteDB.sharedInstance.execute(sql:
        "INSERT OR REPLACE INTO ProjectTask (taskid, projectid,userid, taskname, taskgoal, startdate, enddate, status, valid)  VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?) ",
        parameters: [
        projecttask.taskid,
        projecttask.projectid,
        projecttask.userid,
        projecttask.taskname,
        projecttask.taskgoal,
        projecttask.startdate,
        projecttask.status,
        projecttask.enddate,
        0
            ]
            )
        }
    }
	
