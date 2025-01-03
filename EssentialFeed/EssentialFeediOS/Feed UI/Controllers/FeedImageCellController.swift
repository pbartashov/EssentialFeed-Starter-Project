//
//  FeedImageCellController.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 3/1/2025.
//

import UIKit
import EssentialFeed

final class FeedImageCellController {
    let model: FeedImage
    let imageLoader: FeedImageDataLoader
    private var task: FeedImageDataLoaderTask?

    init(model: FeedImage, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }

    func cancelLoad() {
        task?.cancel()
    }

    func view() -> UITableViewCell {
        let cell = FeedImageCell()
        cell.locationContainer.isHidden = (model.location == nil)
        cell.locationLabel.text = model.location
        cell.descriptionLabel.text = model.description
        cell.feedImageRetryButton.isHidden = true
        cell.feedImageView.image = nil
        cell.feedImageContainer.isShimmering = true
        cell.onRetry = { [weak self, weak cell] in
            guard let self = self, let cell = cell else { return }
            self.loadImage(for: cell)
        }

        loadImage(for: cell)

        return cell
    }

    func loadImage(for cell: FeedImageCell) {
        task = imageLoader.loadImageData(from: model.url) { [weak cell] result in
            let data = try? result.get()
            let image = data.map(UIImage.init) ?? nil
            cell?.feedImageView.image = image
            cell?.feedImageRetryButton.isHidden = (image != nil)
            cell?.feedImageContainer.isShimmering = false
        }
    }

    func preload() {
        task = imageLoader.loadImageData(from: model.url, completion: { _ in })
    }
}
