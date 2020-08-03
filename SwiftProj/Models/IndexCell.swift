//
//  IndexCell.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 18/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import Foundation
import UIKit
class IndexCell: UICollectionViewCell {

    @IBOutlet weak var indexView: UIView!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var bgImg: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        indexView.layer.cornerRadius = 10
        indexView.layer.borderWidth = 0.4
        bgImg.layer.cornerRadius = 10

        if self.traitCollection.userInterfaceStyle == .dark {
            // User Interface is Dark
//            indexView.layer.borderColor = UIColor.white.cgColor
//            indexView.layer.backgroundColor = UIColor.black.cgColor
        } else {
            // User Interface is Light
//            indexView.layer.borderColor = UIColor.black.cgColor
//            indexView.layer.backgroundColor = UIColor.white.cgColor
        }
    }
}
