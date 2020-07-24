/*
 See LICENSE folder for this sample’s licensing information.
 
 Abstract:
 ViewController that shows documents, allows to edit them and to ask questions about them.
 */

import UIKit
import CoreML
import TesseractOCR
import FirebaseAuth

class DetailViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate, G8TesseractDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var questionTextField: UITextField!
    @IBOutlet weak var documentTextView: UITextView!
    @IBOutlet weak var questionTextFieldBottomLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var cameraOCRBttn: UIButton!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var errLabel: UILabel!
    @IBOutlet weak var deleteDoc: UIBarButtonItem!
    
    let bert = BERT()
    
    func configureView() {
        guard let detail = detailItem else {
            return
        }
        
        title = detail.title
        
        guard let textView = documentTextView else {
            return
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        
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
        
        // set delegate for OCR function
        //
        if let tesseract = G8Tesseract(language: "eng") {
            tesseract.delegate = self
        }
        
        titleTextField.text = detailItem?.title
        documentTextView.text = detailItem?.body
        
    }
    
    @IBAction func deleteDocPressed(_ sender: Any) {
        DataManager.deleteDoc(detailItem!)
        self.dismiss(animated: true, completion: nil)
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ocrButtonPressed(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        // Setting this to true allows the user to crop and scale
        // the image to a square after the image is selected.
        //
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true)
    }
    
    // This function is called after the user took the picture,
    // or selected a picture from the photo library.
    // When that happens, we simply assign the image binary,
    // represented by UIImage, into the imageView we created.
    //
    // iOS doesn’t close the picker controller
    // automatically, so we have to do this ourselves by calling
    // dismissViewControllerAnimated.
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    {
        let chosenImage : UIImage = info[.editedImage] as! UIImage
        print()
        if let tesseract = G8Tesseract(language: "eng") {
            tesseract.delegate = self
            tesseract.image = chosenImage.g8_blackAndWhite()
            tesseract.recognize()
            
            self.documentTextView.text = tesseract.recognizedText
            self.documentTextView.textColor = UIColor.label
        }
        //self.imageView!.image = chosenImage
        // This saves the image selected / shot by the user
        //
        //UIImageWriteToSavedPhotosAlbum(chosenImage, nil, nil, nil)

        // This closes the picker
        //
        picker.dismiss(animated: true)
        
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
        
        // Run the search in the background to keep the UI responsive.
        DispatchQueue.global(qos: .userInitiated).async {
            // Use the BERT model to search for the answer.
            let answer = self.bert.findAnswer(for: searchText, in: detail.body!)
            
            // Update the UI on the main queue.
            DispatchQueue.main.async {
                textField.text = String(answer)
                textField.placeholder = placeholder
            }
        }
        return true
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
        
        var userDoc = Document(docID: "", title: "", body: "", docOwner: "")
        
        if self.detailItem?.docID != nil && self.detailItem?.docID != "" {
            userDoc = Document(docID: detailItem?.docID, title: self.titleTextField.text, body: self.documentTextView.text, docOwner: user?.email)
        } else {
            userDoc = Document(docID: "", title: self.titleTextField.text, body: self.documentTextView.text, docOwner: user?.email)
        }

        if self.detailItem?.docID != nil && self.detailItem?.docID != ""{
            print("DOCID = \(self.detailItem?.docID)")

            //print("Found that docID is empty \(self.detailItem?.docID)")
            //userDoc.docID = self.detailItem?.docID
            DataManager.insertOrReplaceDoc(userDoc)
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: true)
        } else {
            DataManager.loadDocs{ fullUserDocList in
                //print("Found that docID is NOT empty \(self.detailItem?.docID)")

                self.errLabel.isHidden = true
                //userDoc.docID = "\(user!.uid)D\(fullUserDocList.count)"
                DataManager.insertOrReplaceDoc(userDoc)
                self.dismiss(animated: true, completion: nil)
                self.navigationController?.popViewController(animated: true)
            }
        }


    }
    
    // MARK: - UITextViewDelegate
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if self.detailItem?.docID != nil || self.detailItem?.docID != "" {
            detailItem = Document(docID: detailItem?.docID, title: titleTextField.text ?? "Document", body: textView.text, docOwner: detailItem?.docOwner)
        } else {
            detailItem = Document(docID: "", title: titleTextField.text ?? "Document", body: textView.text, docOwner: detailItem?.docOwner)
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
