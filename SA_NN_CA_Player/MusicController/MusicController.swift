//
//  MusicController.swift
//  SA_NN_CA_Player
//
//  Created by Dmitriy Kruglov on 11/15/19.
//  Copyright © 2019 SPAlgorithm. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

struct MusicController {
    static var shared = MusicController()
    
    var audioPlayer = AVPlayer()
    
    var soundsNames: [String] = []
    var soundPointer = 0
    
    func playPause() {
        if audioPlayer.rate == 0 {
            audioPlayer.play()
        } else {
            audioPlayer.pause()
        }
    }
    
    func play() {
        audioPlayer.play()
        print(soundPointer)
        print(soundsNames[soundPointer])
    }
    
    func pause() {
        audioPlayer.pause()
    }
    
    mutating func nextSound() {
        soundPointer += 1
        
        if soundPointer >= soundsNames.count {
            soundPointer = 0
        }
        
        pushSound()
    }
    
    mutating func prevSound() {
        soundPointer -= 1
        
        if soundPointer < 0 {
            soundPointer = soundsNames.count - 1
        }
        
        pushSound()
    }
    
    func getCountOfSounds() -> Int {
        return soundsNames.count
    }
    
    func getSoundCover() -> UIImage {
        if let currentItem = audioPlayer.currentItem {
            if let asset = currentItem.currentMediaSelection.asset {
                for item in asset.metadata {
                    switch item.commonKey {
                    case .commonKeyArtwork?:
                        if let data = item.dataValue, let image = UIImage(data: data) {
                            return image
                        }
                    case .none: break
                    case .some(_): break
                    }
                }
            }
        }
        return UIImage(named: "defCover") ?? UIImage()
    }
    
    func timelineMovedTo(value: Float) {
        if let duration = audioPlayer.currentItem?.duration {
            let totalSeconds = CMTimeGetSeconds(duration)
            let current = Float64(value) * totalSeconds
            let seekTime = CMTime(value: Int64(current), timescale: 1)
            
            print(seekTime)
            audioPlayer.seek(to: seekTime)
        }
    }
    
    mutating func pushSound() {
        if let audioPath =  Bundle.main.path(forResource: soundsNames[soundPointer], ofType: ".mp3") {
            let playerItem:AVPlayerItem = AVPlayerItem(url: NSURL(fileURLWithPath: audioPath) as URL)
            audioPlayer.replaceCurrentItem(with: playerItem)
        }
    }
    
    mutating func pushSoundBy(id: Int) {
        if let audioPath =  Bundle.main.path(forResource: soundsNames[id], ofType: ".mp3") {
            let playerItem:AVPlayerItem = AVPlayerItem(url: NSURL(fileURLWithPath: audioPath) as URL)
            audioPlayer.replaceCurrentItem(with: playerItem)
            //audioPlayer = AVPlayer(playerItem: playerItem)
            soundPointer = id
        }
    }
    
    mutating func getMusicNames() {
        if let url = Bundle.main.resourcePath {
            let folderUrl = URL(fileURLWithPath: url)
            
            do {
                let files = try FileManager.default.contentsOfDirectory(at: folderUrl, includingPropertiesForKeys: nil , options: .skipsHiddenFiles)
                
                for file in files {
                    if file.absoluteString.contains(".mp3") {
                        let soundPath = file.absoluteString.components(separatedBy: "/")
                        var soundName = soundPath[soundPath.count - 1]
                        soundName = soundName.replacingOccurrences(of: "%20", with: " ")
                        soundName = soundName.replacingOccurrences(of: ".mp3", with: "")
                        soundsNames.append(soundName)
                        print(soundName)
                    }
                }
            } catch {
                
            }
        } else {
            print("Get music: Path error ...")
        }
    }
}
