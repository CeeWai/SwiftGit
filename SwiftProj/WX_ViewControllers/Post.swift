//
//  Post.swift
//  Forun
//
//  Created by Maxie Yap on 6/8/20.
//

import Foundation

class Post : Codable {

    var postTitle: String
    var postDesc: String
    var postImage: String
    var upvotes: Int
    var downvotes: Int
    var commentCount: Int
    var comment: Array<String>
    var postDate : String
    var author : String
    var upvoters : Array<String>
    
    
    init(postTitle: String, postDesc: String, postImage: String, upvotes: Int, downvotes: Int, commentCount: Int, comment: Array<String>, postDate: String, author: String, upvoters: Array<String>) {
        self.postTitle = postTitle
        self.postDesc = postDesc
        self.postImage = postImage
        self.upvotes = upvotes
        self.downvotes = downvotes
        self.commentCount = comment.count
        self.comment = comment
        self.postDate = postDate
        self.author = author
        self.upvoters = upvoters
    }
}
