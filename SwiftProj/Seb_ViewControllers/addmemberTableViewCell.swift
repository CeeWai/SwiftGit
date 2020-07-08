//
//  addmemberTableViewCell.swift
//  SwiftProj
//
//  Created by Sebastian on 8/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class addmemberTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        let bottomline = CALayer()
        bottomline.frame = CGRect(x:0,y:view.frame.height - 2, width: view.frame.width,height: 2)
        bottomline.backgroundColor =         UIColor.systemRed.cgColor
        view.layer.addSublayer(bottomline)
    }

    @IBOutlet var view: UIView!
    @IBOutlet var username: UILabel!
    @IBOutlet var invitebtn: UIButton!
    var buttonPressed : (() -> ()) = {}
    @IBAction func invitebtn(_ sender: Any) {
        buttonPressed()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
