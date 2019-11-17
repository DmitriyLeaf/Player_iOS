//
//  UIButtonExt.swift
//  SA_NN_CA_Player
//
//  Created by Dmitriy Kruglov on 11/14/19.
//  Copyright © 2019 SPAlgorithm. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
}
