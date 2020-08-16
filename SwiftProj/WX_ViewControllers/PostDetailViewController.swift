//
//  PostDetailViewController.swift
//  Forun
//
//  Created by Maxie Yap on 6/8/20.
//

import UIKit
import FirebaseAuth

class PostDetailViewController: UIViewController {
    
    @IBOutlet weak var postTitleTextField: UITextField!
    
    @IBOutlet weak var postDescTextField: UITextField!
    @IBOutlet weak var postImageTextField: UITextField!
    
    var postItem : Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        
        
        // Validate to ensure that all the fields are
        // entered by the user. If not we show an alert.
        //
        if postTitleTextField.text == "" || postDescTextField.text == ""
        {
            let alert = UIAlertController(
                title: "Please enter all fields",
                message: "",
                preferredStyle:
                .alert)
            
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        // assign the data entered by the user into
        // the movie object
        //
        postItem!.postTitle = postTitleTextField.text!
        postItem!.postDesc = postDescTextField.text!
        postItem!.postImage = postImageTextField.text!
        let currentuser = Auth.auth().currentUser
        if (currentuser != nil) {
            postItem!.author = currentuser!.displayName!
        }
        
        
        if (postItem!.commentCount != 0)
        {
            postItem?.commentCount = postItem!.commentCount + 1
        }
        // Calls the root view controller's table view to
        // to refresh itself.
        //
        var viewControllers = self.navigationController?
            .viewControllers
        let parent = viewControllers?[0] as! ForumViewController
        ForumDataManager.insertOrReplacePost(postItem!)
        parent.loadPosts()
        // parent.tableView?.reloadData()
        
        // close this view controller and pop back out to
        // the one that shows the list of movies.
        //
        self.navigationController?.popViewController(animated: true)
        
        
        
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if postItem != nil
        {
            // Assign the fields from the movie object
            // to all the text fields on the screen.
            //
            // Here we use the special nil-coalesce operator again.
            //
            postTitleTextField.text = postItem!.postTitle
            postDescTextField.text = postItem!.postDesc
            
            
            // If this is an existing movie (that means the movie
            // ID will have some value), disable the user from
            // modifying the movie ID.
            //
            if postItem!.postTitle != ""
            {
                postTitleTextField.isEnabled = false
            }
            
            self.navigationItem.title = postItem!.postTitle
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
}
