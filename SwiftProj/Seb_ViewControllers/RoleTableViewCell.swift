//
//  RoleTableViewCell.swift
//  SwiftProj
//
//  Created by Sebastian on 5/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class RoleTableViewCell: UITableViewCell {

    
    @IBOutlet var rolecellview: UIView!
    @IBOutlet var rolename: UILabel!
    
    @IBOutlet var rolebtn: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
          let bottomline = CALayer()
                  bottomline.frame = CGRect(x:0,y:rolecellview.frame.height - 1, width: rolecellview.frame.width,height: 1)
                  bottomline.backgroundColor =         UIColor.systemRed.cgColor
                  rolecellview.layer.addSublayer(bottomline)
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
