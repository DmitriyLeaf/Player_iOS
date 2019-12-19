//
//  WeightModel.swift
//  SA_NN_CA_Player
//
//  Created by Solomay on 12/18/19.
//  Copyright © 2019 SPAlgorithm. All rights reserved.
//

import Foundation

struct WeightModel {
    var weights: [[Float]]
    
    init(soundCount: Int) {
        self.weights = Array(repeating: Array(repeating: 100, count: soundCount), count: soundCount)
         
    }
}

extension WeightModel {
    mutating func getFromUD(key: String) {
        let result = UserDefaultsUtils.getModel(type: WeightModel.self, key: key)
        
        if let model = result.model {
            self = model
        }
        
        if result.error != nil {
            print("Error: Get from user def tabel ...")
        }
    }
    
    func saveToUD(key: String) {
        if UserDefaultsUtils.saveModel(value: self, key: key) {
            print("Saved weight to UD ...")
        } else {
            print("Error: not saved weight to UD ...")
        }
    }
    
    func printW() {
        print("###")
        for w in self.weights {
            print(w)
        }
        print("###")
    }
    
}

extension WeightModel: Codable {
    private enum Keys: String, CodingKey {
        case weights = "weights"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        weights = try container.decode([[Float]].self, forKey: .weights)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(weights, forKey: .weights)
    }
}
