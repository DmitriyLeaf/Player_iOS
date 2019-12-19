//
//  MusicController.swift
//  SA_NN_CA_Player
//
//  Created by Solomay on 11/15/19.
//  Copyright © 2019 SPAlgorithm. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

struct MusicController {
    static var shared = MusicController()
    private init() {}
    
    var audioPlayer = AVPlayer()
    
    var sounds: [SoundModel] = []
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
        print(sounds[soundPointer].name)
    }
    
    func pause() {
        audioPlayer.pause()
    }
    
    mutating func nextSound() {
        if let next = WeightManager.shared.getNext(sId: soundPointer) {
            soundPointer = next
        } else {
            soundPointer += 1
        }
        
        if soundPointer >= sounds.count {
            soundPointer = 0
        }
        
        push()
    }
    
    mutating func prevSound() {
        if let prev = WeightManager.shared.getPrew(sId: soundPointer) {
            soundPointer = prev
        } else {
            soundPointer -= 1
        }
        
        if soundPointer < 0 {
            soundPointer = sounds.count - 1
        }
        
        push()
    }
    
    func getCountOfSounds() -> Int {
        return sounds.count
    }
    
    func getSoundCover() -> UIImage {
        if let cover = sounds[soundPointer].cover, let image = UIImage(data: cover) {
            return image
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
    
    mutating func push() {
        if let item = sounds[soundPointer].item {
            audioPlayer.replaceCurrentItem(with: item)
            audioPlayer.seek(to: CMTime.zero)
        }
    }
    
    mutating func pushBy(item: AVPlayerItem) {
        audioPlayer.replaceCurrentItem(with: item)
    }
    
    mutating func pushBy(id: Int) {
        if let item = sounds[id].item {
            audioPlayer.replaceCurrentItem(with: item)
            audioPlayer.seek(to: CMTime.zero)
            soundPointer = id
        }
    }
    
    func saveMusicToUserDef() {
        MusicManager.shared.saveSoundsToUserDef(sounds: sounds)
    }
    
    mutating func getMusic() {
        sounds = MusicManager.shared.getSounds()
        if sounds.isEmpty {
            print("Any sounds in user defaults ...")
            getMusicFromPath()
        } else {
            print("Sounds was goted ...")
        }
    }
    
    mutating func getMusicFromPath() {
        if let url = Bundle.main.resourcePath {
            let folderUrl = URL(fileURLWithPath: url)
            
            do {
                let files = try FileManager.default.contentsOfDirectory(at: folderUrl, includingPropertiesForKeys: nil , options: .skipsHiddenFiles)
                
                for (index, file) in files.enumerated() {
                    if file.absoluteString.contains(".mp3") {
                        let soundPath = file.absoluteString.components(separatedBy: "/")
                        var soundName = soundPath[soundPath.count - 1]
                        soundName = soundName.replacingOccurrences(of: "%20", with: " ")
                        soundName = soundName.replacingOccurrences(of: ".mp3", with: "")
                        sounds.append(SoundModel(id: index, name: soundName))
                        print(soundName)
                    }
                }
            } catch {
                print("Error with files path ...")
                return
            }
        } else {
            print("Get music: Path error ...")
            return
        }
        
        saveMusicToUserDef()
    }
}
