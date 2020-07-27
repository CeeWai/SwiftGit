//
//  DocImageStore.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 27/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import Foundation

struct DocImageStore: Codable {
    internal init(docID: String? = nil, imageDesc: String? = nil, imageLink: String? = nil) {
        self.docID = docID
        self.imageDesc = imageDesc
        self.imageLink = imageLink
    }
    
    var docID: String?
    var imageDesc: String?
    var imageLink: String?

}
