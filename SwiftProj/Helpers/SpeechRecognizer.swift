//
//  SpeechRecognition.swift
//  Speech1
//
//  Created by homework on 2/7/17.
//  Copyright © 2017 homework. All rights reserved.
//

import UIKit
import Speech

class SpeechRecognizer: NSObject {
    
    // All the variables that we will need for
    // the recognition
    //
    private let audioEngine = AVAudioEngine()
    private var speechRecognizer = SFSpeechRecognizer()
    
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var silenceTimer: Timer?
    
    
    // Whenever this SpeechRecognizer call is deinitialized,
    // call the stop function to be sure we properly terminate
    // the recording and the recognition.
    //
    deinit {
        stopRecognitionSync()
    }

    
    // Starts the speech recognition.
    //
    func startRecognition(
        onReceivedTranscription: @escaping (String) -> Void,
        onStoppedRecognizing: @escaping (String) -> Void)
    {
        DispatchQueue.main.async {
        
            // Request for permission to perform speech recognition
            //
            SFSpeechRecognizer.requestAuthorization
                { authStatus in
                    if authStatus != .authorized
                    {
                        return
                    }
                }
            
            // If we have already started the speech recognition,
            // block this function from initializing a new
            // recognition task.
            //
            if self.recognitionTask != nil {
                return
            }
            
            // Create an audio session required for the recording.
            // Note that we are not starting any recording just yet.
            //
            let audioSession = AVAudioSession.sharedInstance()
            do {
                try audioSession.setCategory(AVAudioSession.Category.record)
                try audioSession.setMode(AVAudioSession.Mode.measurement)
                try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            }
            catch {
                print("audioSession properties weren't set because of an error.")
                return
            }
            
            // Create a new speech recognition buffer request.
            // This buffer receives audio samples in chunks from the
            // audio recording engine as they come in.
            //
            self.recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
            if self.recognitionRequest == nil
            {
                print("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
                return
            }
            
            // Setting this to true allows us to receive
            // results as the recognition continues, until iOS
            // decides the spoke sentence is complete.
            //
            self.recognitionRequest!.shouldReportPartialResults = true
            
            // Create the recognition task and pass in the block of code
            // that should execute whenever the spoken sentence is partially
            // recognized.
            //
            self.recognitionTask = self.speechRecognizer!.recognitionTask(with: self.recognitionRequest!, resultHandler: { (result, error) in
                
                // If there is any error, just print it out to the
                // console, stop the recording, and return an
                // empty string to the closure.
                //
                if error != nil
                {
                    print (error!.localizedDescription)
                    self.stopRecognition()
                    
                    DispatchQueue.main.async {
                        onStoppedRecognizing("")
                    }
                    return
                }
                
                // If we get a result from the speech recognizer,
                // send this result back to the onReceivedTranscription
                // closure.
                //
                if result != nil
                {
                    DispatchQueue.main.async {
                        onReceivedTranscription(result!.bestTranscription.formattedString)
                    }
                    
                    // If this is the final transcription, stop all
                    // recording and return the result to the closure.
                    // Otherwise, restart the silence detection
                    // timer to countdown from 3 seconds again.
                    //
                    if result!.isFinal
                    {
                        self.stopRecognition()
                        DispatchQueue.main.async {
                            onStoppedRecognizing(result!.bestTranscription.formattedString)
                        }
                        return
                    }
                    else
                    {
                        self.resetSilenceDetectionTimer()
                    }
                }

            })
            
            // Install a tap that observes the recorded audio
            // samples, and sends it to the speech recognizer
            // as these chunked samples come in.
            //
            // Obviously, as this audio samples get sent to the
            // recognizer, the speech recognition engine will
            // begin recognition on the partial audio samples.
            //
            var recordingAudioFormat = self.audioEngine.inputNode.outputFormat(forBus: 0)
            self.audioEngine.inputNode.installTap(
                onBus: 0,
                bufferSize: 1024,
                format: recordingAudioFormat)
                { (buffer, when) in
                    self.recognitionRequest?.append(buffer)
                }
            
            // Finally, begin the recording via the audio engine, and
            // start the countdown silence detection timer of 3 seconds.
            //
            do {
                self.audioEngine.prepare()
                try self.audioEngine.start()
            } catch {
                print("audioEngine couldn't start because of an error.")
            }
            self.resetSilenceDetectionTimer()
        }
    }
    
    // This function terminates the previous timer and
    // starts a new one to end the recognition after 3
    // seconds of silence.
    //
    private func resetSilenceDetectionTimer()
    {
        if silenceTimer != nil
        {
            silenceTimer!.invalidate()
            silenceTimer = nil
        }
        
        silenceTimer = Timer.scheduledTimer(
            withTimeInterval: 3.0,
            repeats: false,
            block:
            {
                timer in
                
                self.stopRecognition()
            })
        
    }
    
    
    func stopRecognitionSync()
    {
        if self.silenceTimer != nil
        {
            self.silenceTimer!.invalidate()
            self.silenceTimer = nil
        }
        
        if self.audioEngine.isRunning
        {
            self.audioEngine.stop()
            self.audioEngine.inputNode.removeTap(onBus: 0)
        }
        
        if self.recognitionRequest != nil
        {
            self.recognitionRequest?.endAudio()
            self.recognitionRequest = nil
        }
        
        self.recognitionTask = nil
        
        do
        {
            try AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        }
        catch
        {
            
        }
    }
    
    // Stops the recognition and frees up all
    // open resources.
    //
    func stopRecognition()
    {
        DispatchQueue.main.async {
            self.stopRecognitionSync()
        }
    }
    
    // This property indicates if the speech
    // recognition is running
    //
    var isRunning : Bool
    {
        get
        {
            return audioEngine.isRunning
        }
    }
    

}
