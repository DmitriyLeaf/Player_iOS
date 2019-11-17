//
//  MusicListVC.swift
//  SA_NN_CA_Player
//
//  Created by Dmitriy Kruglov on 11/13/19.
//  Copyright © 2019 SPAlgorithm. All rights reserved.
//

import UIKit
import AVFoundation

class MusicListVC: UIViewController {
    @IBOutlet var musikListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        musikListTableView.reloadData()
    }
}

extension MusicListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MusicController.shared.getCountOfSounds()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: "soundReId")
        cell.textLabel?.text = MusicController.shared.sounds[indexPath.row].name
        if (MusicController.shared.soundPointer == indexPath.row) {
            cell.imageView?.image = UIImage(named: "playn")!
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let oldIndex = IndexPath(row: MusicController.shared.soundPointer, section: 0)
        if let cell = tableView.cellForRow(at: oldIndex) {
            cell.imageView?.image = UIImage()
        }
        
        MusicController.shared.pushBy(id: indexPath.row)
        MusicController.shared.play()
        
        musikListTableView.reloadData()
        
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.imageView?.image = UIImage(named: "playn")!
            cell.setSelected(false, animated: true)
        }
    }
}

