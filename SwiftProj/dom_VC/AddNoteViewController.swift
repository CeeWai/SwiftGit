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
import AVFoundation
import UserNotifications

class AddNoteViewController: UIViewController, UITextViewDelegate {
    @IBOutlet weak var bodyTV: UITextView!
    @IBOutlet weak var lastEditBBI: UIBarButtonItem!
    @IBOutlet weak var titleTF: UITextField!
    //var ref : DatabaseReference?
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var optionsBtn: UIBarButtonItem!
    @IBOutlet weak var trashBarButton: UIBarButtonItem!
    //speech stuff below m8s
    let audioEngine = AVAudioEngine()
    let speechRecognizer: SFSpeechRecognizer? = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US")) // did this because im using vm and not sure where my locale is -dom 16/07/2020
    var recognitionTask: SFSpeechRecognitionTask?
    var fStore : Firestore?
    var userID : String?
    var userEmail : String?
    //    var currentNoteTag : dom_tag?
    //    var loadedNote : dom_note?
    //    var tagList : [dom_tag] = []
    var currentNote : dom_note?
    var updatedNote : dom_note?
    var addNoteBool : Bool?
    var isDeleting : Bool?
    let fsdbManager = dom_FireStoreDataManager()
    let synth = AVSpeechSynthesizer()
    var currentImgURL:String = ""
    
