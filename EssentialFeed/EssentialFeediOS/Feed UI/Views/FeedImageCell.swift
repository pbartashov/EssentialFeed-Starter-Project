//
//  FeedImageCell.swift
//  EssentialFeediOS
//
//  Created by Pavel Bartashov on 30/12/2024.
//

import UIKit

public final class FeedImageCell: UITableViewCell {
    public var onRetry: (() -> Void)?

    public let locationContainer = UIView()
    public let locationLabel = UILabel()
    public let descriptionLabel = UILabel()
    public let feedImageContainer = UIView()
    public let feedImageView = UIImageView()
    public lazy var feedImageRetryButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(retry), for: .touchUpInside)

        return button
    }()

    @objc private func retry() {
        onRetry?()
    }
}
