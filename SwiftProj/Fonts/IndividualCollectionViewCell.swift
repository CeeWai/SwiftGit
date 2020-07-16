//
//  IndividualCollectionViewCell.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 16/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class IndividualTaskCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var individualCellView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var hourTimeLabel: UILabel!
    
    var task: Task! {
        didSet {
            self.updateUI()
        }
    }
    
    func updateUI() {
        if let task = task {
            titleLabel.text = task.taskName
            descriptionLabel.text = task.taskDesc
            //timeLabel
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            hourTimeLabel.text = "\(dateFormatter.string(from: task.taskStartTime)) - \(dateFormatter.string(from: task.taskEndTime))"
    
            let dFormatter = DateFormatter()
            dFormatter.dateFormat = "d EEEE YYYY"
            timeLabel.text = dFormatter.string(from: task.taskStartTime)
            print("title: \(task.taskName) description: \(task.taskDesc)")

        } else {
            titleLabel.text = nil
            descriptionLabel.text = nil
            //timeLabel
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "h:mm a"
            hourTimeLabel.text = nil
    
            let dFormatter = DateFormatter()
            dFormatter.dateFormat = "d EEEE YYYY"
            timeLabel.text = nil
            print("TASK FOUND NIL")
        }
        
        individualCellView.layer.borderWidth = 0.7
        individualCellView.layer.cornerRadius = 10

        //individualCellView.layer.masksToBounds = true
        titleLabel.sizeToFit()
        descriptionLabel.sizeToFit()
        if self.traitCollection.userInterfaceStyle == .dark {
            individualCellView.layer.borderColor = UIColor.white.cgColor
        } else {
            individualCellView.layer.borderColor = UIColor.black.cgColor
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

    }
}
