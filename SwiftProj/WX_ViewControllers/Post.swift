//
//  Post.swift
//  SwiftTest
//
//  Created by Yap Wei xuan on 12/7/20.
//  Copyright © 2020 Yap Wei xuan. All rights reserved.
//

import UIKit

class Post: NSObject {
    var postTitle: String
    var postDesc: String
    var username: String
    var postDate: String
    var postImage: String
    var upvotes: Int
    var downvotes: Int
    var commentCount: Int
    var profImg: String
    
    init(postTitle: String, postDesc: String, username: String, postDate: String, postImage: String, upvotes: Int, downvotes: Int, commentCount: Int, profImg: String)
    {
        self.commentCount = commentCount
        self.downvotes = downvotes
        self.postDate = postDate
        self.postDesc = postDesc
        self.postImage = postImage
        self.postTitle = postTitle
        self.upvotes = upvotes
        self.username = username
        self.profImg = profImg
    }
}
