//
//  PostCell.swift
//  SwiftTest
//
//  Created by Yap Wei xuan on 12/7/20.
//  Copyright © 2020 Yap Wei xuan. All rights reserved.
//

import UIKit

class PostCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        imgProf.layer.cornerRadius = imgProf.frame.size.width / 2
        imgProf.clipsToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var imgProf: UIImageView!
    @IBOutlet weak var commentCount: UILabel!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var upvotes: UILabel!
    @IBOutlet weak var downvotes: UILabel!
    @IBAction func upvBut(_ sender: Any) {
    }
    
    @IBAction func addPost(_ sender: Any) {
    }
    @IBAction func dwvBut(_ sender: Any) {
    }
}
