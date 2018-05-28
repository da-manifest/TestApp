//
//  FriendsListRoute.swift
//  TestApp
//
//  Created by Admin on 26.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

protocol FriendsListRoute {
    
    func openFriendsListScreen()
}

extension FriendsListRoute where Self: UIViewController {
    
    func openFriendsListScreen() {
        let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let friendsListTableViewController = mainStoryboard.instantiateViewController(withIdentifier: "FriendsListViewController")
        let navigationController = UINavigationController(rootViewController: friendsListTableViewController)
        DispatchQueue.main.async { [weak self] in
            self?.show(navigationController, sender: nil)
        }
    }
}
