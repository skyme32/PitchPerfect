//
//  RecordAudioViewController.swift
//  PitchPerfect
//
//  Created by skyme32 on 26/9/21.
//

import UIKit
import AVFoundation

class RecordAudioViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordingAudio: UIButton!
    @IBOutlet weak var stopingAudio: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: Record Audio
    @IBAction func recordAudio(_ sender: Any) {
        recordingStatus(label: "Recording in Progress", recordAudio: false)
        
        // Start save de audio to the path directory
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        // Start the session with Audio
        let sessionAudio = AVAudioSession.sharedInstance()
        try! sessionAudio.setCategory(AVAudioSession.Category.playAndRecord,
                                      mode: AVAudioSession.Mode.default,
                                      options: AVAudioSession.CategoryOptions.defaultToSpeaker)
        
        // Start recorded
        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // MARK: Stop Audio Recorder
    @IBAction func stopAudio(_ sender: Any) {
        recordingStatus(label: "Tap to Record", recordAudio: true)
        
        // Stop the recordAudio
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    // MARK: Audio Recorder Delegate
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            print(audioRecorder.url)
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording was not succesful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL = recordedAudioURL
        }
    }
    
    // MARK: Method delegate button&textview
    func recordingStatus(label: String, recordAudio: Bool) {
        recordingLabel.text = label
        recordingAudio.isEnabled = recordAudio
        stopingAudio.isEnabled = !recordAudio
    }
    
}
