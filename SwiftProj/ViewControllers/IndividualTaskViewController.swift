//
//  IndividualTaskViewController.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 12/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class IndividualTaskViewController: UITableViewController {

    var individualTask: Task?
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var infoCardCell: UITableViewCell!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var hourTimeLabel: UILabel!
    @IBOutlet weak var infoCardView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleLabel.text = individualTask?.taskName
        print("title: \(individualTask?.taskName) description: \(individualTask?.taskDesc)")
        descriptionLabel.text = individualTask?.taskDesc
        titleLabel.sizeToFit()
        descriptionLabel.sizeToFit()
        
        timeLabel.text = "Placeholder for the time label"
        descriptionLabel.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam dapibus mi auctor feugiat pharetra. Phasellus id nisl id odio facilisis venenatis eget laoreet velit. Sed dictum vitae erat non maximus. Praesent eget turpis vel neque varius sollicitudin a a turpis. Pellentesque volutpat tincidunt odio at vehicula. Suspendisse varius sodales augue, sed maximus nibh maximus non. Sed semper efficitur rutrum. Nullam in lacus eget diam consequat finibus. Suspendisse tincidunt et sem a dignissim."
        
        
        self.tableView.rowHeight = UITableView.automaticDimension;
        infoCardView.setNeedsLayout()
        infoCardView.layoutIfNeeded()
        print(infoCardView.fs_height)

    }



}
