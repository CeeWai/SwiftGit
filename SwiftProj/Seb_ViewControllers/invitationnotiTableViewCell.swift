//
//  invitationnotiTableViewCell.swift
//  SwiftProj
//
//  Created by Sebastian on 8/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class invitationnotiTableViewCell: UITableViewCell {

    @IBOutlet var imageview: UIImageView!
    @IBOutlet var textview: UITextView!
    @IBOutlet var acceptbtn: UIButton!
    @IBOutlet var declinebtn: UIButton!
    @IBOutlet var view: UIView!
    var acceptbuttonPressed : (() -> ()) = {}
    var declinebuttonPressed : (() -> ()) = {}
    override func awakeFromNib() {
        super.awakeFromNib()
        let bottomline = CALayer()
        bottomline.frame = CGRect(x:0,y:view.frame.height - 2, width: view.frame.width,height: 2)
        bottomline.backgroundColor =         UIColor.systemRed.cgColor
        view.layer.addSublayer(bottomline)
    }

    @IBAction func pressedacceptbtn(_ sender: Any) {
        acceptbuttonPressed()
    }
    @IBAction func presseddeclinebtn(_ sender: Any) {
        declinebuttonPressed()
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
