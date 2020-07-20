//
//  RoleDataManager.swift
//  SwiftProj
//
//  Created by Sebastian on 30/6/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class RoleDataManager: NSObject {
        static func createDatabase()
        {
         SQLiteDB.sharedInstance.execute(sql:
            "CREATE TABLE IF NOT EXISTS " +
            "Roles ( " +
            " roleid INTEGER primary key AUTOINCREMENT, " +
            " rolename text, " +
            " projectid INTEGER, " +
            " manageowntask INTEGER, " +
            " removealltask INTEGER, " +
            " editalltask INTEGER, " +
            " invitemember INTEGER, " +
            " removemember INTEGER, " +
            " manageproject INTEGER )")
        }
        
        static func load() -> [Role]
        {
            let roleRows = SQLiteDB.sharedInstance.query(sql:
                "SELECT roleid, rolename, " + "projectid, manageowntask, removealltask, editalltask, invitemember, removemember, manageproject" + " FROM Roles")
            var roles : [Role] = []
                for row in roleRows
            {
                roles.append(Role(
                roleid: row["roleid"] as! Int,
                rolename: row["rolename"] as! String,
                projectid: row["projectid"] as! Int,
                manageowntask: row["manageowntask"] as! Int,
                removealltask: row["removealltask"] as! Int,
                editalltask: row["editalltask"] as! Int,
                invitemember: row["invitemember"] as! Int,
                removemember: row["removemember"] as! Int,
                manageproject: row["manageproject"] as! Int))
            }
                return roles;
        }
    static func loadprojectid(projectid:Int) -> [Role]
        {
            let roleRows = SQLiteDB.sharedInstance.query(sql:
                "SELECT roleid, rolename, " + "projectid, manageowntask, removealltask, editalltask, invitemember, removemember, manageproject" + " FROM Roles Where projectid = \(projectid)")
            var roles : [Role] = []
                for row in roleRows
            {
                roles.append(Role(
                roleid: row["roleid"] as! Int,
                rolename: row["rolename"] as! String,
                projectid: row["projectid"] as! Int,
                manageowntask: row["manageowntask"] as! Int,
                removealltask: row["removealltask"] as! Int,
                editalltask: row["editalltask"] as! Int,
                invitemember: row["invitemember"] as! Int,
                removemember: row["removemember"] as! Int,
                manageproject: row["manageproject"] as! Int))
            }
            print(projectid)
                return roles;
        }
        static func insertOrReplaceMovie(role: Role)
        {
        SQLiteDB.sharedInstance.execute(sql:
        "INSERT OR REPLACE INTO Roles (rolename,projectid,manageowntask,removealltask,editalltask,invitemember,removemember,manageproject) " + "VALUES (?, ?, ?, ?, ?, ?, ?, ?) ",
        parameters: [
            role.rolename,
            role.projectid,
            role.manageowntask,
            role.removealltask,
            role.editalltask,
            role.invitemember,
            role.removemember,
            role.manageproject
            ]
            )
        }
        
        static func deleteMovie(role: Role)
        {
        SQLiteDB.sharedInstance.execute(
        sql: "DELETE FROM Roles WHERE roleid = ?", parameters: [role.roleid])
        }
    }
