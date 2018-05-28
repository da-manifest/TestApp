//
//  VKDelegate.swift
//  TestApp
//
//  Created by Admin on 26.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import SwiftyVK

final class VKDelegate: SwiftyVKDelegate {
    
    let appId = Bundle.main.object(forInfoDictionaryKey: "VK_APP_ID") as! String
    let scopes: Scopes = [.friends]
    
    init() {
        VK.setUp(appId: appId, delegate: self)
    }
    
    func vkNeedsScopes(for sessionId: String) -> Scopes {
        return scopes
    }
    
    func vkNeedToPresent(viewController: VKViewController) {
        
        if let rootViewController = UIApplication.shared.keyWindow?.rootViewController {
            rootViewController.present(viewController, animated: true)
        }
    }
    
    func vkTokenCreated(for sessionId: String, info: [String : String]) {
        let token = info["access_token"] ?? ""
        KeychainService.save(token: token)
        print("SwiftyVK: token created in session \(sessionId) with info \(info)")
    }
    
    func vkTokenUpdated(for sessionId: String, info: [String : String]) {
        let token = info["access_token"] ?? ""
        KeychainService.save(token: token)
        print("SwiftyVK: token updated in session \(sessionId) with info \(info)")
    }
    
    func vkTokenRemoved(for sessionId: String) {
        KeychainService.save(token: "")
        print("SwiftyVK: token removed in session \(sessionId)")
    }
}
