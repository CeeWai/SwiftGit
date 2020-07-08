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
            " invited INTEGER, " +
            " subscribe INTEGER )")
        }
        
        static func load() -> [Projectgroup]
        {
            let projectgroupRows = SQLiteDB.sharedInstance.query(sql:
                "SELECT groupid, projectid, " + "userid, invited, subscribe" + " FROM Projectgroup")
        var projectgroups : [Projectgroup] = []
            for row in projectgroupRows
        {
        projectgroups.append(Projectgroup(
        groupid: row["groupid"] as! Int,
        projectid: row["projectid"] as! Int,
        userid: row["userid"] as! String,
        invited: row["invited"] as! Int,
        subscribe: row["subscribe"] as! Int))
        }
            return projectgroups;
        }
    static func loadprojectidanduserid(projectid:Int,userid:String,invited:Int) -> [Projectgroup?]
        {
            let projectgroupRows = SQLiteDB.sharedInstance.query(sql:
                "SELECT groupid, projectid, " + "userid, invited, subscribe" + " FROM Projectgroup WHERE projectid = \(projectid) and userid = '\(userid)' and invited = \(invited) ")
        var projectgroups : [Projectgroup] = []
            for row in projectgroupRows
        {
        projectgroups.append(Projectgroup(
        groupid: row["groupid"] as! Int,
        projectid: row["projectid"] as! Int,
        userid: row["userid"] as! String,
        invited: row["invited"] as! Int,
        subscribe: row["subscribe"] as! Int))
        }
            return projectgroups;
        }
    static func loadbyprojectuseridwhensubscribe0(projectid:Int,userid:String) -> [Projectgroup]
        {
            let projectgroupRows = SQLiteDB.sharedInstance.query(sql:
                "SELECT groupid, projectid, " + "userid, invited, subscribe" + " FROM Projectgroup WHERE projectid = \(projectid) and userid = '\(userid)' and invited = 1 and subscribe = 0")
        var projectgroups : [Projectgroup] = []
            for row in projectgroupRows
        {
        projectgroups.append(Projectgroup(
        groupid: row["groupid"] as! Int,
        projectid: row["projectid"] as! Int,
        userid: row["userid"] as! String,
        invited: row["invited"] as! Int,
        subscribe: row["subscribe"] as! Int))
        }
            return projectgroups;
        }
        static func Replaceinvitedorsubscribe(projectgroup: Projectgroup)
        {
        SQLiteDB.sharedInstance.execute(sql:
        "INSERT OR REPLACE INTO Projectgroup (groupid,projectid,userid, invited,subscribe) " + "VALUES (?, ?, ?, ?, ?) ",
        parameters: [
        projectgroup.groupid,
        projectgroup.projectid,
        projectgroup.userid,
        projectgroup.invited,
        projectgroup.subscribe
            ]
            )
        }
        static func insertOrReplace(projectgroup: Projectgroup)
        {
        SQLiteDB.sharedInstance.execute(sql:
        "INSERT OR REPLACE INTO Projectgroup (projectid,userid, invited,subscribe) " + "VALUES (?, ?, ?, ?) ",
        parameters: [
        projectgroup.projectid,
        projectgroup.userid,
        projectgroup.invited,
        projectgroup.subscribe
            ]
            )
        }
        
        static func deleteMovie(projectgroup: Projectgroup)
        {
        SQLiteDB.sharedInstance.execute(
        sql: "DELETE FROM Projectgroup WHERE groupid = ?", parameters: [projectgroup.groupid])
        }
    }
