//
//  DocImage.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 24/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import Foundation
import UIKit

struct DocImage {
    var image: UIImage?
    var imageDesc: String?

    internal init(image: UIImage?, imageDesc: String?) {
        self.image = image
        self.imageDesc = imageDesc
    }
}
