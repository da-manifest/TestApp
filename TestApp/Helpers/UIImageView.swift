//
//  UIImageView.swift
//  Login
//
//  Created by Admin on 26.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

extension UIImageView {
    
    func makeRounded() {
        layer.cornerRadius = (frame.width / 2)
        layer.masksToBounds = true
    }
}
