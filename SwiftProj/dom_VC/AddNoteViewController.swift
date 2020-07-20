//
//  AddNoteViewController.swift
//  SwiftProj
//
//  Created by Dom on 5/7/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import Speech

class AddNoteViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var bodyTV: UITextView!
    @IBOutlet weak var lastEditBBI: UIBarButtonItem!
    @IBOutlet weak var titleTF: UITextField!
    //var ref : DatabaseReference?
    @IBOutlet weak var optionsBtn: UIBarButtonItem!
    //speech stuff below m8s
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US")) // did this because im using vm and not sure where my locale is -dom 16/07/2020
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    var fStore : Firestore?
    var userID : String?
    var userEmail : String?
    var currentNote : dom_note?
    var fromTV : String?
    var isDeleting : Bool?
    override func viewDidLoad() {
        super.viewDidLoad()
        notesBody.delegate = self
        // Do any additional setup after loading the view.
        notesBody.textColor = UIColor.lightGray
        // ref = Database.database().reference()
        fStore = Firestore.firestore()
        let user = Auth.auth().currentUser
        if let user = user {
            userID = user.uid
            userEmail = user.email
        }
        if let CurrentNote = currentNote {
            self.titleTF.text = CurrentNote.noteTitle
            self.bodyTV.text = CurrentNote.noteBody
        }
        else{
            self.bodyTV.text = "body"
        }
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        self.navigationController?.toolbar.isHidden = false
        self.isDeleting = false
        let label = UILabel()
        label.textColor = UIColor.systemGray
        let date = Date()
        let calendar = Calendar.current

        let day = calendar.component(.day, from: date)
        let month = calendar.component(.month, from: date)
        let monthName = DateFormatter().monthSymbols[month - 1]
        let year = calendar.component(.year, from: date)
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm" // "a" prints "pm" or "am"
        let hourAndMin = formatter.string(from: Date()) // "12 AM"
        lastEditBBI.title = "Edited: \(day) \(monthName) \(year), \(hourAndMin)"
        lastEditBBI.tintColor = UIColor.white
        lastEditBBI.isEnabled = false
        
        
    }
    
    @IBAction func micBtnPressed(_ sender: Any) {
        recordAndRecogniseSpeech()
    }
    @IBAction func optionsBtnPressed(_ sender: Any) {
        let actionsheet = UIAlertController(title: "Additional Options", message: nil, preferredStyle: UIAlertController.Style.actionSheet)

        actionsheet.addAction(UIAlertAction(title: "Add Tags", style: UIAlertAction.Style.default, handler: presentTagsVC))

        actionsheet.addAction(UIAlertAction(title: "Add Photos", style: UIAlertAction.Style.default, handler: { (action) -> Void in
             }))
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in

             }))
             present(actionsheet, animated: true, completion: nil)
    }
    @IBAction func trashBtnPressed(_ sender: Any) {
        let deleteAlert = UIAlertController(title: "Delete", message: "All data will be lost.", preferredStyle: UIAlertController.Style.alert)
        deleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
            self.fStore?.collection("notes").document((self.currentNote?.noteID)!).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                    self.isDeleting = true
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        }))
        
        deleteAlert.addAction(UIAlertAction(title: "Wait go back!", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(deleteAlert, animated: true, completion: nil)
    }
    
    func presentTagsVC(action: UIAlertAction){
        self.performSegue(withIdentifier: "TagsSegue", sender: nil)
    }
    
    @IBOutlet weak var notesBody: UITextView!
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray && textView.text == "note"{
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Note"
            textView.textColor = UIColor.lightGray
        }
    }
    
    func recordAndRecogniseSpeech(){
        audioEngine.inputNode.removeTap(onBus: 0)
        let node = audioEngine.inputNode
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request.append(buffer)
        }
        audioEngine.prepare()
        do{
            try audioEngine.start()
        }catch{
            return print(error)
        }
        
        guard let myRecogniser = SFSpeechRecognizer() else{
            /// prob add alert here ask someone else 1st
            return
        }
        
        if !myRecogniser.isAvailable{
            // same here
            return
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request, resultHandler: { (result, error) in
            if let result = result{
                let speechString = result.bestTranscription.formattedString
                self.bodyTV.text = speechString
            } else if let error = error {
                print(error)
            }
        })
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if self.isMovingFromParent {
            if self.isDeleting!{
                // deleting note
            }
            else{
                
                
                if let CurrentNote = currentNote{
                    // do update here dom 15/7/2020
                    print("current note ID: " + CurrentNote.noteUserID!)
                    let noteRef = self.fStore?.collection("notes").document(CurrentNote.noteID!)
                    noteRef?.updateData(["title": self.titleTF.text! , "body":self.bodyTV.text!], completion: { (err) in
                        if let err = err {
                            print("Error updating document: \(err)")
                        } else {
                            print("Document successfully updated")
                        }
                    })
                }
                else{
                    // make new note since it's not an existing one mate
                    if( titleTF.text!.isEmpty){
                        print("Empty note")
                    }
                    else{
                        fStore?.collection("notes").addDocument(data: ["title":titleTF.text ?? "default title text", "body": bodyTV.text ?? "default body text", "uID":userID ?? "no uID found"])
                    }
                }
            }
            audioEngine.inputNode.removeTap(onBus: 0)
            audioEngine.stop()
        }
        super.viewWillDisappear(animated)
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

