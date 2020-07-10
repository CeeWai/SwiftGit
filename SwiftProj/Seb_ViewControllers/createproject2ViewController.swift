////
////  createproject2ViewController.swift
////  Taskr
////
////  Created by Sebastian on 28/6/20.
////  Copyright © 2020 Sebastian. All rights reserved.
////
//
//import UIKit
//
//class createproject2ViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
//
//    
//    @IBOutlet var skip: UIButton!
//    @IBOutlet var gallery: UIButton!
//    @IBOutlet var Camera: UIButton!
//    @IBOutlet var imageview: UIImageView!
//    var projectitem : Project?
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        Camera.layer.borderWidth = 2;
//        Camera.layer.cornerRadius = 7
//        Camera.layer.borderColor = UIColor.systemRed.cgColor
//        gallery.layer.borderWidth = 2;
//        gallery.layer.cornerRadius = 7
//        gallery.layer.borderColor = UIColor.systemRed.cgColor
//        skip.layer.borderWidth = 2;
//        skip.layer.cornerRadius = 7
//        skip.layer.borderColor = UIColor.systemRed.cgColor
//        if !(UIImagePickerController.isSourceTypeAvailable(
//        .camera)) {
//        // If not, we will just hide the takePicture button //
//        Camera.isHidden = true
//        }
//    }
//    
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destination.
//        // Pass the selected object to the new view controller.
//    }
//    */
//    
//    @IBAction func pressedcamera(_ sender: Any) {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.allowsEditing = true
//        picker.sourceType = .camera
//        self.present(picker,animated: true)
//    }
//    @IBAction func pressedgallery(_ sender: Any) {
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.allowsEditing = true
//        picker.sourceType = .photoLibrary
//        self.present(picker, animated: true)
//    }
//    func imagePickerController(_ picker: UIImagePickerController,
//    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
//    {
//    let chosenImage : UIImage =
//    info[.editedImage] as! UIImage
//    self.imageview!.image = chosenImage
//    let image : UIImage = chosenImage
//    let imagedata:NSData = image.pngData()! as NSData
//    let strBase64 = imagedata.base64EncodedString(options: .lineLength64Characters)
//    projectitem!.imageName = strBase64
//    picker.dismiss(animated: true)
//        skip.setTitle("Continue", for: .normal)
//    }
//    func imagePickerControllerDidCancel(
//    _ picker: UIImagePickerController)
//    {
//    picker.dismiss(animated: true)
//    }
//    @IBAction func pressedskip(_ sender: Any) {
//        ProjectDataManager.insertOrReplaceMovie(project: projectitem!)
//    }
//    
//    override func prepare(for segue: UIStoryboardSegue,
//        sender: Any?){
//        if(segue.identifier == "projectdetail1")
//         {
//        let detailViewController = segue.destination as! projectdetail1ViewController
//            detailViewController.projectItem = self.projectitem
//        }
//         
//    }
//}
