//
//  ViewController.swift
//  SwiftTest
//
//  Created by Yap Wei xuan on 12/7/20.
//  Copyright © 2020 Yap Wei xuan. All rights reserved.
//

import UIKit
import SwiftUI

class WXViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if searchController.searchBar.text! == "" {
         searchPost = data[0]
        }
        else {
            searchPost = postList1.filter({
                $0.postTitle.lowercased().contains(searchController.searchBar.text!.lowercased())
            })
        }
        self.tableView.reloadData()
    }
    
    
    @IBAction func share(_ sender: Any) {
        let activityVC = UIActivityViewController(activityItems: ["www.google.com"], applicationActivities: nil)
        self.present(activityVC, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return postList1.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //Sort
        postList1 = postList1.sorted(by: {$0.upvotes > $1.upvotes})
        
        let cell : PostCell = tableView.dequeueReusableCell(withIdentifier: "PostCell", for: indexPath) as! PostCell
        let p = postList1[indexPath.row]
        
        cell.imgProf.image = UIImage(named: p.profImg)
        cell.username.text = p.username
        cell.postDate.text = "posted on " + p.postDate
        cell.postImg.image = UIImage(named: p.postImage)
        cell.postTitle.text = p.postTitle
        cell.upvotes.text = String(p.upvotes)
        cell.downvotes.text = String(p.downvotes)
        cell.commentCount.text = String(p.commentCount)
        
        return cell
    }
    
    var comp = DateComponents()
    
    var data = [[
        Post(
            postTitle: "Post 1",
            postDesc: "Post 1 desc",
            username: "John",
            postDate: "26/5/20",
            postImage: "image1",
            upvotes: 2343,
            downvotes: 386,
            commentCount: 3,
            profImg: "image4"
            ),
        
        Post(
            postTitle: "Post 2",
            postDesc: "",
            username: "Bob",
            postDate: "2/7/20",
            postImage: "image2",
            upvotes: 4,
            downvotes: 5,
            commentCount: 3,
            profImg: "image5"
        ),
        
        Post(
            postTitle: "Post 3",
            postDesc: "post 3 desc",
            username: "Jane",
            postDate: "2020-12-13T17:22:46Z",
            postImage: "image3",
            upvotes: 234,
            downvotes: 2,
            commentCount: 3,
            profImg: "image6"
        )
        ]]
    
    var postList1 : [Post] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        searchPost = postList1
        searchController.searchResultsUpdater = self
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        
        postList1.append(Post(
            postTitle: "Post 1",
            postDesc: "Post 1 desc",
            username: "John",
            postDate: "26/5/20",
            postImage: "image1",
            upvotes: 2343,
            downvotes: 386,
            commentCount: 3,
            profImg: "image4"
            ))
        
        postList1.append(Post(
            postTitle: "Post 2",
            postDesc: "",
            username: "Bob",
            postDate: "2/7/20",
            postImage: "image2",
            upvotes: 4,
            downvotes: 5,
            commentCount: 3,
            profImg: "image5"
        ))
        
        postList1.append(Post(
            postTitle: "Post 3",
            postDesc: "post 3 desc",
            username: "Jane",
            postDate: "2020-12-13T17:22:46Z",
            postImage: "image3",
            upvotes: 234,
            downvotes: 2,
            commentCount: 3,
            profImg: "image6"
        ))
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "ShowPostDetails")
        {
            let detailViewController = segue.destination as! PostDetailViewController
            let myIndexPath = self.tableView.indexPathForSelectedRow
            if(myIndexPath != nil)
            {
                let post = data[myIndexPath!.section][myIndexPath!.row]
                detailViewController.postItem = post
            }
        }
    }
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var search: UISearchBar!
    // Search Bar
    var searchPost = [Post]()
    let searchController = UISearchController(searchResultsController: nil)
    
    
    @IBOutlet weak var upvBtn: UIButton!
    @IBAction func upvote(_ sender: Any) {
        self.upvBtn.tintColor = UIColor.red
    }
}

