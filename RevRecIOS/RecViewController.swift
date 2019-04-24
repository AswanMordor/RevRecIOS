//
//  RecViewController.swift
//  RevRecIOS
//
//  Created by Azzy M on 4/23/19.
//  Copyright © 2019 Azzy M. All rights reserved.
//

import UIKit
import AVFoundation

class RecViewController: UIViewController, AVAudioRecorderDelegate {

    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!

    
    var recordingSession: AVAudioSession!
    var recorder: AVAudioRecorder!
    var player: AVAudioPlayer!
    var recCircleTimer: Timer!
    var testerButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        playButton.isUserInteractionEnabled = false

        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission() { [unowned self] allowed in
                DispatchQueue.main.async {
                    if allowed {
                        self.showRecordingView()
                    } else {
                        self.showErrorView()
                    }
                }
            }
        } catch {
            self.showErrorView()
        }
         createRecCircle()
    }
    
    func showRecordingView() {
        //TODO
    }
    
    func showErrorView() {
        //TODO
    }
    
    func createSaveFileName()->String{
        return "temp.m4a" //TODO change
    }
    
    
    class func getSaveDirectory(fileName: String)->URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.appendingPathComponent(fileName)
    }
    
    func didStartRecording(){
        recordButton.setTitle("Pause", for: .normal)
        let recURL = RecViewController.getSaveDirectory(fileName: "temp.m4a")
        print(recURL.absoluteString);
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        do {
            // 5
            recorder = try AVAudioRecorder(url: recURL, settings: settings)
            recorder.delegate = self as AVAudioRecorderDelegate
            recorder.isMeteringEnabled = true
            recorder.record()
            recCircleTimer = Timer.scheduledTimer(timeInterval: 0.065, target: self, selector: #selector(updatePower), userInfo: nil, repeats: true)
        } catch {
            didFinishRecording(success: false)
        }

    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
    }
    
    func createRecCircle(){
        
        testerButton = UIButton(type: .custom)
        testerButton.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        //testerButton.clipsToBounds = true
        testerButton.layer.backgroundColor = UIColor.red.cgColor
        testerButton.center = self.view.center
        testerButton.isUserInteractionEnabled = false
        testerButton.layer.cornerRadius = 40/2
        testerButton.translatesAutoresizingMaskIntoConstraints = true
        testerButton.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(testerButton)
        
        
    }
    
    func getPower()->Float{
        recorder.updateMeters()
        return recorder.averagePower(forChannel: 0) * -1.0 / 120.0
    }
    
    @objc func updatePower(){
        let newDimms = Int((1 / getPower()) * 40)
        print(newDimms)
       // self.view.layoutIfNeeded()
        UIView.animate(withDuration: 0.05, animations: {() -> Void in
            print("animating")
            self.testerButton.frame = CGRect(x: 0, y: 0, width: newDimms, height: newDimms)
            self.testerButton.center = self.view.center
            self.testerButton.layer.cornerRadius = CGFloat(Int(newDimms)/2)
            self.view.layoutIfNeeded()
        })
    }
    
    func didFinishRecording(success: Bool){
            recorder.stop()
            self.recCircleTimer.invalidate()
            recorder = nil
        if(success){
            recordButton.setTitle("Re-Record?", for: .normal)
        }
        else{
            recordButton.setTitle("Record", for: .normal)
            let alert = UIAlertController(title: "Record failed", message: "There was a problem recording; please try again.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if !flag {
            didFinishRecording(success: false)
        }
    }
    
    func resetRecording(){
        if recorder != nil {
            recorder.stop()
        }
        recCircleTimer.invalidate()
        recorder = nil
        let recordURL = RecViewController.getSaveDirectory(fileName: "temp.m4a")
        do {
            try FileManager.default.removeItem(at: recordURL)
        }
        catch{
            //file not located error
        }
    }
    
    //Button Presses
    @IBAction func deleteButtonPressed(_ sender: Any) {
        //add in a popup asking "if you're sure..."
        resetRecording()
    }
    @IBAction func playButtonPressed(_ sender: Any) {
        let recURL = RecViewController.getSaveDirectory(fileName: "temp.m4a")
        do {
           player = try AVAudioPlayer(contentsOf: recURL) //stitch audio files together when paused and start recording again, rn plays only after saved, disable play button
           player?.play()
        }
        catch {
            print("UH OH")
        }
    }
    @IBAction func recordButtonPressed(_ sender: Any) {
        if recorder == nil { //record
            didStartRecording()
        }
        else if recorder.isRecording == true{
            recorder.pause()
            recordButton.setTitle("Play", for: .normal)
        }
        else{
            recorder.record()
            recordButton.setTitle("Pause", for: .normal)
        }
    }
    @IBAction func saveButtonPressed(_ sender: Any) {
        if recorder != nil {
            didFinishRecording(success: true)
        }
        let saveAlert = UIAlertController(title: "Name Your Recording", message: nil, preferredStyle: .alert)
        saveAlert.addTextField()
        
        let discardAction = UIAlertAction(title: "Discard", style: .default){ [unowned saveAlert] _ in
            saveAlert.dismiss(animated: true, completion: nil)
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { [unowned saveAlert] _ in
            let fileNameField = saveAlert.textFields![0]
            let fileName = (fileNameField.text ?? "Recording") + ".m4a"
            let finalAudioURL = RecViewController.getSaveDirectory(fileName: fileName)
            let tempAudioURL = RecViewController.getSaveDirectory(fileName: "temp.m4a")
            do{
                try FileManager.default.moveItem(at: tempAudioURL, to: finalAudioURL)
                self.resetRecording()
            }
            catch{
                //move didn't work
            }

            self.performSegue(withIdentifier: "toRecList", sender: nil)
        }
        
        saveAlert.addAction(discardAction)
        saveAlert.addAction(saveAction)
        
        present(saveAlert, animated: true)
    }
    
    
    

    
    // MARK: - Navigation
    /*
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
