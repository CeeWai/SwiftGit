//
//  TaskCommentViewController.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 28/5/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class TaskCommentViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    @IBOutlet weak var tableView: UITableView!
    
    // to change to 'Comment' class in the future this is just a place holder for the UI Presentation
    var commentList : [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        commentList.append("Unsure about question 4. Ask the teacher for some help.")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return commentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // taskCommentCell
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentCell", for: indexPath)
        
        let p = commentList[indexPath.row]
        cell.textLabel?.text = p
        return cell
    }
    

}
