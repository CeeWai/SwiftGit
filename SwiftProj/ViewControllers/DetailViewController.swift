/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 ViewController that shows documents, allows to edit them and to ask questions about them.
 */

import UIKit
import CoreML
import TesseractOCR
import FirebaseAuth
import FirebaseStorage
import Photos
import FirebaseUI
import Vision

class DetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, G8TesseractDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var documentTextView: UITextView!
    @IBOutlet weak var questionTextFieldBottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var cameraOCRBttn: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var errLabel: UILabel!
    @IBOutlet weak var deleteDoc: UIBarButtonItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var mainImageView: UIImageView!
    var selectedCell = 0
    let bert = BERT()
    var imageList: [UIImage] = []
    var imageDocList: [DocImage] = []
    var newimageDocStoreList: [DocImageStore] = []
    //var imageDocStoreList: [DocImageStore] = []
    var imgLinkList: [ImageLink] = []
    var imageTaken: Bool = false
    var placeIndexPath = NSIndexPath(item: 0, section: 0)

    func configureView() {
        guard let detail = detailItem else {
            return
        }
        
        title = detail.title
        
        guard let textView = documentTextView else {
            return
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageDocList.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellID = indexPath.row < imageDocList.count ? "normalCell" : "specialCell"

        print("INDEXPATH \(indexPath)")
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)

        if indexPath.row == self.selectedCell {
            cell.contentView.layer.borderColor = UIColor.systemRed.cgColor
            cell.contentView.layer.borderWidth = 1.5
        } else {
            cell.contentView.layer.borderColor = UIColor.clear.cgColor
            cell.contentView.layer.borderWidth = 1.5
        }

        setupCell(cell: cell, indexPath: indexPath, type: cellID)

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print("INDEXPATH @ \(indexPath)")
        self.mainImageView.image = self.imageDocList[indexPath.row].image
        self.documentTextView.text = self.imageDocList[indexPath.row].imageDesc
        self.selectedCell = indexPath.row
        self.collectionView.reloadData()
    }
    
    func setupCell(cell: UICollectionViewCell, indexPath: IndexPath, type: String) {
        switch(type) {
        case "normalCell":
            setupImageCell(cell: cell as! ImageCell, indexPath: indexPath)
        case "specialCell":
            setupSpecialCell(cell: cell as! SpecialCell, indexPath: indexPath)
        default:
            break
        }
    }

    func setupImageCell(cell: ImageCell, indexPath: IndexPath) {
        cell.ImageView.image = imageDocList[indexPath.row].image
    
    }

    func setupSpecialCell(cell: SpecialCell, indexPath: IndexPath) {
        cell.addBtn.addTarget(self, action: #selector(addButtonTapped), for: UIControl.Event.touchUpInside)
    }
    
    @objc func addButtonTapped(sender: UIButton) {
        print("Show image picker UI")
        let picker = UIImagePickerController()
        picker.delegate = self
        // Setting this to true allows the user to crop and scale
        // the image to a square after the image is selected.
        //
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
        if let dItem = self.detailItem?.docImages {
            print("Not nill")
        } else {
            self.detailItem?.docImages = []
        }
        
        documentTextView.layer.cornerRadius = 10
        documentTextView.layer.borderWidth = 0.4
        if self.traitCollection.userInterfaceStyle == .dark {
            // User Interface is Dark
            documentTextView.layer.borderColor = UIColor.white.cgColor
            documentTextView.layer.backgroundColor = UIColor.black.cgColor
        } else {
            // User Interface is Light
            documentTextView.layer.borderColor = UIColor.black.cgColor
            documentTextView.layer.backgroundColor = UIColor.white.cgColor
            
        }
    }
    
    @IBAction func deleteDocPressed(_ sender: Any) {
        DataManager.deleteDoc(detailItem!)
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    // This function is called after the user took the picture,
    // or selected a picture from the photo library.
    // When that happens, we simply assign the image binary,
    // represented by UIImage, into the imageView we created.
    //
    // iOS doesn’t close the picker controller
    // automatically, so we have to do this ourselves by calling
    // dismissViewControllerAnimated.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let chosenImage : UIImage = info[.editedImage] as! UIImage
        if let tesseract = G8Tesseract(language: "eng") {
            tesseract.delegate = self
            tesseract.image = chosenImage.g8_blackAndWhite()
            tesseract.recognize()
            
            if let url = info[UIImagePickerController.InfoKey.imageURL] as? URL {
                //print(url)
                imageList.append(chosenImage)
                uploadToCloud(fileURL: url)
                if let dItem = self.detailItem?.docImages {
                    print("Not nill")
                } else {
                    self.detailItem?.docImages = []
                }
                
                if self.imageDocList.count == 0 {
                    self.mainImageView.image = chosenImage
                }
                
                if (self.detailItem?.docImages == nil) {
                    self.detailItem?.setEmptyDocImages()
                    self.detailItem?.docImages = []
                    let user = Auth.auth().currentUser

                    if let user = user {
                        let uid = user.uid
                        let email = user.email
                    }
                    
                    self.detailItem = Document(docID: detailItem?.docID, title: self.titleTextField.text, body: tesseract.recognizedText, docOwner: user?.email, docImages: [])
                }
                
                self.detailItem?.docImages!.append(url.lastPathComponent)
                print("DETAIL ITEM DOC IMAGES IS \(self.detailItem?.docImages!) and url.lastPathComponent is \(url.lastPathComponent)")
                
                var cImage = CIImage(cgImage: chosenImage.cgImage!)
                
                // Load the ML model through its generated class
                guard let model = try? VNCoreMLModel(for: Resnet50().model) else {
                    fatalError("can't load Places ML model")
                }
                
                // Create a Vision request with completion handler
                let request = VNCoreMLRequest(model: model) { [weak self] request, error in
                    let results = request.results as? [VNClassificationObservation]
                    
                    var outputText: [String] = []
                    
                    for res in results!{
                        if Int(res.confidence * 100) > 0 {
                            outputText.append(res.identifier)
                            print("\(Int(res.confidence * 100))% it's \(res.identifier)\n")
                        }
                    }
                    DispatchQueue.main.async { [weak self] in
                        
                        self!.imageDocList.append(DocImage(image: chosenImage, imageDesc: tesseract.recognizedText, objPredictions: outputText))
                        
                        self!.newimageDocStoreList.append(DocImageStore(docID: "", imageDesc: tesseract.recognizedText, imageLink: url.lastPathComponent, objPredictions: outputText))
                        
                        self?.documentTextView.text = tesseract.recognizedText
                        //print(outputText)
                        self?.selectedCell = (self?.imageDocList.count)! - 1
                        
                        self?.mainImageView.image = chosenImage
                        self!.imageTaken = true
                        self!.collectionView.reloadData()
                        
                    }
                }
                
                // Run the CoreML3 Resnet50 classifier on global dispatch queue
                let handler = VNImageRequestHandler(ciImage: cImage)
                DispatchQueue.global(qos: .userInteractive).async {
                    do {
                        try handler.perform([request])
                    } catch {
                        print(error)
                    }
                }
                
                
            }
        }
        // This saves the image selected / shot by the user
        //
        //UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil)

        // This closes the picker
        //
        picker.dismiss(animated: true)
        
    }
    
    func uploadToCloud(fileURL: URL) {
        let storage = Storage.storage()
        let data = Data()
        
        let storageRef = storage.reference()
        
        let localFile = fileURL
        
        let photoRef = storageRef.child(fileURL.lastPathComponent)
        
        let uploadTask = photoRef.putFile(from: localFile, metadata: nil, completion: {
            (metadata, err) in
            guard let metadata = metadata else {
                print(err?.localizedDescription)
                return
            }
            print("Photo Uploaded")
        })
    }
    
    func progressImageRecognition(for tesseract: G8Tesseract) {
        print("Recognition Progress \(tesseract.progress) %")
    }
    
    func imagePickerControllerDidCancel( _ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
    
    var detailItem: Document? {
        didSet {
            configureView()
        }
    }
    
    // MARK: - UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // The user pressed the `Search` button.
        guard let detail = detailItem else {
            return false
        }
        
        // Update UI to indicate the app is searching for an answer.
        let searchText = textField.text ?? ""
        let placeholder = textField.placeholder
        textField.placeholder = "Searching..."
        textField.text = ""
        
        // stop words to be removed from the filter later
        //
        var stopwords = ["i", "me", "my", "myself", "we", "our", "ours", "ourselves", "you", "your", "yours", "yourself", "yourselves", "he", "him", "his", "himself", "she", "her", "hers", "herself", "it", "its", "itself", "they", "them", "their", "theirs", "themselves", "what", "which", "who", "whom", "this", "that", "these", "those", "am", "is", "are", "was", "were", "be", "been", "being", "have", "has", "had", "having", "do", "does", "did", "doing", "a", "an", "the", "and", "but", "if", "or", "because", "as", "until", "while", "of", "at", "by", "for", "with", "about", "against", "between", "into", "through", "during", "before", "after", "above", "below", "to", "from", "up", "down", "in", "out", "on", "off", "over", "under", "again", "further", "then", "once", "here", "there", "when", "where", "why", "how", "all", "any", "both", "each", "few", "more", "most", "other", "some", "such", "no", "nor", "not", "only", "own", "same", "so", "than", "too", "very", "s", "t", "can", "will", "just", "don", "should", "now", "\n", "whose", "one", "two", "three", "four", "five", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        var set = CharacterSet.punctuationCharacters

        
        // Run the search in the background to keep the UI responsive.
        DispatchQueue.global(qos: .userInitiated).async {

            // Create a list of document strings and the levenshtein values of each of them
            // These will be used later for the checking of where to use bert on
            //
            var chosenDoc = ""
            var listOfDocs: [String] = []
            var similarityList: [Double] = []
            
            // Remove Punctuations from the search text
            var searchTxtList = searchText.components(separatedBy: .punctuationCharacters).joined().components(separatedBy: " ")
            for word in stopwords { // Removing stopwords from search text
                for text in searchTxtList {
                    if text.lowercased() == word.lowercased() {
                        searchTxtList.remove(at: searchTxtList.firstIndex(of: text)!)
                    }
                }
            }
            
            
            var c = 0 // check for images
            var found = false
            for iDoc in self.imageDocList {
                print("self.imagedl \(self.imageDocList)")

                var idvIDocPred = iDoc.objPredictions!
                for pred in idvIDocPred {
                    print("pred: \(pred)")
                    for p in pred.components(separatedBy: .punctuationCharacters).joined().components(separatedBy: " ") {
                        print(p)
                        for sText in searchTxtList {
                            if p.lowercased() == sText.lowercased() {
                                print("YO WE FOUND SOMETHING DAWG \(p.lowercased()) == \(sText.lowercased())")
                                // Update the UI on the main queue.
                                found = true

                                DispatchQueue.main.async {
                                    textField.text = "We found a: \(sText.lowercased())"
                                    textField.placeholder = placeholder
                                    self.mainImageView.image = iDoc.image
                                    self.documentTextView.text = iDoc.imageDesc

                                    self.selectedCell = c - 1
                                    
                                    self.collectionView.reloadData()
                                    
                                }
                                break

                            }
                        }
                    }
                }
                
                c += 1
            }
            
            if !found {
                var searchtxt = searchTxtList.joined(separator: " ")

                //print("stop words removed from searchtxt \(searchtxt)")
                // removing all new lines (\n) and stop words
                for imgDoc in self.imageDocList {
                    var sentence = imgDoc.imageDesc!.replacingOccurrences(of: "\n", with: " ")

                    var puncList = sentence.components(separatedBy: .punctuationCharacters).joined().components(separatedBy: " ")

                    //
                    for word in stopwords {
                        for filteredWord in puncList {
                            if filteredWord.lowercased() == word.lowercased() {
                                puncList.remove(at: puncList.firstIndex(of: filteredWord)!)
                            }
                        }
                    }
                    var fullSentencefiltered = puncList.joined(separator: " ")


                    // Append the OCR'd text from the images into the first list
                    //
                    listOfDocs.append(imgDoc.imageDesc!)
                    similarityList.append(self.simpleSimilarityBetween(sentence: fullSentencefiltered, searchStr: searchtxt))
                }
            
                // Check if all the array items have the same value
                // returns an error if they are the same value
                // computes using the bert model if otherwise
                //
                let set = NSSet(array: similarityList)
                if set.count == 0 {
                    DispatchQueue.main.async {
                        textField.text = "We did not get that. Ask another question instead!"
                        //print(set)
                        textField.placeholder = placeholder
                    }
                } else {
                    
                    // Find out which one is the one with the highest points
                    // which will be selected to be used in the bert model
                    //
                    chosenDoc = listOfDocs[similarityList.firstIndex(of: similarityList.max()!)!]
                    
                    // Use the BERT model to search for the answer.
                    //
                    let answer = self.bert.findAnswer(for: searchText, in: chosenDoc)

                    // Update the UI on the main queue.
                    DispatchQueue.main.async {
                        textField.text = String(answer)
                        textField.placeholder = placeholder
                        self.mainImageView.image = self.imageDocList[similarityList.firstIndex(of: similarityList.max()!)!].image
                        self.documentTextView.text = self.imageDocList[similarityList.firstIndex(of: similarityList.max()!)!].imageDesc
                        //self.changeColorOfCellForIndexPath(item: 0, section: similarityList.firstIndex(of: similarityList.max()!)!)
                        // TODO add the highlighted color of the collectionview

                        self.selectedCell = similarityList.firstIndex(of: similarityList.max()!)!
                        
                        self.collectionView.reloadData()
                    }
                }
            }
        }
        return true
    }
    
    // Finds whether there is reoccuring words and then returns based on that
    //
    func simpleSimilarityBetween(sentence: String, searchStr: String)-> Double {
        var similarityMetric: Double = 0
        let searchStrList = searchStr.components(separatedBy: " ")
        let sentenceStrList = sentence.components(separatedBy: " ")

        for searchWord in searchStrList {
 
            if sentenceStrList.contains(searchWord) {
                similarityMetric += 2
            } else {
                similarityMetric -= 0.1
            }
        }
        
        return Double(similarityMetric)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        configureView()
        return true
    }
    
    
    @IBAction func saveButtonPressed(_ sender: Any) {
        if titleTextField.text!.isEmpty || documentTextView.text.isEmpty {
            errLabel.text = "Please enter all fields!"
            errLabel.isHidden = false
            
            return
        }
        let user = Auth.auth().currentUser
        if let user = user {
            let uid = user.uid
            let email = user.email
        }
        
        var userDoc = Document(docID: "", title: "", body: "", docOwner: "", docImages: [])
        
        if self.detailItem?.docID != nil && self.detailItem?.docID != "" {
            userDoc = Document(docID: detailItem?.docID, title: self.titleTextField.text, body: self.documentTextView.text, docOwner: user?.email, docImages: self.detailItem?.docImages)
        } else {
            userDoc = Document(docID: "", title: self.titleTextField.text, body: self.documentTextView.text, docOwner: user?.email, docImages: self.detailItem?.docImages)
        }
        
        if self.detailItem?.docID != nil && self.detailItem?.docID != ""{
            print("DOCID = \(self.detailItem?.docID)")

            //print("Found that docID is empty \(self.detailItem?.docID)")
            //userDoc.docID = self.detailItem?.docID
            DataManager.insertOrReplaceDoc(userDoc, self.newimageDocStoreList)
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        } else {
            DataManager.loadDocs{ fullUserDocList in
                //print("Found that docID is NOT empty \(self.detailItem?.docID)")

                self.errLabel.isHidden = true
                //userDoc.docID = "\(user!.uid)D\(fullUserDocList.count)"
                DataManager.insertOrReplaceDoc(userDoc, self.newimageDocStoreList)
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }


    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.detailItem?.docID != nil || self.detailItem?.docID != "" {
            detailItem = Document(docID: detailItem?.docID, title: titleTextField.text ?? "Document", body: textView.text, docOwner: detailItem?.docOwner, docImages: detailItem?.docImages)
        } else {
            detailItem = Document(docID: "", title: titleTextField.text ?? "Document", body: textView.text, docOwner: detailItem?.docOwner, docImages: detailItem?.docImages)
        }
    }
    
    // MARK: - Keyboard Event Handling
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow),
                                               name: UIWindow.keyboardWillShowNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIWindow.keyboardWillHideNotification,
                                               object: nil)
        
        titleTextField.text = detailItem?.title
        documentTextView.text = detailItem?.body
        collectionView.delegate = self
        collectionView.dataSource = self
        
        if imageTaken == false {
            if let theDocID = self.detailItem?.docID { // handle if the user is trying to ADD a new material
                DataManager.loadDocImageStoreById((self.detailItem?.docID!)!, onComplete: {
                    docImgStoreList in
                    
                    if let dItems = self.detailItem?.docImages {
                        if dItems.count > 0 {
                            let storage = Storage.storage()
                            //var reference: StorageReference!
                            var count = 0
                            var anotherCount = 0
                            
                            let storageRef = storage.reference()
                            for img in 0...dItems.count - 1 {
                                let ref = storageRef.child(docImgStoreList[anotherCount].imageLink!)
                                anotherCount += 1
                                ref.downloadURL { (url, error) in
                                    if let error = error {
                                        print(error)
                                        return
                                    }
                                    
                                    let data = NSData(contentsOf: url!)
                                    let image = UIImage(data: data! as Data)
                                    
                                    self.imageList.append(image!)
                                    self.imgLinkList.append(ImageLink(image: image!, imgLink: url?.lastPathComponent))
                                    self.imageDocList.append(DocImage(image: image!, imageDesc: docImgStoreList[count].imageDesc, objPredictions: docImgStoreList[count].objPredictions))
                                    
                                    self.collectionView.reloadData()
                                    
                                    count += 1
                                    
                                    if count == 1 { // set all the environments for the first item
                                        self.mainImageView.image = image
                                        self.documentTextView.text = self.imageDocList[0].imageDesc
                                    }
                                    
                                    if count == self.detailItem?.docImages?.count {
                                        self.sortImageDocList()
                                    }
                                    
                                }
                                
                                self.collectionView.reloadData()
                                
                            }
                            
                            self.selectedCell = 0
                        }
                    }
                    
                    self.collectionView.reloadData()
                    
                })
            } else {
                if !UIImagePickerController.isSourceTypeAvailable(.camera) { // handle if device has no camera
                    let alertController = UIAlertController(title: nil, message: "Device has no camera.", preferredStyle: .alert)

                    let okAction = UIAlertAction(title: "K", style: .default, handler: { (alert: UIAlertAction!) in
                    })

                    alertController.addAction(okAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    // Handle if device has camera
                    print("THIS IS A WHOLE NEW DOC")
                    let vc = UIImagePickerController()
                    vc.sourceType = .camera
                    vc.allowsEditing = true
                    vc.delegate = self
                    present(vc, animated: true)
                }

            }
        }

    }
    
    // Because downloadURL is async in nature, we wil have to
    // sort the imageDocList and imagelists after appending the images.
    //
    func sortImageDocList() {
        var formatLink = self.detailItem!.docImages!
        var imgL = self.imgLinkList
        var hardCodedList: [ImageLink] = []
        for fLink in formatLink {
            for link in imgL {
                if fLink == link.imgLink {
                    hardCodedList.append(link)
                }
            }
        }
        
        if hardCodedList.count > 0 {
            for i in 0...hardCodedList.count - 1 {
                var hardCodedImage = hardCodedList[i]
                self.imageList[i] = hardCodedImage.image!
                self.imgLinkList[i] = ImageLink(image: hardCodedImage.image, imgLink: hardCodedImage.imgLink)
                var imgDoc = self.imageDocList[i]
                self.imageDocList[i] = DocImage(image: hardCodedImage.image, imageDesc: imgDoc.imageDesc, objPredictions: imgDoc.objPredictions)
                print("THE VALUE OF LINK IMAGE IS \(hardCodedImage.imgLink)")
            }
        }

        
        self.mainImageView.image = hardCodedList[0].image
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.removeObserver(self, name: UIWindow.keyboardWillHideNotification, object: nil)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        questionTextField.becomeFirstResponder()
        
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        animateBottomLayoutConstraint(from: notification)
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        animateBottomLayoutConstraint(from: notification)
    }
    
    func animateBottomLayoutConstraint(from notification: NSNotification) {
        guard let userInfo = notification.userInfo else {
            print("Unable to extract: User Info")
            return
        }
        
        guard let animationDuration = (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue else {
            print("Unable to extract: Animation Duration")
            return
        }
        
        guard let keyboardEndFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else {
            print("Unable to extract: Keyboard Frame End")
            return
        }
        
        guard let keyboardBeginFrame = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue else {
            print("Unable to extract: Keyboard Frame Begin")
            return
        }
        
        guard let rawAnimationCurve = (userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber)?.uintValue else {
            print("Unable to extract: Keyboard Animation Curve")
            return
        }
        
        let offset = keyboardEndFrame.minY - keyboardBeginFrame.minY
        questionTextFieldBottomLayoutConstraint.constant -= offset
        
        let curveOption = UIView.AnimationOptions(rawValue: rawAnimationCurve << 16)
        
        UIView.animate(withDuration: animationDuration,
                       delay: 0.0,
                       options: [.beginFromCurrentState, curveOption],
                       animations: { self.view.layoutIfNeeded() },
                       completion: nil)
    }
}

