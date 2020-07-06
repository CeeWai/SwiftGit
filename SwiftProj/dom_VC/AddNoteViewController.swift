//
//  AddNoteViewController.swift
//  SwiftProj
//
//  Created by Dom on 5/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class AddNoteViewController: UIViewController, UITextViewDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        notesBody.delegate = self
        // Do any additional setup after loading the view.
        notesBody.textColor = UIColor.lightGray
    }
    

    @IBOutlet weak var notesBody: UITextView!
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Note"
            textView.textColor = UIColor.lightGray
        }
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

