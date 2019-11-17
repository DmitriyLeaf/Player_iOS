//
//  MusicPlayerVC.swift
//  SA_NN_CA_Player
//
//  Created by Dmitriy Kruglov on 11/13/19.
//  Copyright © 2019 SPAlgorithm. All rights reserved.
//

import UIKit
import AVFoundation

class MusicPlayerVC: UIViewController {
    @IBOutlet var musicImage: UIImageView!
    @IBOutlet var progressSlider: UISlider!
    @IBOutlet var musicName: UILabel!
    @IBOutlet var currentTime: UILabel!
    @IBOutlet var durationTime: UILabel!
    
    @IBOutlet var playButton: UIButton!
    @IBOutlet var prevButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MusicController.shared.getMusicNames()
        MusicController.shared.pushSound()
        
        addTimeObserver()
        
        musicName.text = MusicController.shared.soundsNames[MusicController.shared.soundPointer]
        
        musicImage.image = MusicController.shared.getSoundCover()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        musicName.text = MusicController.shared.soundsNames[MusicController.shared.soundPointer]
    }
    
    func addTimeObserver() {
        MusicController.shared.audioPlayer.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if MusicController.shared.audioPlayer.currentItem?.status == .readyToPlay {
                if let currentTime = MusicController.shared.audioPlayer.currentItem?.currentTime(),
                    let durationTime = MusicController.shared.audioPlayer.currentItem?.duration {
                    let current : Float64 = CMTimeGetSeconds(currentTime);
                    let duration : Float64 = CMTimeGetSeconds(durationTime);
                    self.progressSlider.value = Float ( current/duration );
                    
                    self.updateTimeLabel(current: current, duration: duration)
                    
                    if self.progressSlider.value >= 1 {
                        MusicController.shared.nextSound()
                        MusicController.shared.play()
                        self.musicName.text = MusicController.shared.soundsNames[MusicController.shared.soundPointer]
                    }
                    
                    self.updatePlayButton()
                    
                    self.musicImage.image = MusicController.shared.getSoundCover()
                    
                    print(self.progressSlider.value)
                }
            }
        }
    }
    
    func updatePlayButton() {
        if MusicController.shared.audioPlayer.rate == 0 {
            self.playButton.setImage(UIImage(named: "playButtonC.png"), for: .normal)
        } else {
            self.playButton.setImage(UIImage(named: "pauseButton.png"), for: .normal)
        }
    }
    
    func updateTimeLabel(current: Float64, duration: Float64) {
        let secDurText = Int(duration) % 60
        let minDurText = String(format: "%02d", Int(duration) / 60)
        
        let secCurText = Int(current) % 60
        let minCurText = String(format: "%02d", Int(current) / 60)
        
        durationTime.text = "\(minDurText):\(secDurText)"
        currentTime.text = "\(minCurText):\(secCurText)"
    }

    @IBAction func preButtonTapped(_ sender: Any) {
        MusicController.shared.prevSound()
        MusicController.shared.play()
        musicName.text = MusicController.shared.soundsNames[MusicController.shared.soundPointer]
        
        buttonAnimation(button: prevButton)
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        MusicController.shared.playPause()
        
        buttonAnimation(button: playButton)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        MusicController.shared.nextSound()
        MusicController.shared.play()
        musicName.text = MusicController.shared.soundsNames[MusicController.shared.soundPointer]
        
        buttonAnimation(button: nextButton)
    }
    
    @IBAction func progressSliderVC(_ sender: Any) {
        MusicController.shared.timelineMovedTo(value: progressSlider.value)
    }
    
    func buttonAnimation(button: UIButton) {
        UIView.animate(withDuration: 0.1,
                       animations: {
                        button.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)},
                       completion: { _ in
                        UIView.animate(withDuration: 0.1) {
                            button.transform = CGAffineTransform.identity}})
    }
}

