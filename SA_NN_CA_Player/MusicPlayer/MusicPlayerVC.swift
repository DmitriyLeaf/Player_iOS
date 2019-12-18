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
    @IBOutlet var currentTimeLabel: UILabel!
    @IBOutlet var durationTimeLabel: UILabel!
    
    @IBOutlet var playButton: UIButton!
    @IBOutlet var prevButton: UIButton!
    @IBOutlet var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MusicController.shared.getMusic()
        WeightManager.shared.get(soundCounts: MusicController.shared.getCountOfSounds())
        MusicController.shared.push()
        
        addObserver()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        updatePlayerUI()
    }

    @IBAction func preButtonTapped(_ sender: Any) {
        WeightManager.shared.prew(sId: MusicController.shared.soundPointer, value: progressSlider.value*100)
        MusicController.shared.prevSound()
        
        updatePlayerUI()
        
        buttonAnimation(button: prevButton)
    }
    
    @IBAction func playButtonTapped(_ sender: Any) {
        MusicController.shared.playPause()
        
        updatePlayButton()
        
        buttonAnimation(button: playButton)
    }
    
    @IBAction func nextButtonTapped(_ sender: Any) {
        WeightManager.shared.next(sId: MusicController.shared.soundPointer, value: progressSlider.value*100)
        MusicController.shared.nextSound()
        
        updatePlayerUI()
        
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

extension MusicPlayerVC {
    func updatePlayButton() {
        if MusicController.shared.audioPlayer.rate == 0 {
            self.playButton.setImage(UIImage(named: "playButtonC.png"), for: .normal)
        } else {
            self.playButton.setImage(UIImage(named: "pauseButton.png"), for: .normal)
        }
    }
    
    func updatePlayerUI() {
        self.musicImage.image = MusicController.shared.getSoundCover()
        self.musicName.text = MusicController.shared.sounds[MusicController.shared.soundPointer].name
    }
    
    func addObserver() {
        MusicController.shared.audioPlayer.addPeriodicTimeObserver(forInterval: CMTimeMakeWithSeconds(1, preferredTimescale: 1), queue: DispatchQueue.main) { (CMTime) -> Void in
            if MusicController.shared.audioPlayer.currentItem?.status == .readyToPlay {
                if let currentTime = MusicController.shared.audioPlayer.currentItem?.currentTime(),
                    let durationTime = MusicController.shared.audioPlayer.currentItem?.duration {
                    let current : Float64 = CMTimeGetSeconds(currentTime);
                    let duration : Float64 = CMTimeGetSeconds(durationTime);
                    self.progressSlider.value = Float ( current/duration );
                    
                    let secDurText = Int(duration) % 60
                    let minDurText = String(format: "%02d", Int(duration) / 60)
                    
                    let secCurText = Int(current) % 60
                    let minCurText = String(format: "%02d", Int(current) / 60)
                    
                    self.durationTimeLabel.text = "\(minDurText):\(secDurText)"
                    self.currentTimeLabel.text = "\(minCurText):\(secCurText)"
                    
                    if self.progressSlider.value >= 1 {
                        MusicController.shared.nextSound()
                        MusicController.shared.play()
                    }
                    
                    print(self.progressSlider.value)
                }
            }
        }
    }
}

