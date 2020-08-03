//
//  dom_tag.swift
//  SwiftProj
//
//  Created by Dom on 18/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class dom_tag: NSObject {
        var tagTitle: String?
    var tagUID: String?
        init(tagtitle: String?, taguid: String? = "")
    {
        self.tagTitle = tagtitle
        self.tagUID = taguid
        }
         

}
