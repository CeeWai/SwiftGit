//
//  projecttaskdetailViewController.swift
//  SwiftProj
//
//  Created by Sebastian on 9/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class projecttaskdetailViewController: UIViewController {
    @IBOutlet var taskname: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        taskname.layer.borderWidth = 2;
        taskname.layer.cornerRadius = 7
        taskname.layer.borderColor = UIColor.systemRed.cgColor
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
