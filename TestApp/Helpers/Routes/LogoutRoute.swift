//
//  LogoutRoute.swift
//  TestApp
//
//  Created by Admin on 26.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

protocol LogoutRoute {
    
    func dismissFriendsListScreen()
}

extension LogoutRoute where Self: UIViewController {
    
    func dismissFriendsListScreen() {
        DispatchQueue.main.async { [weak self] in
            self?.dismiss(animated: true)
        }
    }
}
