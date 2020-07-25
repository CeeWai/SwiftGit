//
//  ImageCell.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 25/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    @IBOutlet weak var ImageView: UIImageView!
    
    override func awakeFromNib() {
        ImageView.layer.cornerRadius = 10
    }
}
