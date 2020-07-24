//
//  PostDetailViewController.swift
//  SwiftTest
//
//  Created by Yap Wei xuan on 12/7/20.
//  Copyright © 2020 Yap Wei xuan. All rights reserved.
//

import UIKit

class PostDetailViewController: UIViewController {
    
    var postItem : Post?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        postTitle.text = postItem?.postTitle
        postImg.image = UIImage(named:(postItem?.postImage)!)
        postDate.text = postItem?.postDate
        username.text =  postItem?.username
        profImg.image = UIImage(named:(postItem?.profImg)!)
        postDesc.text = postItem?.postDesc
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postDesc: UILabel!
    @IBOutlet weak var postImg: UIImageView!
    @IBOutlet weak var postDate: UILabel!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var profImg: UIImageView!
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
