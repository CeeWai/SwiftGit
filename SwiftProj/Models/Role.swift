//
//  Role.swift
//  SwiftProj
//
//  Created by Sebastian on 30/6/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class Role: NSObject {
    var roleid: Int?
    var rolename: String?
    var projectid: Int?
    var manageowntask: Int?
    var removealltask: Int?
    var editalltask: Int?
    var invitemember: Int?
    var removemember: Int?
    var manageproject: Int?
     
    init(roleid: Int?, rolename: String?, projectid: Int?,manageowntask: Int?, removealltask: Int?
        ,editalltask: Int?,invitemember: Int?,removemember: Int?,manageproject: Int?)
     
{
    self.roleid = roleid
    self.rolename = rolename
    self.projectid = projectid
    self.manageowntask = manageowntask
    self.removealltask = removealltask
    self.editalltask = editalltask
    self.invitemember = invitemember
    self.removemember = removemember
    self.manageproject = manageproject
    }
     

}
