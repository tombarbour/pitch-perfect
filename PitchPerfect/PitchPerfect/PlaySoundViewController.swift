//
//  PlaySoundViewController.swift
//  PitchPerfect
//
//  Created by Tom Barbour on 07/03/2015.
//  Copyright (c) 2015 Tom Barbour. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundViewController: UIViewController {

    // Universal Variables
    var audioPlayer = AVAudioPlayer()
    var receivedAudio:RecordedAudio!
    
    var audioEngine:AVAudioEngine!
    var audioFile:AVAudioFile!
    
  
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Creates light blue background colour 
        view.backgroundColor = UIColor(red: 158/255, green: 210/255, blue: 255/255, alpha: 1.0)
        
        // Assign last recorded file to Player and File
        audioPlayer = AVAudioPlayer(contentsOfURL: receivedAudio.filePathURL, error: nil)
        audioPlayer.enableRate = true
        
        audioEngine = AVAudioEngine()
        audioFile = AVAudioFile(forReading: receivedAudio.filePathURL, error: nil)
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // UI Buttons
    @IBAction func playSound1Button(sender: AnyObject) {
        // Plays audio slowly
        resetAudioEngine()
        playAudio(0.5) // 0.5x speed playback
    }
    
    @IBAction func playSoundFastButton(sender: AnyObject) {
        //Plays audio quickly
        resetAudioEngine()
        playAudio(1.5) // 1.5x speed playback
    }
    
    @IBAction func playChipmunkAudio(sender: AnyObject) {
        playAudioWithVariablePitch(1000)
    }
    
    @IBAction func playDarthSound(sender: AnyObject) {
        // Play with delay
        playAudioWithEcho(1.0)
    }
    
    @IBAction func stopAudioButton(sender: AnyObject) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
    }
    
    
    // Func to play audio at different speeds
    func playAudio(rate: Float) {
        audioPlayer.stop()
        audioPlayer.rate = rate
        audioPlayer.currentTime = 0.0
        audioPlayer.play()
    }
    
    func resetAudioEngine() {
        audioEngine.stop()
        audioEngine.reset()
    }
    
    
    // Func to change audio pitch
    func playAudioWithVariablePitch(pitch: Float) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var changePitchEffect = AVAudioUnitTimePitch()
        changePitchEffect.pitch = pitch
        audioEngine.attachNode(changePitchEffect)
        
        audioEngine.connect(audioPlayerNode, to: changePitchEffect, format: nil)
        audioEngine.connect(changePitchEffect, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
    
    func playAudioWithEcho(delayTime: NSTimeInterval) {
        audioPlayer.stop()
        audioEngine.stop()
        audioEngine.reset()
        
        var audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attachNode(audioPlayerNode)
        
        var delay = AVAudioUnitDelay()
        delay.delayTime = delayTime
        audioEngine.attachNode(delay)
        
        audioEngine.connect(audioPlayerNode, to: delay, format: nil)
        audioEngine.connect(delay, to: audioEngine.outputNode, format: nil)
        
        audioPlayerNode.scheduleFile(audioFile, atTime: nil, completionHandler: nil)
        audioEngine.startAndReturnError(nil)
        
        audioPlayerNode.play()
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
