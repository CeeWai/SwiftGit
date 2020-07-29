//
//  IndexerCollectionViewController.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 18/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit

private let reuseIdentifier = "indexCell"

class IndexerCollectionViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var cView: UICollectionView!
    var docListTest: [Document] = [Document(docID: "ID1", title: "The fox and the uncle jumped over the uncle", body: "The quick brown fox jumps over the lazy dog and killed the uncle whilst he was in mid-air, the airbourne fox pulled out his p90 and started blasting the crap out of all the kids in the vicinity. 26 deaths and 4 was injured by the end of the mass shooting. Many lives could have been saved if someone did their god damn job right. Dammit john, it's all your fault.", docOwner: "touchmyuncleeveryday@gmail.com", docImages: []), Document(docID: "ID2", title: "Little Red Riding Hoodlum", body: "Warning: The streets of the Little Red Hood has been terrorized by the gang known as the Little Red Riding Peeps. Their leader, the man himself, Little Red Riding Grandma Wolf thing idk lol. The grandma shot her granddaughter in the chest when she was just 5 years old. He has like 0 mercy to all the kids in the world. Only the avatar, master of all 4 elephants could stop them. But when the world needed him most, he vanished. A hundred years has past and a my brother and I discovered a new avatar, an Airbender named 'Aang'. He has a lot to learn before he could save anyone. But I believe Aang can save the world.", docOwner: "touchmyuncleeveryday@gmail.com", docImages: [])]
    var docList: [Document] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.cView.delegate = self
        self.cView.dataSource = self
        
        DataManager.loadDocs{ fullUserDocList in
            self.docList = fullUserDocList
            print(self.docList)
            self.cView.reloadData()

        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        DataManager.loadDocs{ fullUserDocList in
            self.docList = fullUserDocList
            print(self.docList)
            self.cView.reloadData()
            self.collectionView.reloadData()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return docList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! IndexCell
        // Configure the cell
        print(docList[indexPath.row].title)
        cell.titleLabel.text = docList[indexPath.row].title
        cell.textView.text = docList[indexPath.row].body

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "docSegue" {
            let detailDocViewController = segue.destination as! DetailViewController
            let myIndexPath = self.cView.indexPathsForSelectedItems?.first

            detailDocViewController.detailItem = self.docList[myIndexPath!.row]
            detailDocViewController.deleteDoc.isEnabled = true
        } else if segue.identifier == "addDocSegue" {

        }
    }


}
