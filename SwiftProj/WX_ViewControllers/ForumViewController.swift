//
//  ViewController.swift
//  Forun
//
//  Created by Maxie Yap on 6/8/20.
//

import UIKit
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class ForumViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    @IBOutlet weak var editBtn: UIBarButtonItem!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var addBtn: UIBarButtonItem!
    
    static let db = Firestore.firestore()
    
    var filteredData : [Post]!
    var filterPost: [Post] = []
    var unfilteredPost : [Post] = []
    var posts : [Post] = []
    
    @IBAction func addPressed(_ sender: Any) {
        
    }
    
    
    @IBAction func editPressed(_ sender: Any) {
        self.postView.setEditing(!postView.isEditing, animated: true)
        
        if postView.isEditing
        {
            self.editBtn.title = "Done"
        }
        else
        {
            self.editBtn.title = "Edit"
        }
    }
    
    var postList : [Post] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchBar.delegate = self
        filteredData = postList
        postView.delegate = self
        posts = postList
        
        loadPosts()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // When there is no text, filteredData is the same as the original data
        // When user has entered text into the search box
        // Use the filter method to iterate over all items in the data array
        // For each item, return true if the item should be included and false if the
        // item should NOT be included
        if (searchText.isEmpty) {
            print("yes")
            loadPosts()
            filterPost.removeAll()
            print(filterPost.count)
        }
        
        filteredData = searchText.isEmpty ? postList : postList.filter { (item: Post) -> Bool in
            // If dataItem matches the searchText, return true to include it
            if (item.postTitle.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil) {
                print(item.postTitle)
                filterPost.append(item)
                //print(filterPost.count)
                postList = filterPost
                //print(postList.count)
            }
            return item.postTitle.range(of: searchText, options: .caseInsensitive, range: nil, locale: nil) != nil
        }
        
        postView.reloadData()
    }
    
    func loadPosts()
    {
        ForumDataManager.loadPosts()
            {
                postListFromFirestore in
                
                self.postList = postListFromFirestore
                self.postView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell : PostCell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        
        let p = postList[indexPath.row]
        cell.postTitle.text = postList[indexPath.row].postTitle
        cell.postDesc.text = postList[indexPath.row].postDesc
        cell.upvotes.text = String(postList[indexPath.row].upvotes)
        cell.commentCount.text = String(postList[indexPath.row].commentCount)
        cell.author.text = postList[indexPath.row].author
        
        cell.postImage.image = UIImage(
        named: postList[indexPath.row].postImage)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete
        {
            let post = postList[indexPath.row]
            postList.remove(at: indexPath.row)
            
            ForumDataManager.deletePost(post)
            
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue,
                          sender: Any?)
    {
        if(segue.identifier == "EditPostDetails")
        {
            let detailViewController = segue.destination as!
            PostDetailViewController
            let myIndexPath = self.postView.indexPathForSelectedRow
            
            if(myIndexPath != nil)
            {
                let post = postList[myIndexPath!.row]
                detailViewController.postItem = post
            }
        }
        
        // Here we check for the AddMovieDetails segue,
        // which is trigger by the user clicking on the +
        // button at the top of the navigation bar
        //
        if(segue.identifier == "AddPostDetails")
        {
            let detailViewController = segue.destination as!
            PostDetailViewController
            let post = Post(postTitle: "",
                            postDesc: "",
                            postImage: "",
                            upvotes: 0,
                            downvotes: 0,
                            commentCount: 0,
                            comment: [],
                            postDate: "",
                            author: "",
                            upvoters: [])
            detailViewController.postItem = post
        }
        
        if(segue.identifier == "ShowPostDetails")
        {
            let detailViewController = segue.destination as! FullPostViewController
            let myIndexPath = self.postView.indexPathForSelectedRow
            if(myIndexPath != nil)
            {
                let post = postList[myIndexPath!.row]
                detailViewController.postItem = post
            }
        }
        
    }

    
    @IBOutlet weak var postView: UITableView!
}

