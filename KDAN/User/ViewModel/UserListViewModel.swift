//
//  UserListViewModel.swift
//  KDAN
//
//  Created by our F on 2025/5/15.
//

import Foundation

class UserListViewModel {
    private(set) var users: [User] = []
    private(set) var isLoading = false
    private var lastUserID: Int = 0

    var onUsersUpdated: (() -> Void)?
    var onError: ((String) -> Void)?
    
    func fetchUsers(isInitial: Bool = false) {
        guard !isLoading else { return }
        isLoading = true

        if isInitial {
            users.removeAll()
            lastUserID = 0
        }

        let urlString = "https://api.github.com/users?since=\(lastUserID)&per_page=20"

        NetworkManager.shared.request(urlString: urlString) { [weak self] (result: Result<[User], Error>) in
            guard let self = self else { return }
            self.isLoading = false

            switch result {
            case .success(let newUsers):
                if let lastID = newUsers.last?.id {
                    self.lastUserID = lastID
                }
                self.users.append(contentsOf: newUsers)
                self.onUsersUpdated?()

            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
}
