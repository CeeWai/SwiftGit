//
//  dom_note.swift
//  SwiftProj
//
//  Created by Dom on 12/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class dom_note: NSObject {
    var noteTitle: String?
    var noteBody: String?
    var noteUserID: String?
    var noteID: String?
    var noteTags : String?
    var noteUpdateDate: String?
    var noteImgUrl:String?
    init(notetitle: String?, notebody: String?, notetags: String?, noteUserid: String?, noteid: String?, noteupdateDate:String?,noteimgUrl:String?)
        
    {
        self.noteTitle = notetitle
        self.noteBody = notebody
        self.noteUserID = noteUserid
        self.noteID = noteid
        self.noteTags = notetags
        self.noteUpdateDate = noteupdateDate
        self.noteImgUrl = noteimgUrl
    }
    
    
}
