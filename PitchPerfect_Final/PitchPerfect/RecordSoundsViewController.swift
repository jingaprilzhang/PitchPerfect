//  RecordSoundsViewController
//  Udacity iOS Developer Nanodegree
//  PitchPerfect
//
//  Created by JING ZHANG on 7/25/16.
//  Copyright © 2016 JING ZHANG. All rights reserved.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var stopRecordingButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    enum RecordingState {
        case Recording, NotRecording
    }
    
    func recordUI(recordState:RecordingState) {
        switch(recordState) {
        case .Recording:
            recordingLabel.text = "Recording in progress"
            stopRecordingButton.enabled = true
            recordButton.enabled = false
        case .NotRecording:
            recordingLabel.text = "Tap to Record"
            recordButton.enabled = true
            stopRecordingButton.enabled = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecordingButton.enabled = false
    }

    //record audio
    @IBAction func recordAudio(sender: AnyObject) {
        recordUI(.Recording)
        
        //set audio path
        let dirPath = NSSearchPathForDirectoriesInDomains(.DocumentDirectory,.UserDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = NSURL.fileURLWithPathComponents(pathArray)
        print(pathArray)
        
        //set audio session
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSessionCategoryPlayAndRecord)
        
        //set audio recorder
        try! audioRecorder = AVAudioRecorder(URL: filePath!, settings:[:])
        audioRecorder.delegate = self
        audioRecorder.meteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }

    //stop record
    @IBAction func stopRecording(sender: AnyObject) {
        recordUI(.NotRecording)
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    
    func audioRecorderDidFinishRecording(recorder: AVAudioRecorder, successfully flag: Bool) {
        if(flag) {
            performSegueWithIdentifier("stopRecording", sender: audioRecorder.url)
        } else {
            print("Saving of recording failed")
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if (segue.identifier == "stopRecording"){
            let playSoundsVC = segue.destinationViewController as! PlaySoundsViewController
            let recordedAudioURL = sender as! NSURL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
        
    }
    
}

