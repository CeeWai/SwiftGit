//
//  RepeatTableViewController.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 26/6/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

protocol CanRecieveRepeat {
    func passRepeatDataBack(data: String)
}

class RepeatTableViewController: UITableViewController {
    
    var delegate: CanRecieveRepeat?
    @IBOutlet var repeatTableView: UITableView!
    var repeatList = ["Never", "Daily", "Weekly"]

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .none
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            var txtRepeat = ""
            txtRepeat = repeatList[indexPath[1]]
            print(repeatList[indexPath[1]])
            delegate?.passRepeatDataBack(data: txtRepeat)
            dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        }
    }

}
