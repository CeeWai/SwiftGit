//
//  addtaskmemberTableViewCell.swift
//  SwiftProj
//
//  Created by Sebastian on 11/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class addtaskmemberTableViewCell: UITableViewCell {

    @IBOutlet var view: UIView!
    @IBOutlet var usernamelabel: UILabel!
    @IBOutlet var assignbtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        let bottomline = CALayer()
        bottomline.frame = CGRect(x:0,y:view.frame.height - 2, width: view.frame.width,height: 2)
        bottomline.backgroundColor =         UIColor.systemRed.cgColor
        view.layer.addSublayer(bottomline)
    }
    var buttonPressed : (() -> ()) = {}
    
    @IBAction func pressedassignbtn(_ sender: Any) {
        buttonPressed()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
