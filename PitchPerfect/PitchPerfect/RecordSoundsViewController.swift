//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Tom Barbour on 05/03/2015.
//  Copyright (c) 2015 Tom Barbour. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    // Universal variables
    var audioRecorder:AVAudioRecorder!
    var recordedAudio:RecordedAudio!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // Create light blue background colour 
        view.backgroundColor = UIColor(red: 158/255, green: 210/255, blue: 255/255, alpha: 1.0)
        recordingLabel.text = "Tap to record"
    }
    
    override func viewWillAppear(animated: Bool) {
        recordButton.enabled = true
        recordingLabel.hidden = false
        stopButton.hidden = true
        pauseButton.hidden = true
        resumeRecording.hidden = true
        recordingLabel.text = "Tap to record"
        // Create black text for recording label, 0.8 opacity
        recordingLabel.textColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.8)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // Record Audio function
    func recordAudio() {
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as String
        
        let currentDateTime = NSDate()
        let formatter = NSDateFormatter()
        formatter.dateFormat = "ddMMyyyy-HHmmss"
        let recordingName = formatter.stringFromDate(currentDateTime)+".wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        println(filePath)
        
        var session = AVAudioSession.sharedInstance()
        session.setCategory(AVAudioSessionCategoryPlayAndRecord, error: nil)
        
        audioRecorder = AVAudioRecorder(URL: filePath
            , settings: nil, error: nil)
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
        
    }
    
    // Save recorded audio function, pass data to other Play Sound Controller
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder!, successfully flag: Bool) {
       
        if(flag) {
            recordedAudio = RecordedAudio(filePathURL: recorder.url, title: recorder.url.lastPathComponent!)
            
            // Perform a segue to scene2
            self.performSegueWithIdentifier("stopRecording", sender: recordedAudio)
        } else {
            println("Recording was not succesful")
        }
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if (segue.identifier == "stopRecording") {
            let playSoundsVC: PlaySoundViewController = segue.destinationViewController as PlaySoundViewController
            let data = sender as RecordedAudio
            playSoundsVC.receivedAudio = data
            
        }
    }
    
    
    
    // UI Actions and Outlets
    @IBAction func recordAudioButton(sender: UIButton) {
        // Starts a new recording session
        println("Recording Audio")
        recordAudio()
        recordingLabel.text = "Recording"
        recordButton.enabled = false
        stopButton.hidden = false
        pauseButton.hidden = false
    }
    
    @IBAction func stopRecordingButton(sender: UIButton) {
        audioRecorder.stop()
        var audioSession = AVAudioSession.sharedInstance()
        audioSession.setActive(false, error: nil)
        recordingLabel.hidden = true
        stopButton.hidden = true
        pauseButton.hidden = true
        pauseButton.enabled = true
    }
    
    
    @IBAction func pauseRecordingButton(sender: AnyObject) {
        audioRecorder.pause()
        recordingLabel.text = "Tap play to resume"
        pauseButton.enabled = false
        pauseButton.hidden = true
        resumeRecording.hidden = false
        resumeRecording.enabled = true

    }
    
    @IBAction func resumeRecordingButton(sender: AnyObject) {
        // Resumes current recording session
        println("Resuming paused recording")
        audioRecorder.record()
        resumeRecording.hidden = true
        resumeRecording.enabled = false
        pauseButton.hidden = false
        pauseButton.enabled = true
    }
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var resumeRecording: UIButton!
    
}

