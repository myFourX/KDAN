//
//  UserCell.swift
//  KDAN
//
//  Created by our F on 2025/5/15.
//

import UIKit
import Kingfisher
import SnapKit

class UserCell: UITableViewCell {
    static let identifier = "UserCell"

    let avatarImageView = UIImageView()
    let loginLabel = UILabel()
    let adminLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with user: User) {
        loginLabel.text = user.login
        adminLabel.text = user.site_admin ? "GitHub Admin" : "Regular User"
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

    private func setupUI() {
        avatarImageView.layer.cornerRadius = 25
        avatarImageView.clipsToBounds = true
        
        contentView.addSubview(avatarImageView)
        contentView.addSubview(loginLabel)
        contentView.addSubview(adminLabel)
        
        avatarImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(50)
        }
        
        loginLabel.snp.makeConstraints { make in
            make.leading.equalTo(avatarImageView.snp.trailing).offset(16)
            make.top.equalToSuperview().offset(12)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
        
        adminLabel.snp.makeConstraints { make in
            make.leading.equalTo(loginLabel)
            make.top.equalTo(loginLabel.snp.bottom).offset(4)
            make.bottom.equalToSuperview().inset(12)
            make.trailing.lessThanOrEqualToSuperview().offset(-16)
        }
    }
}
