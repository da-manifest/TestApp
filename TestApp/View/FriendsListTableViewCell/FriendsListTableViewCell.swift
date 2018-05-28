//
//  FriendsListTableViewCell.swift
//  Login
//
//  Created by Admin on 26.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

final class FriendsListTableViewCell: UITableViewCell {

    @IBOutlet weak var userImage: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var status: UILabel!
    
    static let identifier = "FriendsListTableViewCell"
    static let nib = UINib(nibName: "FriendsListTableViewCell", bundle: nil)
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        userImage.makeRounded()
        status.textColor = .gray
    }
}
