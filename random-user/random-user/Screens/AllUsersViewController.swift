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
    private var users: [User] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    weak var delegate: AllUsersViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "All users"
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.register(UINib(nibName: String(describing: UserTableViewCell.self), bundle:nil), forCellReuseIdentifier: String(describing: UserTableViewCell.self))
        
        RandomUserService().getRandomUsers(numberOfUsers: 29, page: 1) { result in
            switch result {
                case .success(let userResponse):
                    self.users.append(contentsOf: userResponse.results)
                case .failure(let error):
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    let action = UIAlertAction(title: "Ok", style: .default)
                    alert.addAction(action)
                    self.present(alert, animated: true)
                    
            }
        }
    }
    
}

//MARK: - UITableViewDataSource
extension AllUsersViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UserTableViewCell.self), for: indexPath) as! UserTableViewCell
        let user = users[indexPath.row]
        cell.setup(name: user.name.full, age: user.dateOfBirth.age, flag: user.nationalityFlag, imageUrl: user.picture.large)
        return cell
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
