//
//  SoundModel.swift
//  SA_NN_CA_Player
//
//  Created by Dmitriy Kruglov on 11/17/19.
//  Copyright © 2019 SPAlgorithm. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

struct SoundModel {
    let id: Int
    var name: String
    
    var url: URL?
    var item: AVPlayerItem?
    var artist: String?
    var group: String?
    var album: String?
    var cover: Data?
    var genre: String?
    var title: String?
    
    init(id: Int, name: String) {
        self.id = id
        self.name = name
        self.getItemByName()
        self.getSoundInfo()
    }
}

extension SoundModel {
    mutating func getItemByName() {
        if let audioPath =  Bundle.main.path(forResource: name, ofType: ".mp3") {
            item = AVPlayerItem(url: NSURL(fileURLWithPath: audioPath) as URL)
        } else {
            print("Error path file ...")
        }
    }
    
    mutating func getItemByURL() {
        if let sUrl = url {
            item = AVPlayerItem(url: sUrl)
        } else {
            print("No sound url ...")
        }
    }
    
    mutating func getSoundInfo() {
        if let mItem = item {
            let metadataList = mItem.asset.metadata
            for item in metadataList {
                switch item.commonKey {
                case .commonKeyTitle?:
                    title = item.stringValue
                case .commonKeyType?:
                    genre = item.stringValue
                case .commonKeyAlbumName?:
                    album = item.stringValue
                case .commonKeyArtist?:
                    artist = item.stringValue
                case .commonKeyArtwork?:
                    cover = item.dataValue
                case .none: break
                default: break
                }
            }
        }
    }
    
}
    
extension SoundModel: Codable {
    private enum Keys: String, CodingKey {
        case id = "id"
        case name = "name"
        
        case url = "url"
        case item = "item"
        case artist = "artist"
        case group = "group"
        case album = "album"
        case cover = "cover"
        case genre = "genre"
        case title = "title"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: Keys.self)
        
        id = try container.decode(Int.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        
        url = try? container.decode(URL.self, forKey: .url)
        artist = try? container.decode(String.self, forKey: .artist)
        group = try? container.decode(String.self, forKey: .group)
        album = try? container.decode(String.self, forKey: .album)
        cover = try? container.decode(Data.self, forKey: .cover)
        genre = try? container.decode(String.self, forKey: .genre)
        title = try? container.decode(String.self, forKey: .title)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: Keys.self)
        
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        
        try? container.encode(url, forKey: .url)
        try? container.encode(artist, forKey: .artist)
        try? container.encode(group, forKey: .group)
        try? container.encode(album, forKey: .album)
        try? container.encode(cover, forKey: .cover)
        try? container.encode(genre, forKey: .genre)
        try? container.encode(title, forKey: .title)
    }
}
