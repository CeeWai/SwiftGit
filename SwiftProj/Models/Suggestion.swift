//
//  Suggestion.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 15/8/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import Foundation
struct Suggestion {
    internal init(text: String?, textDistance: Double?) {
        self.text = text
        self.textDistance = textDistance
    }
    
    var text: String?
    var textDistance: Double?

}
