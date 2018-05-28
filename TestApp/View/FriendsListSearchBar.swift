//
//  FriendsListSearchBar.swift
//  TestApp
//
//  Created by Admin on 26.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

private struct Constants {
    static let searchBarBorderWidth: CGFloat = 1
    
    static let textFieldBorderWidth: CGFloat = 1
    static let textFieldCornerRadius: CGFloat = 8
}

final class FriendsListSearchBar: UISearchBar {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        barTintColor = .white
        tintColor = .black
        layer.borderWidth = Constants.searchBarBorderWidth
        layer.borderColor = UIColor.white.cgColor
        
        let textField = value(forKey: "_searchField") as! UITextField
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = Constants.textFieldBorderWidth
        textField.layer.cornerRadius = Constants.textFieldCornerRadius
        textField.clipsToBounds = true
    }
}
