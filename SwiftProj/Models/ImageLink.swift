//
//  ImageLink.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 30/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import Foundation
import UIKit
struct ImageLink {
    var image: UIImage?
    var imgLink: String?
    internal init(image: UIImage?, imgLink: String?) {
        self.image = image
        self.imgLink = imgLink
    }
}