    func initNotificationSetupCheck() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert])
        { (success, error) in
            if success {
                //                print("Permission Granted")
            } else {
                //                print("There was a problem!")
            }
        }
    }
    
    
    @IBAction func reminderBtn(_ sender: Any) {
        let reminderAlert = UIAlertController(title: "Set up reminder", message: "Please type in how long this reminder should wait before triggering (in minutes)", preferredStyle: UIAlertController.Style.alert)
        reminderAlert.addTextField { (textField) in
            textField.placeholder = "Enter time here"
            textField.keyboardType = .numberPad
        }
        reminderAlert.addAction(UIAlertAction(title: "back", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        reminderAlert.addAction(UIAlertAction(title: "Add reminder", style: .default, handler: { (action: UIAlertAction!) in
            let notification = UNMutableNotificationContent()
            notification.title = "Reminder: " + (self.titleTF.text!)
            notification.subtitle = "from Taskr"
            notification.body = self.bodyTV.text!
            let textField = reminderAlert.textFields![0]
            if let dom_timer = Double(textField.text!){
                //print(textField.text)
                let notificationTrigger = UNTimeIntervalNotificationTrigger(timeInterval:dom_timer*60, repeats: false)
                let request = UNNotificationRequest(identifier: "dom_notification1", content: notification, trigger: notificationTrigger)
                
                UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
            }
            else{
                let reminderAlertError = UIAlertController(title: "Error setting up reminder", message: "Please try again", preferredStyle: UIAlertController.Style.alert)
                reminderAlertError.addAction(UIAlertAction(title: "ok", style: .default, handler: { (action: UIAlertAction!) in
                    
                }))
                self.present(reminderAlertError, animated: true, completion: nil)
            }
            
        }))
        present(reminderAlert, animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        initNotificationSetupCheck()
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
        if currentNote != nil {
            if currentNote?.noteTags?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || currentNote?.noteTags?.trimmingCharacters(in: .whitespacesAndNewlines) == nil{
                self.tagsLabel.text = "No Tag"
            }
            else{
                self.tagsLabel.text = "Tag: " + (currentNote?.noteTags)!
            }
            self.titleTF.text = currentNote?.noteTitle
            self.bodyTV.text = currentNote?.noteBody
            self.lastEditBBI.title = currentNote?.noteUpdateDate
        }
        else{
            self.bodyTV.text = "body"
            self.tagsLabel.text = "No Tag"
        }
        self.navigationController?.tabBarController?.tabBar.isHidden = true
        self.navigationController?.toolbar.isHidden = false
        self.isDeleting = false
        let label = UILabel()
        label.textColor = UIColor.systemGray
        //        let date = Date()
        //        let calendar = Calendar.current
        //        let day = calendar.component(.day, from: date)
        //        let month = calendar.component(.month, from: date)
        //        let monthName = DateFormatter().monthSymbols[month - 1]
        //        let year = calendar.component(.year, from: date)
        //        let formatter = DateFormatter()
        //        formatter.dateFormat = "hh:mm" // "a" prints "pm" or "am"
        //        let hourAndMin = formatter.string(from: Date()) // "12 AM"
        //        formatter.dateFormat =  "MM/dd/yyyy"
        //        let dateslash = formatter.string(from: Date())
        lastEditBBI.tintColor = UIColor.white
        lastEditBBI.isEnabled = false
        UserDefaults.standard.set("", forKey: "addNoteTag")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if !(addNoteBool != nil && addNoteBool == true){ // if updating note and not adding new note
            fsdbManager.loadOneNoteTag(nID: currentNote?.noteID){ updatedtag in
                if updatedtag.trimmingCharacters(in: .whitespacesAndNewlines) == ""{
                    self.tagsLabel.text = "No Tag"
                }
                else{
                    self.tagsLabel.text! = "Tag: " + (updatedtag)
                }
                
            }
        }
        else{
            let addNoteTag = UserDefaults.standard.string(forKey: "addNoteTag")
            if !(addNoteTag!.isEmpty){
                self.tagsLabel.text! = "Tag: " + addNoteTag!
            }
        }
        
        
    }
    
    @IBAction func micBtnPressed(_ sender: Any) {
        recordAndRecogniseSpeech()
    }
    @IBAction func optionsBtnPressed(_ sender: Any) {
        let actionsheet = UIAlertController(title: "Additional Options", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        
        actionsheet.addAction(UIAlertAction(title: "Add/Change Tag", style: UIAlertAction.Style.default, handler: presentTagsVC))
        actionsheet.addAction(UIAlertAction(title: "Read Note out loud", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            let TTSstring = "Title text; " + self.titleTF.text! + " ;Body text;" + self.bodyTV.text
            let utterance = AVSpeechUtterance(string: TTSstring)
            utterance.voice = AVSpeechSynthesisVoice(language: "US-EN")
            self.synth.speak(utterance)
        }))
        actionsheet.addAction(UIAlertAction(title: "Add a google Image", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            //        014331032632211638537:vfplaxzyp30 my google CSE important dont del -dom
            let imageSearchAlert = UIAlertController(title: "Delete", message: "All data will be lost.", preferredStyle: UIAlertController.Style.alert)
            imageSearchAlert.addTextField { (textField) in
                textField.placeholder = "Image name"
            }
            imageSearchAlert.addAction(UIAlertAction(title: "Google Search Image", style: .default, handler: { (action: UIAlertAction!) in
                let textField = imageSearchAlert.textFields![0]
                var imgURLString = ""

                imgURLString = "https://www.googleapis.com/customsearch/v1?key=AIzaSyCKrTNk2p3ieGHQGQzPVzcihNKNBfff0p8&cx=014331032632211638537:vfplaxzyp30&q=" + (textField.text?.replacingOccurrences(of: " ", with: ""))!
                
                
                let url = URL(string: imgURLString)
                print(url)
                
                let task = URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                    if let error = error {
                        print("Error accessing " + String(url!.absoluteString))
                        return
                    }
                    guard let httpResponse = response as? HTTPURLResponse,
                        (200...299).contains(httpResponse.statusCode) else {
                            print("Error with the response, unexpected status code: \(response)")
                            return
                    }
                    
                    if let data = data{
                        let jsonData = JSON.init(data: data)
                        let imgSrcURL = jsonData["items"][0]["pagemap"]["cse_image"][0]["src"]
                        self.currentImgURL = imgSrcURL.stringValue
                        print(imgSrcURL)
                    }
                })
                task.resume()
            }))
            
             
            imageSearchAlert.addAction(UIAlertAction(title: "back", style: .cancel, handler: { (action: UIAlertAction!) in
                
            }))
            self.present(imageSearchAlert, animated: true, completion: nil)
        }))
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
            
        }))
        present(actionsheet, animated: true, completion: nil)
    }
    @IBAction func trashBtnPressed(_ sender: Any) { // check if it is deleting an existing object if yes go ddelete else just pop the view
        let deleteAlert = UIAlertController(title: "Delete", message: "All data will be lost.", preferredStyle: UIAlertController.Style.alert)
        if currentNote != nil{
            deleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
                self.fsdbManager.deleteNote(noteID: self.currentNote?.noteID)
                self.isDeleting = true
                self.navigationController?.popViewController(animated: true)
            }))
        }
        else{
            deleteAlert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { (action: UIAlertAction!) in
                self.navigationController?.popViewController(animated: true)
            }))
        }
        
        
        deleteAlert.addAction(UIAlertAction(title: "Wait go back!", style: .cancel, handler: { (action: UIAlertAction!) in
            
        }))
        
        present(deleteAlert, animated: true, completion: nil)
    }
    
    func presentTagsVC(action: UIAlertAction){
        if self.synth.isSpeaking{
            self.synth.stopSpeaking(at: AVSpeechBoundary.immediate)
        }
        self.performSegue(withIdentifier: "TagsSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "TagsSegue")
        {
            let TagViewController = segue.destination as! TagsTableViewController
            if !(addNoteBool != nil && addNoteBool == true){
                TagViewController.isAddNote = false
                TagViewController.prevNote = currentNote
            }
            else{
                TagViewController.isAddNote = true
            }
            
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
        let request = SFSpeechAudioBufferRecognitionRequest()
        if (audioEngine.isRunning){
            audioEngine.stop()
            audioEngine.inputNode.removeTap(onBus: 0)
            print("Stopped recording...")
        }
        else{
            print("Started recording...")
            let node = audioEngine.inputNode
            let recordingFormat = node.outputFormat(forBus: 0)
            node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
                request.append(buffer)
            }
            audioEngine.prepare()
            do{
                try audioEngine.start()
            }catch{
                return print(error)
            }
            
            guard let myRecogniser = SFSpeechRecognizer() else{
                /// prob add alert here
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
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
        if self.isMovingFromParent {
            let formatter = DateFormatter()
            formatter.dateFormat = "hh:mm" // "a" prints "pm" or "am"
            let hourAndMin = formatter.string(from: Date()) // "12 AM"
            formatter.dateFormat =  "dd/MM/yyyy"
            let dateslash = formatter.string(from: Date())
            let dateText = "Edited: \(dateslash), \(hourAndMin)"
            if self.synth.isSpeaking{
                self.synth.stopSpeaking(at: AVSpeechBoundary.immediate)
            }
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
                    // do update here dom 15/7/2020
                    // print("current note ID: " + CurrentNote.noteUserID!)
                    if (currentNote?.noteTitle == titleTF.text && currentNote?.noteBody == bodyTV.text && CurrentNote.noteTags == tagStr2 && currentImgURL == ""){
                        // no editing done, no need to update :)
                    }
                    else{
                        fsdbManager.updateNote(noteID: currentNote?.noteID, titleStr: titleTF.text, bodyStr: bodyTV.text, tagStr: tagStr2, noteUpdateDate: dateText, noteImageURL: currentImgURL)
                    }
                    // }
                }
                else{
                    // make new note since it's not an existing one
                    if( titleTF.text!.isEmpty){
                        print("Empty note")
                    }
                    else{
                        
                        fsdbManager.addNote(titleStr: titleTF.text, bodyStr: bodyTV.text, tagStr:  tagStr2, uid: userID, noteUpdateDate: dateText, noteImageURL: currentImgURL)
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

