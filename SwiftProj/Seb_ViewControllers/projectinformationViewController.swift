//
//  projectinformationViewController.swift
//  SwiftProj
//
//  Created by Sebastian on 16/8/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class projectinformationViewController: UIViewController {
    var projectItem : Project?
    @IBOutlet weak var titlelabel: UILabel!
    @IBOutlet weak var descriptionlabel: UITextView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden=true
        print(projectItem?.projectName)
        titlelabel.text = projectItem?.projectName
        descriptionlabel.text = projectItem?.projectDescription
    }
    override func viewDidAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden=true
    }

    @IBAction func presseddelete(_ sender: Any) {
        ProjectDataManager.deleteMovie(project: projectItem!)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    override func prepare(for segue: UIStoryboardSegue,
        sender: Any?){
       
        if(segue.identifier == "seguetoproject")
         {
        let detailViewController = segue.destination as!
         projectdetail1ViewController
            detailViewController.projectItem = self.projectItem
        }
       
    }
}
