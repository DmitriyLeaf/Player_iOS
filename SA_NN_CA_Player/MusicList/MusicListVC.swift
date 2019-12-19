//
//  MusicListVC.swift
//  SA_NN_CA_Player
//
//  Created by Solomay on 11/13/19.
//  Copyright © 2019 SPAlgorithm. All rights reserved.
//

import UIKit
import AVFoundation

class MusicListVC: UIViewController {
    @IBOutlet var musikListTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.searchController = UISearchController(searchResultsController: nil)
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
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "soundReId")
        cell.textLabel?.text = MusicController.shared.sounds[indexPath.row].name
        cell.detailTextLabel?.text = String(describing: WeightManager.shared.weights.weights[indexPath.row][indexPath.row])
        cell.backgroundColor = UIColor(red: 241, green: 241, blue: 241, alpha: 0)
        if (MusicController.shared.soundPointer == indexPath.row) {
            //cell.imageView?.image = UIImage(named: "music-7")! // "playn")!
            cell.backgroundColor = hexStringToUIColor(hex: "ebd099").withAlphaComponent(0.9)
            cell.imageView?.clipsToBounds = true
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
            //cell.imageView?.image = UIImage(named: "music-7")!
            cell.backgroundColor = hexStringToUIColor(hex: "ebd099").withAlphaComponent(0.9)
            cell.setSelected(false, animated: true)
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

