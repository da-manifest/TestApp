//
//  VKAPIService.swift
//  TestApp
//
//  Created by Admin on 26.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//

import RxSwift
import SwiftyJSON
import SwiftyVK

private struct Constants {
    
    static let neverExpires: Double = 0
}

final class VKAPIService {
    
    static func login() -> Observable<Void> {
        return checkSessionIsActive().flatMap{ isActive -> Observable<Void> in
            if isActive {
                return Observable.just(())
            }
            if let token = KeychainService.loadToken() {
                return loginWith(token: token)
            }
            return Observable.error(RxError.unknown)
        }
    }
    
    static func logout() -> Observable<Void> {
        return Observable.create { observer in
            VK.sessions.default.logOut()
            
            let cookieJar = HTTPCookieStorage.shared
            for cookie in cookieJar.cookies! {
                if cookie.domain.contains(".vk.com") {
                    cookieJar.deleteCookie(cookie)
                }
                print("Cookie deleted: ", cookie.name+"="+cookie.value, cookie.domain)
            }
            
            observer.onNext(())
            observer.onCompleted()
            print("SwiftyVK: logout completed")
            return Disposables.create()
        }
    }
    
    static func friendsGet(offset: Int) -> Observable<[Friend]> {
        return Observable.create { observer in
            let parameters = [
                Parameter.offset: "\(offset)",
                Parameter.fields: "first_name, last_name, photo_200, last_seen, online"
            ]
            VK.API.Friends.get(parameters)
                .onSuccess { rawJSON in
                    let json = JSON(rawJSON)
                    let rawFriendsArray = json["items"].arrayValue
                    observer.onNext(FriendParser.parseArray(rawFriendsArray))
                    observer.onCompleted()
                    print("SwiftyVK: friends.get successed with \n \(JSON(rawJSON))")
                }
                .onError { error in
                    observer.onError(error)
                    print("SwiftyVK: friends.get failed with \n \(error)")
                }
                .send()
            return Disposables.create()
        }
    }
    
    static func friendsSearch(_ searchString: String, offset: Int) -> Observable<[Friend]> {
        return Observable.create { observer in
            let parameters = [
                Parameter.q: searchString,
                Parameter.offset: "\(offset)",
                Parameter.fields: "first_name, last_name, photo_200, last_seen, online"
            ]
            VK.API.Friends.search(parameters)
                .onSuccess{ rawJSON in
                    let json = JSON(rawJSON)
                    let rawFriendsArray = json["items"].arrayValue
                    observer.onNext(FriendParser.parseArray(rawFriendsArray))
                    observer.onCompleted()
                    print("SwiftyVK: friends.search successed with \n \(JSON(rawJSON))")
            }
                .onError { error in
                    observer.onError(error)
                    print("SwiftyVK: friends.search failed with \n \(error)")
            }
            .send()
            return Disposables.create()
        }
    }
}

// MARK: - Private
private extension VKAPIService {
    
    static func checkSessionIsActive() -> Observable<Bool> {
        return Observable.create { observer in
            let parameters = [Parameter.fields: "uid"]
            VK.API.Users.get(parameters)
                .onSuccess { _ in
                    observer.onNext(true)
                    observer.onCompleted()
                }
                .onError { error in
                   observer.onError(error)
                }
                .send()
            return Disposables.create()
        }
    }
    
    static func loginWith(token: String) -> Observable<Void> {
        return Observable.create{ observer in
            do {
                try VK.sessions.default.logIn(rawToken: token,
                                              expires: Constants.neverExpires)
                observer.onNext(())
                observer.onCompleted()
            } catch {
                observer.onError(RxError.unknown)
                KeychainService.save(token: "")
                UserDefaults.standard.set("", forKey: "vkToken")
                print("SwiftyVK: authorize failed with rawToken")
            }
            return Disposables.create()
        }
    }
}
