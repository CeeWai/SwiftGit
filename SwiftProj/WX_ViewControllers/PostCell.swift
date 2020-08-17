//
//  PostCell.swift
//  Forun
//
//  Created by Maxie Yap on 6/8/20.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase
import FirebaseAuth

class PostCell: UITableViewCell {
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postDesc: UILabel!
    @IBOutlet weak var author: UILabel!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var upvotes: UILabel!
    @IBOutlet weak var upvBtn: UIButton!
    
    var upvoted = false
    
    @IBAction func upvBtnPressed(_ sender: Any) {
        
        if (upvoted == false) {
            
            let currentuser = Auth.auth().currentUser?.displayName!
            
            let upvoters = ForumViewController.db.collection("posts").document("upvoters")
            
            upvoters.updateData([
                "upvoters" : FieldValue.arrayUnion([currentuser!])
            ])
                
                var upvoteCount = upvotes.text!
                let upvC = Int(upvoteCount)! + 1
                upvoteCount = String(upvC)
            
                upvBtn.tintColor = UIColor.red
                
                upvoted = true
                    
                upvotes.text = upvoteCount
                
                let upvotes = ForumViewController.db.collection("posts").document(postTitle.text!)
                upvotes.updateData([
                    "upvotes" : upvC
                ])
                
                loadPosts()
        }
        
        else {
            var upvoteCount = upvotes.text!
            let upvC = Int(upvoteCount)! - 1
            upvoteCount = String(upvC)
            
            upvBtn.tintColor = UIColor.blue
            
            upvoted = false
            
            upvotes.text = upvoteCount
                           
            let upvotes = ForumViewController.db.collection("posts").document(postTitle.text!)
                           upvotes.updateData([
                               "upvotes" : upvC
                           ])
                           
            loadPosts()
        }
        
    }
    
    var postList : [Post] = []
    
    func loadPosts()
    {
        ForumDataManager.loadPosts()
            {
                postListFromFirestore in
                self.postList = postListFromFirestore
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        loadPosts()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
