//
//  DataManager.swift
//  Taskr
//
//  Created by Sebastian on 27/6/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import UIKit

class ProjectDataManager: NSObject {
    static func createDatabase()
    {
     SQLiteDB.sharedInstance.execute(sql:
        "CREATE TABLE IF NOT EXISTS " +
        "Projects ( " +
        " projectId INTEGER primary key AUTOINCREMENT, " +
        " projectName text, " +
        " projectLeader text, " +
        " projectDescription text, " +
        " imagename text )")
    }
    
    static func loadProjects() -> [Project]
    {
        let projectRows = SQLiteDB.sharedInstance.query(sql:
            "SELECT projectId, projectName, " + "projectLeader,projectDescription, imagename" + " FROM Projects")
    var projects : [Project] = []
        for row in projectRows
    {
    projects.append(Project(
    projectId: row["projectId"] as! Int,
    projectName: row["projectName"] as! String,
    projectLeader: row["projectLeader"] as! String,
    projectDescription: row["projectDescription"] as! String,
    imageName: row["imagename"] as! String))
    }
        return projects;
    }
    static func loadProjectsbyid(projectid:Int) -> [Project]
    {
        let projectRows = SQLiteDB.sharedInstance.query(sql:
            "SELECT projectId, projectName, " + "projectLeader,projectDescription, imagename" + " FROM Projects Where projectId = \(projectid)")
    var projects : [Project] = []
        for row in projectRows
    {
    projects.append(Project(
    projectId: row["projectId"] as! Int,
    projectName: row["projectName"] as! String,
    projectLeader: row["projectLeader"] as! String,
    projectDescription: row["projectDescription"] as! String,
    imageName: row["imagename"] as! String))
    }
        return projects;
    }
    
    static func insertOrReplaceMovie(project: Project)
    {
    SQLiteDB.sharedInstance.execute(sql:
    "INSERT OR REPLACE INTO Projects (projectName, projectLeader,projectDescription, imageName) " + "VALUES (?, ?, ?, ?) ",
    parameters: [
    project.projectName,
    project.projectLeader,
    project.projectDescription,
    project.imageName
        ]
        )
    }
    
    static func deleteMovie(project: Project)
    {
    SQLiteDB.sharedInstance.execute(
    sql: "DELETE FROM Projects WHERE projectId = ?", parameters: [project.projectId])
    }
}
