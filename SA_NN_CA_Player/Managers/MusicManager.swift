//
//  MusicManager.swift
//  SA_NN_CA_Player
//
//  Created by Dmitriy Kruglov on 11/17/19.
//  Copyright © 2019 SPAlgorithm. All rights reserved.
//

import Foundation

struct MusicManager {
    static var shared = MusicManager()
    
    private init() {}
    
    var musicKeys = [String]()
    
    var key = "MusicKeys42"
    
    func saveKeys() {
        UserDefaultsUtils.save(value: musicKeys, key: key)
    }
    
    mutating func getKeys() {
        if let keys = UserDefaultsUtils.getArray(key: key) as? [String] {
            musicKeys = keys
        }
    }
    
    mutating func saveSoundsToUserDef(sounds: [SoundModel]) {
        for sound in sounds {
            let sKey = "Sound_\(sound.id)_\(sound.name)"
            if UserDefaultsUtils.saveModel(value: sound, key: sKey) {
                musicKeys.append(sKey)
                print("\(sKey): Saved ...")
            } else {
                print("\(sKey): was not saved ...")
            }
        }
        
        saveKeys()
    }
    
    mutating func getSounds() -> [SoundModel] {
        getKeys()
        
        var sounds = [SoundModel]()
        for sKey in musicKeys {
            let result = UserDefaultsUtils.getModel(type: SoundModel.self, key: sKey)
            if let error = result.error {
                print(error)
            } else if let model = result.model {
                sounds.append(model)
            }
        }
        print(sounds)
        return sounds
    }
}
