//
//  Project.swift
//  Taskr
//
//  Created by Sebastian on 22/6/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import UIKit

class Project: NSObject {
    var projectId: Int?
    var projectName: String?
    var projectLeader: String?
    var projectLeaderid: String?
    var projectDescription: String?
    var imageName: String?
     
    init(projectId:Int?, projectName: String?, projectLeader: String?,projectLeaderid:String?,projectDescription:String?, imageName: String?)
     
{
    self.projectId = projectId
    self.projectName = projectName
    self.projectLeader = projectLeader
    self.projectLeaderid = projectLeaderid
    self.projectDescription = projectDescription
    self.imageName = imageName
    }
     

}
