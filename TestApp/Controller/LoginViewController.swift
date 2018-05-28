//
//  LoginViewController.swift
//  TestApp
//
//  Created by Admin on 26.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import SwiftyVK

final class LoginViewController: UIViewController, LoginViewController.Routes {
    
    typealias Routes = FriendsListRoute & ErrorRoute

    @IBOutlet weak var loginButton: RoundCornerButton!
    
    override func viewDidLoad() {
        configureEvents()
        login()
    }
}

// MARK: - Configure UI / Events
private extension LoginViewController {
    
    func configureEvents() {
        _ = loginButton.rx.tap
            .takeUntil(rx.deallocated)
            .subscribe(onNext: { [weak self] in
                self?.login()
            })
    }
}

// MARK: - Requests
private extension LoginViewController {
    
    func login() {
        ActivityIndicator.shared.show(on: view)
        _ = VKAPIService.login().subscribe(onNext: { [weak self] _ in
            ActivityIndicator.shared.hide()
            self?.openFriendsListScreen()
            }, onError: { [weak self] error in
                ActivityIndicator.shared.hide()
                if error.localizedDescription == VKError.authorizationCancelled.localizedDescription {
                    return
                }
                self?.showError(error)
        })
    }
}
