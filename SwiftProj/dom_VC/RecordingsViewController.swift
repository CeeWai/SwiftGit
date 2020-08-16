//
//  RecordingsViewController.swift
//  SwiftProj
//
//  Created by Dom on 2/8/20.
//  Copyright © 2020 Ong Chong Yong. All rights reserved.
//

let cellid = "cell"

import UIKit
import AVFoundation
import FirebaseAuth
import Speech

struct Recording {
    var name: String
    var path: URL
}

protocol RecordingsViewControllerDelegate: class {
    func didStartPlayback()
    func didFinishPlayback()
}

class RecordingsViewController: UIViewController, AVAudioPlayerDelegate, UITableViewDelegate, UITableViewDataSource {
  
    private var recordings: [Recording] = []
    private var audioPlayer: AVAudioPlayer?
    weak var delegate: RecordingsViewControllerDelegate?
    let user = Auth.auth().currentUser
    let fsdbManager = dom_FireStoreDataManager()
    
    @IBOutlet weak var fadeView: UIView!
    @IBOutlet weak var tableView: UITableView!
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let recording = self.recordings[indexPath.row]
        let actionsheet = UIAlertController(title: "Voice memo Options", message: nil, preferredStyle: UIAlertController.Style.actionSheet)
        if self.isPlaying() {
            actionsheet.addAction(UIAlertAction(title: "Stop current playback", style: UIAlertAction.Style.default, handler: { (action) -> Void in
                self.stopPlay()
            }))
        }
        else{
            actionsheet.addAction(UIAlertAction(title: "Play memo", style: UIAlertAction.Style.default, handler: { (action) -> Void in
                self.play(url: recording.path)
            }))
        }
        
        actionsheet.addAction(UIAlertAction(title: "Transcribe to Note", style: UIAlertAction.Style.default, handler: { (action) -> Void in
            let audioURL = recording.path

            let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-US"))
            let request = SFSpeechURLRecognitionRequest(url: audioURL)

            request.shouldReportPartialResults = false

            if (recognizer?.isAvailable)! {

                recognizer?.recognitionTask(with: request) { result, error in
                    guard error == nil else { print("Error: \(error!)"); return }
                    guard let result = result else { print("No result!"); return }

                    print(result.bestTranscription.formattedString)
                    let formatter = DateFormatter()
                    formatter.dateFormat = "hh:mm" // "a" prints "pm" or "am"
                    let hourAndMin = formatter.string(from: Date()) // "12 AM"
                    formatter.dateFormat =  "dd/MM/yyyy"
                    let dateslash = formatter.string(from: Date())
                    let dateText = "Edited: \(dateslash), \(hourAndMin)"
                    self.fsdbManager.addNote(titleStr: recording.name, bodyStr: result.bestTranscription.formattedString , tagStr: "", uid: self.user?.uid, noteUpdateDate: dateText)
                    let alert = UIAlertController(title: "Memo Transcribed", message: "The selected voice memo has been transcribed to a written Note with the same title as the memo", preferredStyle: .alert)
                    self.present(alert, animated: true)
                }
            } else {
                print("error doing speech recognition")
            }
        }))
        
        actionsheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertAction.Style.cancel, handler: { (action) -> Void in
            
        }))
        present(actionsheet, animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let result = self.recordings.count
        //print("recording count2: " + String(result))
        if result > 0 {
            self.tableView.isHidden = false
        }
        else {
            self.tableView.isHidden = true
        }
        return result
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: cellid)
        if cell == nil {
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: cellid)
        }
        let recording = self.recordings[indexPath.row]
        cell?.textLabel?.text = recording.name
        //cell?.detailTextLabel?.text = recording.path.absoluteString
        return cell!
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let filemanager = FileManager.default
            let recording = self.recordings[indexPath.row]
            do {
                try filemanager.removeItem(at: recording.path)
                self.recordings.remove(at: indexPath.row)
                var userVoiceMemo = UserDefaults.standard.stringArray(forKey: ("voicememo" + user!.uid))
                userVoiceMemo = userVoiceMemo?.filter{ $0 !=  recording.name}
                UserDefaults.standard.set(userVoiceMemo, forKey: ("voicememo" + user!.uid))
                fsdbManager.deleteAudioLog(memoName: recording.name)
                self.tableView.reloadData()
            }catch(let err){
                print("Error while deleteing \(err)")
            }
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate=self;
        self.tableView.dataSource=self; 
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.loadRecordings()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.isPlaying() {
            self.stopPlay()
        }
        super.viewWillDisappear(animated)
    }
    

    fileprivate func setupTableView() {
        self.tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 180, right: 0)
    }

    //  Data
    func loadRecordings() {
        self.recordings.removeAll()
        let filemanager = FileManager.default
        //var memodata : URL?
        //let documentsDirectory = filemanager.urls(for: .documentDirectory, in: .userDomainMask)[0]
        do {
            //let paths = try filemanager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil, options: [])
            var userVoiceMemo = UserDefaults.standard.stringArray(forKey: ("voicememo" + user!.uid))
            //print(userVoiceMemo)
            userVoiceMemo?.forEach(){ memo in
                fsdbManager.retrieveAudioLog(memoName: memo){memoURL in
                }
                let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
                let localURL = documentsDirectory.appendingPathComponent(memo)
                let recording = Recording(name: memo, path: localURL)
                self.recordings.append(recording)
                self.tableView.reloadData()
            }
           // print("recording count: " + String(recordings.count))
            //self.tableView.reloadData()
        } catch {
            print(error)
        }
    }
    
    // Playback funcs
    private func play(url: URL) {
        if let d = self.delegate {
            d.didStartPlayback()
        }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default)
            try session.setActive(true)
        } catch let error as NSError {
            print(error.localizedDescription)
            return
        }
        do {
            let data = try Data(contentsOf: url)
            self.audioPlayer = try AVAudioPlayer(data: data, fileTypeHint: AVFileType.caf.rawValue)
        } catch let error as NSError {
            print(error.localizedDescription)
            return
        }
        if let player = self.audioPlayer {
            player.delegate = self
            player.prepareToPlay()
            player.volume = 1.0
            player.play()
        }
    }
    
    func stopPlay() {
        if let d = self.delegate {
            d.didFinishPlayback()
        }
        if let paths = self.tableView.indexPathsForSelectedRows {
            for path in paths {
                self.tableView.deselectRow(at: path, animated: true)
            }
        }
        if let player = self.audioPlayer {
            player.pause()
        }
        self.audioPlayer = nil
        do {
            try AVAudioSession.sharedInstance().setActive(false)
        } catch  let error as NSError {
            print(error.localizedDescription)
            return
        }
    }
    
    private func isPlaying() -> Bool {
        if let player = self.audioPlayer {
            return player.isPlaying
        }
        return false
    }
    
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        if let e = error {
            print(e.localizedDescription)
        }
        self.stopPlay()
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.stopPlay()
    }
}



