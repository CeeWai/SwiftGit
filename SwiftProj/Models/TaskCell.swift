//
//  TaskCell.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 8/5/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class TaskCell: UITableViewCell {
    
    @IBOutlet weak var taskTitleLabel: UILabel!
    @IBOutlet weak var taskDescLabel: UILabel!
    //@IBOutlet weak var taskRuntimeLabel: UILabel!
    @IBOutlet weak var taskEndDateTimeLabel: UILabel!
    @IBOutlet weak var taskDateTimeLabel: UILabel!
    @IBOutlet weak var taskView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        taskView.layer.borderColor = UIColor.lightGray.cgColor
        taskView.layer.shadowColor = UIColor.black.cgColor
        taskView.layer.shadowOffset = CGSize(width: 7.0, height: 1.0)
        taskView.layer.shadowOpacity = 0.4
        taskView.layer.shadowRadius = 4.0
        //taskView.layer.shadowRadius = 0.0

        taskView.layer.masksToBounds = false
        taskDescLabel.sizeToFit()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    

}
