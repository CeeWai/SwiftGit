//
//  addPost.swift
//  SwiftTest
//
//  Created by Yap Wei xuan on 15/7/20.
//  Copyright © 2020 Yap Wei xuan. All rights reserved.
//

import UIKit

class addPost: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBAction func addImage(_ sender: Any) {
        let image = UIImagePickerController()
        image.delegate = self
        image.allowsEditing = false
        image.sourceType = UIImagePickerController.SourceType.photoLibrary
        self.present(image, animated: true) {
            
        }
        
    }
    
    @IBOutlet weak var selectedImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            selectedImage.image = image
        }
        else {
            //error message
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    @IBOutlet weak var descInput: UITextField!
    @IBOutlet weak var titleInput: UITextField!
    @IBAction func post(_ sender: Any) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        let title = titleInput.text
        let desc = descInput.text
        //let image = selectedImage.image
        let vc = segue.destination as! WXViewController
        vc.data.append(
            [Post(
                postTitle: (title)!,
                postDesc: (desc)!,
                username: "John",
                postDate: "26/5/20",
                postImage: "image1",
                upvotes: 2,
                downvotes: 3,
                commentCount: 3,
                profImg: "image4"
            )]
        )
        vc.postList1.append(Post(
            postTitle: (title)!,
            postDesc: (desc)!,
            username: "John",
            postDate: "26/5/20",
            postImage: "image1",
            upvotes: 2,
            downvotes: 3,
            commentCount: 3,
            profImg: "image4"
        ))
    }

}
