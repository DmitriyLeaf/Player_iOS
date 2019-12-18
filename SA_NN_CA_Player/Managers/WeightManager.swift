//
//  WeightManager.swift
//  SA_NN_CA_Player
//
//  Created by Dmitriy Kruglov on 12/18/19.
//  Copyright © 2019 SPAlgorithm. All rights reserved.
//

import Foundation

struct WeightManager {
    static var shared = WeightManager()
    
    private init() {}
    
    let key = "MusicWeight42"
    
    var weights = WeightModel(soundCount: 10)
    
    var pre = -1
    
    let wMAX: Float = 100
    let fi: Float = 1.618
    
    mutating func get(soundCounts: Int) {
        weights = WeightModel(soundCount: soundCounts)
        weights.getFromUD(key: self.key)
        weights.printW()
    }
    
    func save() {
        weights.saveToUD(key: self.key)
        weights.printW()
    }
    
    mutating func next(sId: Int, value: Float) {
        if value <= wMAX-wMAX/fi {
            weights.weights[sId][sId] /= fi
            if self.pre != -1 {
                weights.weights[self.pre][sId] /= fi
            }
        } else if value >= wMAX/fi {
            weights.weights[sId][sId] = wMAX-(wMAX-weights.weights[sId][sId])/fi
            if self.pre != -1 {
                weights.weights[self.pre][sId] = wMAX-(wMAX-weights.weights[self.pre][sId])/fi
            }
        }
        self.pre = sId
        self.save()
    }
    
    mutating func prew(sId: Int, value: Float) {
        if value <= wMAX-wMAX/fi {
            weights.weights[sId][sId] /= fi
            if self.pre != -1 {
                weights.weights[sId][self.pre] /= fi
            }
        } else if value >= wMAX/fi {
            weights.weights[sId][sId] = wMAX-(wMAX-weights.weights[sId][sId])/fi
            if self.pre != -1 {
                weights.weights[sId][self.pre] = wMAX-(wMAX-weights.weights[sId][self.pre])/fi
            }
        }
        self.pre = sId
        self.save()
    }
    
    func getNext(sId: Int) -> Int? {
        if let maxV = weights.weights[sId].max() {
            return weights.weights[sId].firstIndex(of: maxV)
        }
        return nil
    }
    
    func getPrew(sId: Int) -> Int? {
        var wPull = [Float]()
        for sPull in weights.weights {
            wPull.append(sPull[sId])
        }
        if let maxV = wPull.max() {
            return wPull.firstIndex(of: maxV)
        }
        return nil
    }
}
