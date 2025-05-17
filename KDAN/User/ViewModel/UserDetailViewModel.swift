//
//  UserDetailViewModel.swift
//  KDAN
//
//  Created by our F on 2025/5/15.
//

import Foundation

class UserDetailViewModel {
    private(set) var users: [User] = []
    private(set) var isLoading = false
    private var lastUserID: Int = 0

    var onDetailUpdated: ((UserDetail) -> Void)?
    var onError: ((String) -> Void)?

    func fetchUserDetail(for userName: String) {
        NetworkManager.shared.request(urlString: "https://api.github.com/users/\(userName)") { (result: Result<UserDetail, Error>) in
            switch result {
            case .success(let detail):
                self.onDetailUpdated?(detail)
            case .failure(let error):
                self.onError?(error.localizedDescription)
            }
        }
    }
}
