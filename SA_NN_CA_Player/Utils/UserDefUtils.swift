//
//  UserDefUtils.swift
//  SA_NN_CA_Player
//
//  Created by Dmitriy Kruglov on 11/15/19.
//  Copyright © 2019 SPAlgorithm. All rights reserved.
//

import Foundation

class UserDefaultsUtils {
    
    //-------------------------------------------------------------------------------------------
    // MARK: - save to user defaults
    //-------------------------------------------------------------------------------------------
    
    static func save<T>(value: T, key: String) {
        UserDefaults.standard.set(value, forKey: key)
    }
    
    static func saveModel<T: Encodable>(value: T, key: String) -> Bool {
        // return value is success indicator
        do {
            let encodedData = try JSONEncoder().encode(value)
            UserDefaultsUtils.save(value: encodedData, key: key)
            return true
        } catch {
            return false
        }
    }
    
    
    //-------------------------------------------------------------------------------------------
    // MARK: - get from user defaults
    //-------------------------------------------------------------------------------------------
    
    static func getBool(key: String) -> Bool? {
        return UserDefaults.standard.bool(forKey: key)
    }
    
    static func getInt(key: String) -> Int? {
        return UserDefaults.standard.integer(forKey: key)
    }
    
    static func getString(key: String) -> String? {
        return UserDefaults.standard.string(forKey: key)
    }
    
    static func getData(key: String) -> Data? {
        return UserDefaults.standard.data(forKey: key)
    }
    
    static func getDictionary(key: String) -> Dictionary<String, Any>? {
        return UserDefaults.standard.dictionary(forKey: key)
    }
    
    static func getObject(key: String) -> Any? {
        return UserDefaults.standard.object(forKey: key)
    }
    
    static func getArray(key: String) -> [Any]? {
        return UserDefaults.standard.array(forKey: key)
    }
    
    static func getModel<T: Decodable>(type: T.Type, key: String) -> (model: T?, error: String?) {
        let data = UserDefaultsUtils.getData(key: key)
        if let encodedModel = data {
            do {
                let decoded = try JSONDecoder().decode(T.self, from: encodedModel)
                return (decoded, nil)
            } catch {
                return (nil, "Decoding Error ...")
            }
        } else {
            return (nil, "Data is nil ...")
        }
    }
    
    
    //-------------------------------------------------------------------------------------------
    // MARK: - get from user defaults with default value
    //-------------------------------------------------------------------------------------------
    
    static func getString(key: String, defaultValue: String) -> String {
        if let str = getString(key: key) {
            return str
        }
        return defaultValue
    }
    
    static func getData(key: String, defaultValue: Data) -> Data {
        if let data = getData(key: key) {
            return data
        }
        return defaultValue
    }
    
    static func getDictionary(key: String, defaultValue: Dictionary<String, Any>) -> Dictionary<String, Any> {
        if let dict = getDictionary(key: key) {
            return dict
        }
        return defaultValue
    }
    
    static func getObject(key: String, defaultValue: Any) -> Any {
        if let any = getObject(key: key) {
            return any
        }
        return defaultValue
    }
    
    class func getArray(key: String, defaultValue: [Any]) -> [Any] {
        if let array = getArray(key: key) {
            return array
        }
        return defaultValue
    }
    
    
    //-------------------------------------------------------------------------------------------
    // MARK: - remove from user defaults
    //-------------------------------------------------------------------------------------------
    
    static func removeBy(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }
    
    static func removeAll() {
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
    }
}
