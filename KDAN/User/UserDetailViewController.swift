//
//  UserDetailViewController.swift
//  KDAN
//
//  Created by our F on 2025/5/15.
//

import UIKit
import Kingfisher
import SnapKit

class UserDetailViewController: UIViewController {
    private let user: User
    private var userDetail: UserDetail?

    private let avatarImageView = UIImageView()
    private let loginLabel = UILabel()
    private let adminLabel = UILabel()
    private let bioLabel = UILabel()
    private let locationLabel = UILabel()
    private let emailLabel = UILabel()
    private let followersLabel = UILabel()
    private let followingLabel = UILabel()
    private let activityIndicator = UIActivityIndicatorView(style: .large)

    init(user: User) {
        self.user = user
        super.init(nibName: nil, bundle: nil)
        title = user.login
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setupUI()
        fetchUserDetail()
    }

    private func setupUI() {
        avatarImageView.layer.cornerRadius = 50
        avatarImageView.clipsToBounds = true

        bioLabel.numberOfLines = 0
        bioLabel.font = UIFont.systemFont(ofSize: 16)

        locationLabel.font = UIFont.systemFont(ofSize: 16)
        emailLabel.font = UIFont.systemFont(ofSize: 16)
        followersLabel.font = UIFont.systemFont(ofSize: 16)
        followingLabel.font = UIFont.systemFont(ofSize: 16)

        view.addSubview(avatarImageView)
        view.addSubview(loginLabel)
        view.addSubview(adminLabel)
        view.addSubview(bioLabel)
        view.addSubview(locationLabel)
        view.addSubview(emailLabel)
        view.addSubview(followersLabel)
        view.addSubview(followingLabel)
        view.addSubview(activityIndicator)

        avatarImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(40)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(100)
        }

        loginLabel.snp.makeConstraints { make in
            make.top.equalTo(avatarImageView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }

        adminLabel.snp.makeConstraints { make in
            make.top.equalTo(loginLabel.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
        }

        bioLabel.snp.makeConstraints { make in
            make.top.equalTo(adminLabel.snp.bottom).offset(24)
            make.leading.equalToSuperview().offset(16)
            make.trailing.equalToSuperview().inset(16)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(bioLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(bioLabel)
        }

        locationLabel.snp.makeConstraints { make in
            make.top.equalTo(emailLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(emailLabel)
        }

        followersLabel.snp.makeConstraints { make in
            make.top.equalTo(locationLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(bioLabel)
        }

        followingLabel.snp.makeConstraints { make in
            make.top.equalTo(followersLabel.snp.bottom).offset(16)
            make.leading.trailing.equalTo(bioLabel)
        }

        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

    private func fetchUserDetail() {
        activityIndicator.startAnimating()

        let viewModel = UserDetailViewModel()
        viewModel.onDetailUpdated = { [weak self] userDetail in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()
                self?.updateUI(with: userDetail)
            }
        }

        viewModel.onError = { [weak self] message in
            DispatchQueue.main.async {
                self?.activityIndicator.stopAnimating()

                self?.showRetryOrBackAlert(
                    message: message,
                    backHandler: {
                        self?.navigationController?.popViewController(animated: true)
                },
                    retryHandler: {
                        self?.fetchUserDetail()
                })
            }
        }

        viewModel.fetchUserDetail(for: user.login)
    }

    private func updateUI(with userDetail: UserDetail) {
        loginLabel.text = userDetail.login
        adminLabel.text = user.site_admin ? "GitHub Admin" : "Regular User"
        bioLabel.text = "Biography: \(userDetail.bio ?? "No Biography")"
        locationLabel.text = "Location: \(userDetail.location ?? "No Location")"
        emailLabel.text = "Email: \(userDetail.email ?? "No Email")"
        followersLabel.text = "Followers: \(userDetail.followers)"
        followingLabel.text = "Following: \(userDetail.following)"
        if let url = URL(string: user.avatar_url) {
            let processor = RoundCornerImageProcessor(cornerRadius: .infinity)
            avatarImageView.kf.setImage(
                with: url,
                placeholder: UIImage(named: "KDAN"),
                options: [
                    .processor(processor),
                    .transition(.fade(0.3)),
                    .cacheOriginalImage
                ]
            )
        }
    }
}
