//
//  LoadingCell.swift
//  KDAN
//
//  Created by our F on 2025/5/15.
//

import UIKit

class LoadingCell: UITableViewCell {
    static let identifier = "LoadingCell"

    private let spinner = UIActivityIndicatorView(style: .medium)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupUI() {
        contentView.addSubview(spinner)

        spinner.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.greaterThanOrEqualToSuperview().offset(8)
            make.bottom.lessThanOrEqualToSuperview().offset(-8)
        }

        spinner.startAnimating()
    }
}
