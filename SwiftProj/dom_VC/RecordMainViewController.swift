//
//  RecordMainViewController.swift
//  SwiftProj
//
//  Created by Dom on 2/8/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

class RecordingMainViewController: UIViewController {
    
    private var recordingViewController: RecordingViewController? {
        get {
            return children.compactMap({ $0 as? RecordViewController }).first
        }
    }
    private var recorderViewController: RecorderViewController? {
        get {
            return children.compactMap({ $0 as? RecorderViewController }).first
        }
    }
    
    
    @IBOutlet weak var recordView: UIView!
    @IBOutlet weak var recorderView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        if let recorder = self.recorderViewController {
            recorder.delegate = self
        }
        if let record = self.recordViewController {
            record.delegate = self
        }
        self.tabBarController?.tabBar.isHidden = true
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



extension RecordingMainViewController: RecorderViewControllerDelegate {
    func didStartRecording() {
        if let recordings = self.recordViewController {
            recordings.fadeView.isHidden = false
            UIView.animate(withDuration: 0.25, animations: {
                recordings.fadeView.alpha = 1
            })
        }
    }
    
    func didFinishRecording() {
        if let recordings = self.recordViewController {
            recordings.view.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.25, animations: {
                recordings.fadeView.alpha = 0
            }, completion: { (finished) in
                if finished {
                    recordings.fadeView.isHidden = true
                    DispatchQueue.main.async {
                        recordings.loadRecordings()
                    }
                }
            })
        }
    }
}

extension RecordingMainViewController: RecordViewControllerDelegate {
    func didStartPlayback() {
        if let recorder = self.recordViewController {
            recorder.fadeView.isHidden = false
            UIView.animate(withDuration: 0.25, animations: {
                recorder.fadeView.alpha = 1
            })
        }
    }
    
    func didFinishPlayback() {
        if let recorder = self.recordViewController {
            recorder.view.isUserInteractionEnabled = true
            UIView.animate(withDuration: 0.25, animations: {
                recorder.fadeView.alpha = 0
            }, completion: { (finished) in
                if finished {
                    recorder.fadeView.isHidden = true
                }
            })
        }
    }
}
