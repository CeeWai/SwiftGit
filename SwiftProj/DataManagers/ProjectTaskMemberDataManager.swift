//
//  ProjectTaskMemberDataManager.swift
//  SwiftProj
//
//  Created by Sebastian on 11/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class ProjectTaskMemberDataManager: NSObject {
    static func createDatabase()
           {
            SQLiteDB.sharedInstance.execute(sql:
               "CREATE TABLE IF NOT EXISTS " +
               "ProjectTaskMember ( " +
               " taskgroupid INTEGER primary key AUTOINCREMENT, " +
               " projectid INTEGER, " +
               " taskid INTEGER, " +
               " userid text, " +
               " username text, " +
               " assign INTEGER, " +
               " valid INTEGER )")
           }
           
           static func load() -> [ProjectTaskMember]
           {
               let projecttaskmemberRows = SQLiteDB.sharedInstance.query(sql:
                   "SELECT taskgroupid, projectid, taskid ," + "userid, username, assign, valid" + " FROM ProjectTaskMember Where valid = 1")
           var projecttaskmember: [ProjectTaskMember] = []
               for row in projecttaskmemberRows
           {
           projecttaskmember.append(ProjectTaskMember(
           taskgroupid: row["taskgroupid"] as! Int,
           projectid: row["projectid"] as! Int,
           taskid: row["taskid"] as! Int,
           userid: row["userid"] as! String,
           username: row["username"] as! String,
           assign: row["assign"] as! Int,
           valid: row["valid"] as! Int))
           }
               return projecttaskmember;
           }
    
       static func loadprojecttaskidanduserid(taskid:Int,userid:String,assign:Int) -> [ProjectTaskMember?]
           {
               let projecttaskmemberRows = SQLiteDB.sharedInstance.query(sql:
                  "SELECT taskgroupid, projectid, taskid," + "userid, username, assign, valid" + " FROM ProjectTaskMember WHERE taskid = \(taskid) and userid = '\(userid)' and assign = \(assign) and valid = 1")
           var projecttaskmember : [ProjectTaskMember] = []
               for row in projecttaskmemberRows
           {
           projecttaskmember.append(ProjectTaskMember(
           taskgroupid: row["taskgroupid"] as! Int,
           projectid: row["projectid"] as! Int,
           taskid: row["taskid"] as! Int,
           userid: row["userid"] as! String,
           username: row["username"] as! String,
           assign: row["assign"] as! Int,
           valid: row["valid"] as! Int))
           }
               return projecttaskmember;
           }
       static func loadbyprojecttaskuseridwhensubscribe0(taskid:Int,userid:String) -> [ProjectTaskMember]
           {
               let projecttaskmemberRows = SQLiteDB.sharedInstance.query(sql:
                  "SELECT taskgroupid, projectid,taskid, " + "userid, username, assign, valid" + " FROM ProjectTaskMember WHERE taskid = \(taskid) and userid = '\(userid)' and assign = 0 and valid = 1")
           var projecttaskmember : [ProjectTaskMember] = []
               for row in projecttaskmemberRows
           {
           projecttaskmember.append(ProjectTaskMember(
           taskgroupid: row["taskgroupid"] as! Int,
           projectid: row["projectid"] as! Int,
           taskid: row["taskid"] as! Int,
           userid: row["userid"] as! String,
           username: row["username"] as! String,
           assign: row["assign"] as! Int,
           valid: row["valid"] as! Int))
           }
               return projecttaskmember;
           }
           static func Replaceinvitedorsubscribe(projecttaskmember: ProjectTaskMember)
           {
           SQLiteDB.sharedInstance.execute(sql:
           "INSERT OR REPLACE INTO ProjectTaskMember (taskgroupid, projectid, taskid, userid, username, assign, valid) " + "VALUES (?, ?, ?, ?, ?, ?, ?) ",
           parameters: [
           projecttaskmember.taskgroupid,
           projecttaskmember.projectid,
           projecttaskmember.taskid,
           projecttaskmember.userid,
           projecttaskmember.username,
           projecttaskmember.assign,
           projecttaskmember.valid
               ]
               )
           }
           static func insertOrReplace(projecttaskmember: ProjectTaskMember)
           {
           SQLiteDB.sharedInstance.execute(sql:
           "INSERT OR REPLACE INTO ProjectTaskMember (projectid, taskid, userid, username, assign, valid) " + "VALUES (?, ?, ?, ?, ?, ?) ",
           parameters: [
           projecttaskmember.projectid,
           projecttaskmember.taskid,
           projecttaskmember.userid,
           projecttaskmember.username,
           projecttaskmember.assign,
           projecttaskmember.valid
               ]
               )
           }
           
           static func deleteMovie(projectgroup: Projectgroup)
           {
           SQLiteDB.sharedInstance.execute(
           sql: "DELETE FROM ProjectTaskMember WHERE groupid = ?", parameters: [projectgroup.groupid])
           }
       }
