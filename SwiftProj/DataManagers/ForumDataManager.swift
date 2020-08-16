//
//  DataManager.swift
//  Forun
//
//  Created by Maxie Yap on 6/8/20.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift

class ForumDataManager
{
    static let db = Firestore.firestore()
    
    static func insertOrReplacePost(_ post: Post)
    {
        try? db.collection("posts")
            .document(post.postTitle)
            .setData(from : post, encoder: Firestore.Encoder())
            {
                err in
                if let err = err {
                    print("Error adding document: \(err)")
                } else {
                    print("Document added Successfully!")
                }
            }
    }
    
    static func deletePost(_ post: Post)
    {
        db.collection("posts").document(post.postTitle).delete() {
            err in
            if let err = err {
                print("Error removing document: \(err)")
            } else {
                print("Document deleted successfully!")
            }
        }
    }
    
    static func loadPosts(onComplete: (([Post]) -> Void)?)
    {
        // getDocuments to load full list of Posts
        db.collection("posts").getDocuments()
        {
            (querySnapshot, err) in
            
            var postList : [Post] = []
            
            if let err = err
            {
                print("Error getting documents \(err)")
            }
            else
            {
                for document in querySnapshot!.documents
                {
                    // Retrieve all fields and update
                    var post = try? document.data(as: Post.self)
                        as! Post
                    
                    if post != nil
                    {
                        postList.append(post!)
                    }
                }
            }
            onComplete?(postList)
        }
    }
    
    static func upvote(_ post: Post)
    {
        
    }
}
