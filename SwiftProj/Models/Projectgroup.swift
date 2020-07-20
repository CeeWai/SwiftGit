//
//  Projectgroup.swift
//  SwiftProj
//
//  Created by Sebastian on 1/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class Projectgroup: NSObject {
        var groupid: Int?
        var projectid: Int?
        var userid: String?
        var username : String?
        var invited: Int?
        var subscribe: Int?
         
    init(groupid:Int?, projectid: Int?, userid: String?,username:String?,invited:Int?, subscribe: Int?)
         
    {
        self.groupid = groupid
        self.projectid = projectid
        self.userid = userid
        self.username = username
        self.invited = invited
        self.subscribe = subscribe
    }
         

}
