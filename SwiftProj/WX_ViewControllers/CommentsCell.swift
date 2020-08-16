//
//  CommentCell.swift
//  Forun
//
//  Created by Maxie Yap on 7/8/20.
//

import UIKit

class CommentsCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var commentAuthor: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        loadPosts()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
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

}
