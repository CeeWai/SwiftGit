//
//  IndividualTaskViewController.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 16/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class IndividualTaskViewController: UIViewController {

    var individualTask: Task?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        addBottomSheetView()
    }
    
    func addBottomSheetView() {
        let bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.task = individualTask
        print(individualTask)
        
        self.addChild(bottomSheetVC)
        self.view.addSubview(bottomSheetVC.view)
        bottomSheetVC.didMove(toParent: self)
        
        let height = view.frame.height
        let width = view.frame.width
        bottomSheetVC.view.frame = CGRect(x: 0, y: view.frame.maxY, width: width, height: height)
    }
}
