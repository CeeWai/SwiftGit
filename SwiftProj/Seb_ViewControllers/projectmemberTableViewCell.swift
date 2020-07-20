//
//  projectmemberTableViewCell.swift
//  SwiftProj
//
//  Created by Sebastian on 14/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class projectmemberTableViewCell: UITableViewCell {

    @IBOutlet var view: UIView!
    @IBOutlet var membername: UILabel!
    @IBOutlet var memberrole: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        let bottomline = CALayer()
        bottomline.frame = CGRect(x:0,y:view.frame.height - 1, width: view.frame.width,height: 1)
        bottomline.backgroundColor =         UIColor.systemRed.cgColor
        view.layer.addSublayer(bottomline)
    }
    var buttonPressed : (() -> ()) = {}
    
    @IBAction func assignrole(_ sender: Any) {
        var buttonPressed : (() -> ()) = {}
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
