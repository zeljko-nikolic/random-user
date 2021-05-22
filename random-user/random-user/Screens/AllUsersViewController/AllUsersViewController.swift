//
//  AllUsersViewController.swift
//  Random-user
//
//  Created by Zeljko Nikolic on 21.5.21..
//

import UIKit

protocol AllUsersViewControllerDelegate: AnyObject {
    func allUsersViewController(_ allUsersViewController: AllUsersViewController, didSelect user: User)
}

final class AllUsersViewController: UIViewController {
    
    @IBOutlet private weak var tableView: UITableView!
    private var totalUsersCount: Int = 0
    private var users: [User] = []
    private var currentPage = 1
    private var isFetchingNextPage = false
    weak var delegate: AllUsersViewControllerDelegate?
    
    /*
     To achieve smooth scrolling and transition when a new page is loaded, we need to
     know the max number of users because tableView needs to allocate enough memory.
     Since https://randomuser.me/api does not provide us that information (as it generates users),
     we use this variable to fit that requirement for us.
     */
    private let maxNumberOfUsers = 500
    private let usersPerPage = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "All users"
        setupTableView()
        tableView.refreshControl?.beginRefreshing()
        refreshUsers()
    }
        
    //MARK: - Private
    private func setupTableView() {
        tableView.dataSource = self
        tableView.prefetchDataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: String(describing: UserTableViewCell.self), bundle:nil), forCellReuseIdentifier: String(describing: UserTableViewCell.self))
        tableView.refreshControl = UIRefreshControl()
        tableView.refreshControl?.addTarget(self, action: #selector(refreshUsers), for: .valueChanged)
    }
    
    @objc private func refreshUsers() {
        currentPage = 1
        loadUsers(refresh: true)
    }
    
    private func loadUsers(refresh: Bool) {
        isFetchingNextPage = true
        RandomUserService().getRandomUsers(numberOfUsers: usersPerPage, page: currentPage) { result in
            switch result {
                case .success(let userResponse):
                    if self.totalUsersCount == 0 {
                        self.totalUsersCount = self.maxNumberOfUsers
                    }
                    if refresh {
                        self.users = userResponse.results
                        self.tableView.refreshControl?.endRefreshing()
                        self.tableView.reloadData()
                    }
                    else {
                        for user in userResponse.results {
                            if !self.users.contains(user) {
                                self.users.append(user)
                            }
                        }
                        
                        let startIndex = self.users.count - userResponse.results.count
                        let endIndex = startIndex + userResponse.results.count - 1
                        let newIndexPaths = (startIndex...endIndex).map { IndexPath(row: $0, section: 0)}
                        let visibleIndexPaths = Set(self.tableView.indexPathsForVisibleRows ?? [])
                        let indexPathsNeedingReload = Set(newIndexPaths).intersection(visibleIndexPaths)
                        self.tableView.reloadRows(at: Array(indexPathsNeedingReload), with: .fade)
                    }
                case .failure(let error):
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                    
            }
            self.isFetchingNextPage = false
        }
    }
    
    private func fetchNextPage() {
        guard !isFetchingNextPage else { return }
        currentPage += 1
        loadUsers(refresh: false)
    }
    
    private func isLoadingIndexPath(_ indexPath: IndexPath) -> Bool {
        return indexPath.row >= self.users.count
    }
}

//MARK: - UITableViewDataSource
extension AllUsersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        totalUsersCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if isLoadingIndexPath(indexPath) {
            return LoadingTableViewCell(style: .default, reuseIdentifier: "loading")
        }
        else {
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserTableViewCell.self), for: indexPath) as! UserTableViewCell
            cell.setup(user: users[indexPath.row])
            return cell
        }
    }
    
}

//MARK: - UITableViewDelegate
extension AllUsersViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        140
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.allUsersViewController(self, didSelect: users[indexPath.row])
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

//MARK: - UITableViewDataSourcePrefetching
extension AllUsersViewController: UITableViewDataSourcePrefetching {
    
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let needsFetch = indexPaths.contains { $0.row >= users.count }
        if needsFetch {
            fetchNextPage()
        }
    }
}
