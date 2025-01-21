//
//  FeedImageCell+TestHelpers.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 21/1/2025.
//

import UIKit
import EssentialFeediOS

extension FeedImageCell {
    var isShowingLocation: Bool {
        !locationContainer.isHidden
    }

    var locationText: String? {
        locationLabel.text
    }

    var descriptionText: String? {
        descriptionLabel.text
    }

    var isShowingImageLoadingIndicator: Bool {
        feedImageContainer.isShimmering
    }

    var renderedImageData: Data? {
        feedImageView.image?.pngData()
    }

    var renderedImage: UIImage? {
        feedImageView.image
    }

    var isShowngRetryAction: Bool {
        !feedImageRetryButton.isHidden
    }

    func simulateRetryAction() {
        feedImageRetryButton.simulateTap()
    }
}
