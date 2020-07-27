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
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var optionsBtn: UIBarButtonItem!
    //speech stuff below m8s
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US")) // did this because im using vm and not sure where my locale is -dom 16/07/2020
    let request = SFSpeechAudioBufferRecognitionRequest()
    var recognitionTask: SFSpeechRecognitionTask?
    
    var fStore : Firestore?
    var userID : String?
    var userEmail : String?
//    var currentNoteTag : dom_tag?
//    var loadedNote : dom_note?
//    var tagList : [dom_tag] = []
    var currentNote : dom_note?
    var updatedNote : dom_note?
    var fromTV : String?
    var isDeleting : Bool?
    let fsdbManager = dom_FireStoreDataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        notesBody.delegate = self
        // Do any additional setup after loading the view.
        notesBody.textColor = UIColor.lightGray
        // ref = Database.database().reference()
        self.tagsLabel.text = ""
        fStore = Firestore.firestore()
        let user = Auth.auth().currentUser
        if let user = user {
            userID = user.uid
            userEmail = user.email
        }
        if let CurrentNote = currentNote {
            self.tagsLabel.text = "Tag: " + (currentNote?.noteTags)!
            self.titleTF.text = currentNote?.noteTitle
            self.bodyTV.text = currentNote?.noteBody
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        fsdbManager.loadOneNoteTag(nID: currentNote?.noteID){ updatedtag in
            
            self.tagsLabel.text! = "Tag: " + (updatedtag)
        }
        
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "TagsSegue")
         {
            let TagViewController = segue.destination as! TagsTableViewController
            TagViewController.prevNote = currentNote
         }
    }
    
    @IBOutlet weak var notesBody: UITextView!
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray && textView.text == "body"{
            textView.text = nil
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "body"
            textView.textColor = UIColor.lightGray
        }
    }
    // the speech func copied from apple docs
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
            let tagStr = tagsLabel.text?.replacingOccurrences(of: "Tag:", with: "")
            let tagStr2 = tagStr?.trimmingCharacters(in: .whitespacesAndNewlines)
            if self.isDeleting!{
                // deleting note so skip all the stuff below, maybe add alert? idk
            }
            else{
                if let CurrentNote = currentNote{
//                    if (currentNote?.noteTitle == loadedNote?.noteTitle && currentNote?.noteBody == loadedNote?.noteBody && currentNote?.noteTags == loadedNote?.noteTags){
                       //checked for changes, no changes to note, so don't update
//                    }
                    //else{
                        // do update here, change to datamanager ltr dom 15/7/2020
                       // print("current note ID: " + CurrentNote.noteUserID!)
                    fsdbManager.updateNote(noteID: currentNote?.noteID, titleStr: titleTF.text, bodyStr: bodyTV.text, tagStr: tagStr2)
                   // }
                }
                else{
                    // make new note since it's not an existing one
                    if( titleTF.text!.isEmpty){
                        print("Empty note")
                    }
                    else{
                        fsdbManager.addNote(titleStr: titleTF.text, bodyStr: bodyTV.text, tagStr:  tagStr2, uid: userID)
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

