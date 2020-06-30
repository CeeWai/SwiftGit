//
//  ProjectCellTableViewCell.swift
//  Taskr
//
//  Created by Sebastian on 22/6/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import UIKit

class ProjectCellTableViewCell: UITableViewCell {


    @IBOutlet var projectImageView: UIImageView!
    
    @IBOutlet var projectnameLabel: UILabel!
    
    @IBOutlet var projectleaderLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
