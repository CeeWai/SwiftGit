//
//  startScreenViewController.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 27/5/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit
import FirebaseAuth

class startScreenViewController: UIViewController {

    @IBOutlet weak var mainView: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupView()
        
        if Auth.auth().currentUser != nil {
             DispatchQueue.main.async {
                 let homeViewController = (self.storyboard?.instantiateViewController(identifier: "MainController"))
                 self.view.window?.rootViewController = homeViewController
                 self.present(homeViewController!, animated: true)
             }
         }

    }

    
    private func setupView() {
        let path = URL(fileURLWithPath: Bundle.main.path(forResource: "startScreenVid", ofType: "mp4") ?? "")
        print("path to the vid: \(path)")
        let player = AVPlayer(url: path)
        
        let newLayer = AVPlayerLayer(player: player)
        newLayer.frame = self.mainView.frame
        self.mainView.layer.addSublayer(newLayer)
        newLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        player.play()
        NotificationCenter.default.addObserver(forName: .AVPlayerItemDidPlayToEndTime, object: player.currentItem, queue: .main) { [weak self] _ in
            player.seek(to: CMTime.zero)
            player.play()
        }
    }

}
