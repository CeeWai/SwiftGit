//
//  ProjectgroupDataManager.swift
//  SwiftProj
//
//  Created by Sebastian on 1/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class ProjectgroupDataManager: NSObject {
    static func createDatabase()
        {
         SQLiteDB.sharedInstance.execute(sql:
            "CREATE TABLE IF NOT EXISTS " +
            "Projectgroup ( " +
            " groupid INTEGER primary key AUTOINCREMENT, " +
            " projectid INTEGER, " +
            " userid text, " +
                " username text, " +
                " role text, " +
            " invited INTEGER, " +
            " subscribe INTEGER )")
        }
        
        static func loadsubscribed(projectid:Int) -> [Projectgroup]
        {
            let projectgroupRows = SQLiteDB.sharedInstance.query(sql:
                "SELECT groupid, projectid, " + "userid, username,role, invited, subscribe" + " FROM Projectgroup where projectid =\(projectid) and invited = 1 and subscribe = 1 ")
        var projectgroups : [Projectgroup] = []
            for row in projectgroupRows
        {
        projectgroups.append(Projectgroup(
        groupid: row["groupid"] as! Int,
        projectid: row["projectid"] as! Int,
        userid: row["userid"] as! String,
        username: row["username"] as! String,
        role: row["role"] as! String,
        invited: row["invited"] as! Int,
        subscribe: row["subscribe"] as! Int))
        }
            return projectgroups;
        }
    static func load() -> [Projectgroup]
           {
               let projectgroupRows = SQLiteDB.sharedInstance.query(sql:
                   "SELECT groupid, projectid, " + "userid,username,role, invited, subscribe" + " FROM Projectgroup")
           var projectgroups : [Projectgroup] = []
               for row in projectgroupRows
           {
           projectgroups.append(Projectgroup(
           groupid: row["groupid"] as! Int,
           projectid: row["projectid"] as! Int,
           userid: row["userid"] as! String,
           username: row["username"] as! String,
           role: row["role"] as! String,
           invited: row["invited"] as! Int,
           subscribe: row["subscribe"] as! Int))
           }
               return projectgroups;
           }
    static func loadprojectidanduserid(projectid:Int,userid:String,invited:Int) -> [Projectgroup?]
        {
            let projectgroupRows = SQLiteDB.sharedInstance.query(sql:
                "SELECT groupid, projectid, " + "userid,username,role, invited, subscribe" + " FROM Projectgroup WHERE projectid = \(projectid) and userid = '\(userid)' and invited = \(invited) ")
        var projectgroups : [Projectgroup] = []
            for row in projectgroupRows
        {
        projectgroups.append(Projectgroup(
        groupid: row["groupid"] as! Int,
        projectid: row["projectid"] as! Int,
        userid: row["userid"] as! String,
        username: row["username"] as! String,
        role: row["role"] as! String,
        invited: row["invited"] as! Int,
        subscribe: row["subscribe"] as! Int))
        }
            return projectgroups;
        }
    static func loadbyprojectuseridwhensubscribe0(userid:String) -> [Projectgroup]
        {
            let projectgroupRows = SQLiteDB.sharedInstance.query(sql:
                "SELECT groupid, projectid, " + "userid,username,role, invited, subscribe" + " FROM Projectgroup WHERE userid = '\(userid)' and invited = 1 and subscribe = 0")
        var projectgroups : [Projectgroup] = []
            for row in projectgroupRows
        {
        projectgroups.append(Projectgroup(
        groupid: row["groupid"] as! Int,
        projectid: row["projectid"] as! Int,
        userid: row["userid"] as! String,
        username: row["username"] as! String,
        role: row["role"] as! String,
        invited: row["invited"] as! Int,
        subscribe: row["subscribe"] as! Int))
        }
            return projectgroups;
        }
    static func loadbyprojectuseridwhensubscribe1(userid:String) -> [Projectgroup]
    {
        let projectgroupRows = SQLiteDB.sharedInstance.query(sql:
            "SELECT groupid, projectid, " + "userid,username,role, invited, subscribe" + " FROM Projectgroup WHERE userid = '\(userid)' and invited = 1 and subscribe = 1")
    var projectgroups : [Projectgroup] = []
        for row in projectgroupRows
    {
    projectgroups.append(Projectgroup(
    groupid: row["groupid"] as! Int,
    projectid: row["projectid"] as! Int,
    userid: row["userid"] as! String,
    username: row["username"] as! String,
    role: row["role"] as! String,
    invited: row["invited"] as! Int,
    subscribe: row["subscribe"] as! Int))
    }
        
        return projectgroups;
    }
    static func loadbyprojectprojectidwhensubscribe1(projectid:String) -> [Projectgroup]
       {
           let projectgroupRows = SQLiteDB.sharedInstance.query(sql:
               "SELECT groupid, projectid, " + "userid,username,role, invited, subscribe" + " FROM Projectgroup WHERE projectid = '\(projectid)' and invited = 1 and subscribe = 1")
       var projectgroups : [Projectgroup] = []
           for row in projectgroupRows
       {
       projectgroups.append(Projectgroup(
       groupid: row["groupid"] as! Int,
       projectid: row["projectid"] as! Int,
       userid: row["userid"] as! String,
       username: row["username"] as! String,
       role: row["role"] as! String,
       invited: row["invited"] as! Int,
       subscribe: row["subscribe"] as! Int))
       }
           
           return projectgroups;
       }
        static func Replaceinvitedorsubscribe(projectgroup: Projectgroup)
        {
        SQLiteDB.sharedInstance.execute(sql:
        "INSERT OR REPLACE INTO Projectgroup (groupid,projectid,userid,username,role,invited,subscribe) " + "VALUES (?, ?, ?, ?, ?, ?, ?) ",
        parameters: [
        projectgroup.groupid,
        projectgroup.projectid,
        projectgroup.userid,
        projectgroup.username,
        projectgroup.role,
        projectgroup.invited,
        projectgroup.subscribe
            ]
            )
        }
        static func insertOrReplace(projectgroup: Projectgroup)
        {
        SQLiteDB.sharedInstance.execute(sql:
        "INSERT OR REPLACE INTO Projectgroup (projectid,userid,username,role, invited,subscribe) " + "VALUES (?, ?, ?, ?, ?, ?) ",
        parameters: [
        projectgroup.projectid,
        projectgroup.userid,
        projectgroup.username,
        projectgroup.role,
        projectgroup.invited,
        projectgroup.subscribe
            ]
            )
        }
    static func update(projectid:Int,userid: String,role:String)
                     {
                     SQLiteDB.sharedInstance.execute(sql:
                     "UPDATE Projectgroup SET role = '\(role)' WHERE projectid = \(projectid) and userid = '\(userid)'")
                     }
        static func deleteMovie(projectgroup: Projectgroup)
        {
        SQLiteDB.sharedInstance.execute(
        sql: "DELETE FROM Projectgroup WHERE groupid = ?", parameters: [projectgroup.groupid])
        }
    }
