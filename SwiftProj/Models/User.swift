//
//  User.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 24/5/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import Foundation

class User:Codable{
    
    //var id: Int
    var uid: String
    var username : String
    
    
    init(
        //id: Int,
        uid: String,
        username: String
    )
    {
        //self.id = id
        self.username = username
        self.uid = uid
    }
}
/*
 var username : String
    var email: String
    var password: String
    var imagePath: String
    
    init(
        //id: Int,
        username: String,
        email: String,
        password: String,
        imagePath: String
    )
    {
        //self.id = id
        self.username = username
        self.email = email
        self.password = password
        self.imagePath = imagePath
    }
 */
