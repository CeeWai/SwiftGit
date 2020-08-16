//
//  FullPostViewController.swift
//  Forun
//
//  Created by Maxie Yap on 7/8/20.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class FullPostViewController: UIViewController,  UITableViewDelegate, UITableViewDataSource {
    
    static let db = Firestore.firestore()
    
    var postList : [Post] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        postItem!.comment.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : CommentCell = tableView.dequeueReusableCell(withIdentifier: "CommentCell", for: indexPath) as! CommentCell
        
        let p = postItem!.comment[indexPath.row]
        cell.commentLabel.text = String(postItem!.comment[indexPath.row])
        
        return cell
    }
    
    func loadPosts()
    {
        ForumDataManager.loadPosts()
            {
                postListFromFirestore in
                
                self.postList = postListFromFirestore
                self.commentView.reloadData()
        }
    }
    
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postdesc: UILabel!
    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var commentView: UITableView!
    
    var postItem : Post?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        commentView.dataSource = self
        loadPosts()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        postTitle.text = postItem?.postTitle
        postdesc.text = postItem?.postDesc
        postImage.image = UIImage(named: (postItem?.postImage)!)
    }
    
    @IBOutlet weak var commentInput: UITextField!
    
    @IBAction func postBtnPressed(_ sender: Any) {
        if commentInput.text == ""
        {
            let alert = UIAlertController(
                title: "Please enter a comment",
                message: "",
                preferredStyle:
                .alert)
            
            alert.addAction(UIAlertAction(title: "OK",
                                          style: .default,
                                          handler: nil))
            
            self.present(alert, animated: true, completion: nil)
            
            return
        }
        
        let comment = commentInput.text!
        postItem!.commentCount += 1
        
        let comments = FullPostViewController.db.collection("posts").document(postItem!.postTitle)
        comments.updateData([
            "comment" : FieldValue.arrayUnion([comment]),
            "commentCount" : postItem!.commentCount
        ])
        
        
        commentInput.text = ""
        
        var viewControllers = self.navigationController?
            .viewControllers
        let parent = viewControllers?[0] as! ForumViewController
        parent.loadPosts()
        // parent.tableView?.reloadData()
        
        // close this view controller and pop back out to
        // the one that shows the list of movies.
        //
        self.navigationController?.popViewController(animated: true)
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
