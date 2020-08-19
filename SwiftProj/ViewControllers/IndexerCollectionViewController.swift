//
//  IndexerCollectionViewController.swift
//  SwiftProj
//
//  Created by Ong Chong Yong on 18/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import FirebaseStorage

private let reuseIdentifier = "indexCell"

class IndexerCollectionViewController: UICollectionViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    @IBOutlet var cView: UICollectionView!
    var docListTest: [Document] = [Document(docID: "ID1", title: "The fox and the uncle jumped over the uncle", body: "The quick brown fox jumps over the lazy dog and killed the uncle whilst he was in mid-air, the airbourne fox pulled out his p90 and started blasting the crap out of all the kids in the vicinity. 26 deaths and 4 was injured by the end of the mass shooting. Many lives could have been saved if someone did their god damn job right. Dammit john, it's all your fault.", docOwner: "touchmyuncleeveryday@gmail.com", docImages: []), Document(docID: "ID2", title: "Little Red Riding Hoodlum", body: "Warning: The streets of the Little Red Hood has been terrorized by the gang known as the Little Red Riding Peeps. Their leader, the man himself, Little Red Riding Grandma Wolf thing idk lol. The grandma shot her granddaughter in the chest when she was just 5 years old. He has like 0 mercy to all the kids in the world. Only the avatar, master of all 4 elephants could stop them. But when the world needed him most, he vanished. A hundred years has past and a my brother and I discovered a new avatar, an Airbender named 'Aang'. He has a lot to learn before he could save anyone. But I believe Aang can save the world.", docOwner: "touchmyuncleeveryday@gmail.com", docImages: [])]
    var docList: [Document] = []
    var imageLinkList: [ImageLink] = []
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
        self.imageLinkList = []
        DataManager.loadDocs{ fullUserDocList in
            self.docList = fullUserDocList
            print(self.docList)
            self.cView.reloadData()
            self.collectionView.reloadData()
            
            
            let storage = Storage.storage()
            //var reference: StorageReference!
            let storageRef = storage.reference()
            if self.docList.count > 0 {
                for i in 0...self.docList.count - 1 {
                    if let dList = self.docList[i].docImages {
                        if dList.count > 0 {
                            let ref = storageRef.child(self.docList[i].docImages![0])
                            ref.downloadURL { (url, error) in
                                if let error = error {
                                    print(error)
                                    return
                                }
                                
                                let data = NSData(contentsOf: url!)
                                let image = UIImage(data: data! as Data)
                                
                                
                                self.imageLinkList.append(ImageLink(image: image, imgLink: self.docList[i].docImages![0]))
                                
                                print("ADDED \(self.docList[i].docImages![0])")
                                
                                self.collectionView.reloadData()
                                
                            }

                        } else {
                            self.imageLinkList.append(ImageLink(image: UIImage(named: "default_image.png")!, imgLink: ""))
                        }
                    }
                    
                }
            }
        }

    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return docList.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! IndexCell
        // Configure the individual cell
        //print(docList[indexPath.row].title)
        cell.titleLabel.text = docList[indexPath.row].title
        print("DOCLIST \(docList[indexPath.row].title), \(docList[indexPath.row].docImages)")
        //cell.textView.text = docList[indexPath.row].body
        //cell.bgImg.image =

//        if imageLinkList.count > 0 {
//            if imageLinkList.count - 1 <= indexPath.row {
//                if docList[indexPath.row].docImages!.count > 0 {
//                    if docList[indexPath.row].docImages![0] == imageLinkList[indexPath.row].imgLink {
//                        print("THERES SOMETHING")
//                        cell.bgImg.image = imageLinkList[indexPath.row].image
//                    }
//                }
//            }
//        }
        

//        print("\(imageLinkList.count) and \(docList.count)")
//        if imageLinkList.count == docList.count {
//            print("\(imageLinkList.reversed()[indexPath.row].imgLink) was found")
//            cell.bgImg.image = imageLinkList.reversed()[indexPath.row].image
//        }
        
        for imageLink in imageLinkList {
            if docList[indexPath.row].docImages![0] == imageLink.imgLink {
                cell.bgImg.image = imageLink.image
            }
        }

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "docSegue" {
            let detailDocViewController = segue.destination as! DetailViewController
            let myIndexPath = self.cView.indexPathsForSelectedItems?.first

            detailDocViewController.detailItem = self.docList[myIndexPath!.row]
            detailDocViewController.deleteDoc.isEnabled = true
        } else if segue.identifier == "addDocSegue" {
            let detailDocViewController = segue.destination as! DetailViewController

            detailDocViewController.imageList = []
            detailDocViewController.imageDocList = []
            detailDocViewController.newimageDocStoreList = []
            detailDocViewController.imageDocStoreList = []
            detailDocViewController.imgLinkList = []
            detailDocViewController.detailItem?.docImages = []
        }
    }


}
