//
//  DismissSegue.swift
//  SwiftTest
//
//  Created by Yap Wei xuan on 15/7/20.
//  Copyright © 2020 Yap Wei xuan. All rights reserved.
//

import UIKit

class DismissSegue: UIStoryboardSegue {
    override func perform() {
        self.source.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
