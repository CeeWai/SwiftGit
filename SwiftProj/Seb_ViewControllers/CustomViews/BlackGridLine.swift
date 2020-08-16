//
//  BlackGridLine.swift
//  SwiftProj
//
//  Created by Sebastian on 23/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

/// Custom Decoration View
class BlackGridLine: UICollectionReusableView {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .orange
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
