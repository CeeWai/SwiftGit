//
//  projectdetail1ViewController.swift
//  Taskr
//
//  Created by Sebastian on 28/6/20.
//  Copyright © 2020 Sebastian. All rights reserved.
//

import UIKit

class projectdetail1ViewController: UIViewController {

    
    
    @IBOutlet var navtitle: UINavigationItem!
    var projectItem : Project?
    override func viewDidLoad() {
        super.viewDidLoad()
        navtitle.title=projectItem?.projectName
        // Do any additional setup after loading the view.
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
