//
//  ViewController.swift
//  KDAN
//
//  Created by our F on 2025/5/14.
//

import UIKit

class UserListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let viewModel = UserListViewModel()
    private let tableView = UITableView()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "User List"
        view.backgroundColor = .white
        setupTableView()
        bindViewModel()
        viewModel.fetchUsers(isInitial: true)
    }
    
    private func setupTableView() {
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.identifier)
        tableView.register(LoadingCell.self, forCellReuseIdentifier: LoadingCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        view.addSubview(tableView)
        
        tableView.snp.makeConstraints { make in
            make.edges.equalTo(self.view)
        }
    }
    
    private func bindViewModel() {
        viewModel.onUsersUpdated = { [weak self] in
            self?.tableView.reloadData()
        }
        
        viewModel.onError = { [weak self] message in
            self?.showRetryAlert(message: message, retryHandler: {
                self?.viewModel.fetchUsers(isInitial: true)
            })
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.users.count + (viewModel.isLoading ? 1 : 0)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row < viewModel.users.count {
            let user = viewModel.users[indexPath.row]
            guard let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.identifier, for: indexPath) as? UserCell else {
                return UITableViewCell()
            }
            cell.configure(with: user)
            return cell
        } else {
            return tableView.dequeueReusableCell(withIdentifier: LoadingCell.identifier, for: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row < viewModel.users.count {
            let user = viewModel.users[indexPath.row]
            let detailVC = UserDetailViewController(user: user)
            navigationController?.pushViewController(detailVC, animated: true)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let height = scrollView.frame.size.height

        if offsetY > contentHeight - height * 2 {
            viewModel.fetchUsers()
        }
    }
}

