//
//  CommentCell.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 28/5/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class CommentCell: UITableViewCell {

    @IBOutlet weak var commentLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
