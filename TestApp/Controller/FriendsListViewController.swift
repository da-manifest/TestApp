//
//  FriendsListViewController.swift
//  TestApp
//
//  Created by Admin on 26.05.2018.
//  Copyright © 2018 Admin. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa
import Kingfisher

private struct Constants {
    
    static let numberOfSections = 1
    
    static let searchIdleTime: Double = 1
    static let searchIdleCount = 3
    
    static let tableViewActivityIndicatorHeight: CGFloat = 44
}

final class FriendsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FriendsListViewController.Routes {
   
    typealias Routes = LogoutRoute & ErrorRoute
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: FriendsListSearchBar!
    
    private var isSearching = false
    private var isFinishedLoadingFriends = false
    
    private var friends: [Friend] = []
    private var searchedFriends: [Friend] = []
    private var presentedFriends: [Friend] {
        return isSearching ? searchedFriends : friends
    }
    
    override func viewDidLoad() {
        configureUI()
        configureEvents()
        friendsGet()
    }
}

// MARK: - Configure UI / Events
private extension FriendsListViewController {
    
    func configureUI() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        tableView.register(FriendsListTableViewCell.nib,
                           forCellReuseIdentifier: FriendsListTableViewCell.identifier)
    }
    
    func configureEvents() {
        _ = logoutButton.rx.tap
            .takeUntil(rx.deallocated)
            .subscribe(onNext: { [weak self] in
                self?.logout()
            })
        
        _ = searchBar.rx.text
            .throttle(Constants.searchIdleTime, scheduler: MainScheduler.instance)
            .takeUntil(rx.deallocated)
            .subscribe(onNext: { [weak self] string in
                if let searchString = string, searchString.count >= Constants.searchIdleCount {
                    self?.isSearching = true
                    self?.friendsSearch(searchString)
                    return
                }
                self?.isSearching = false
                self?.tableView.reloadData()
            })
        
        _ = tableView.rx.didScroll
            .takeUntil(rx.deallocated)
            .subscribe(onNext: {[weak self] in
                self?.searchBar.resignFirstResponder()
            })
    }
}

// MARK: - Requests
private extension FriendsListViewController {
    
    func logout() {
        ActivityIndicator.shared.show(on: view)
        _ = VKAPIService.logout().subscribe(onNext: { [weak self] in
            ActivityIndicator.shared.hide()
            self?.dismissFriendsListScreen()
        })
    }
    
    func friendsGet(offset: Int = 0) {
        showTableViewActivityIndicator()
        _ = VKAPIService.friendsGet(offset: offset).subscribe(onNext: { [weak self] result in
            self?.hideTableViewActivityIndicator()
            self?.isFinishedLoadingFriends = result.isEmpty
            result.forEach{ self?.friends.append($0) }
            DispatchQueue.main.async{ self?.tableView.reloadData() }
            }, onError: { [weak self] error in
                self?.hideTableViewActivityIndicator()
                self?.showError(error)
        })
    }
    
    func friendsSearch(_ text: String, offset: Int = 0, isNewSearch: Bool = true) {
        showTableViewActivityIndicator()
        _ = VKAPIService.friendsSearch(text, offset:  offset).subscribe(onNext: { [weak self] result in
            self?.hideTableViewActivityIndicator()
            self?.isFinishedLoadingFriends = result.isEmpty
            if isNewSearch {
                self?.searchedFriends = []
            }
            result.forEach{ self?.searchedFriends.append($0) }
            DispatchQueue.main.async{ self?.tableView.reloadData() }
            }, onError: { [weak self] error in
                self?.hideTableViewActivityIndicator()
                self?.showError(error)
        })
    }
}

// MARK: - Tableview Delegate / DataSource
extension FriendsListViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return Constants.numberOfSections
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presentedFriends.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: FriendsListTableViewCell.identifier,
                                                 for: indexPath) as! FriendsListTableViewCell
        let friend = presentedFriends[indexPath.row]
        cell.name.text = friend.name
        cell.status.text = friend.status
        cell.userImage.kf.setImage(with: URL(string: friend.imageLink))
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let isLastElement = indexPath.row == presentedFriends.count - 1
        
        if isLastElement && !isFinishedLoadingFriends {
            if isSearching {
                friendsSearch(searchBar.text ?? "",
                              offset: presentedFriends.count,
                              isNewSearch: false
                )
                return
            }
            friendsGet(offset: presentedFriends.count)
            return
        }
    }
}

// MARK: - TableView Activity Indicator
private extension FriendsListViewController {
    
    func showTableViewActivityIndicator() {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
        activityIndicator.color = .black
        activityIndicator.startAnimating()
        activityIndicator.frame = CGRect(x: 0, y: 0,
                                         width: tableView.bounds.width,
                                         height: Constants.tableViewActivityIndicatorHeight)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.tableFooterView = activityIndicator
        }
    }
    
    func hideTableViewActivityIndicator() {
        DispatchQueue.main.async { [weak self] in
            self?.tableView.tableFooterView = nil
        }
    }
}

