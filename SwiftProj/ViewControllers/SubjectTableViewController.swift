//
//  SubjectTableViewController.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 9/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

protocol CanReceiveSubject {
    func passSubjectDataBack(data: String)
}

class SubjectTableViewController: UITableViewController {
    
    var delegate: CanReceiveSubject?

    var subjectList = ["Important", "Secondary"]

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            var txtProj = ""
            txtProj = subjectList[indexPath[1]]
            print(subjectList[indexPath[1]])
            delegate?.passSubjectDataBack(data: txtProj)
            dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }

}
