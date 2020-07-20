//
//  projectmemberTableViewCell.swift
//  SwiftProj
//
//  Created by Sebastian on 14/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class projectmemberTableViewCell: UITableViewCell {

    @IBOutlet var membername: UILabel!
    @IBOutlet var memberrole: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
