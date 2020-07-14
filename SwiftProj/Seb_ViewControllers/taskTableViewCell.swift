//
//  taskTableViewCell.swift
//  SwiftProj
//
//  Created by Sebastian on 12/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class taskTableViewCell: UITableViewCell {

    @IBOutlet var btn: UIButton!
    @IBOutlet var tasknem: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
