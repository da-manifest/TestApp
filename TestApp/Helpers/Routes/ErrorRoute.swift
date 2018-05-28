//
//  ErrorRoute.swift
//  TestApp
//
//  Created by Admin on 26.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

private struct Constants {
    
    static let alertTitle = "Error"
    static let ok = "OK"
}

protocol ErrorRoute {
    
    func showError(_ error: Error)
}

extension ErrorRoute where Self: UIViewController {
    
    func showError(_ error: Error) {
        let alertMessage = error.localizedDescription
        let alertViewController = UIAlertController(title: Constants.alertTitle,
                                                    message: alertMessage,
                                                    preferredStyle: .alert)
        let okAction = UIAlertAction(title: Constants.ok, style: .default) { _ in
            alertViewController.dismiss(animated: true)
        }
        alertViewController.addAction(okAction)
        
        DispatchQueue.main.async { [weak self] in
            self?.present(alertViewController, animated: true)
        }
    }
}
