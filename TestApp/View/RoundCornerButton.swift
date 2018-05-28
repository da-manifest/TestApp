//
//  RoundCornerButton.swift
//  Login
//
//  Created by Admin on 26.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

private struct Constants {
    
    static let bottomWidth: CGFloat = 1
    static let cornerRadius: CGFloat = 8
}

final class RoundCornerButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundColor = .clear
        tintColor = .black
        layer.cornerRadius = Constants.cornerRadius
        layer.borderWidth = Constants.bottomWidth
        layer.borderColor = UIColor.black.cgColor
    }
}
