//
//  ImportanceTableViewController.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 3/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

protocol CanRecieveImportance {
    func passImportanceDataBack(data: String)
}


class ImportanceTableViewController: UITableViewController {
    
    var delegate: CanRecieveImportance?

    var importanceList = ["Important", "Secondary"]


    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            var txtImpt = ""
            txtImpt = importanceList[indexPath[1]]
            print(importanceList[indexPath[1]])
            delegate?.passImportanceDataBack(data: txtImpt)
            dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }

}
