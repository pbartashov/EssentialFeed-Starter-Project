//
//  FeedImageCellController.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 3/1/2025.
//

import UIKit

final class FeedImageCellController {
    let viewModel: FeedImageViewModel<UIImage>

    init(viewModel: FeedImageViewModel<UIImage>) {
        self.viewModel = viewModel
    }

    func cancelLoad() {
        viewModel.cancelImageDataLoad()
    }

    func view() -> UITableViewCell {
        let cell = binded(FeedImageCell())
        loadImage()

        return cell
    }

    func binded(_ cell: FeedImageCell) -> FeedImageCell {
        cell.locationContainer.isHidden = viewModel.hasLocation
        cell.locationLabel.text = viewModel.location
        cell.descriptionLabel.text = viewModel.description
        cell.onRetry = viewModel.loadImageData

        viewModel.onImageLoad = { [weak cell] image in
            cell?.feedImageView.image = image
        }

        viewModel.onImageLoadingStateChange = { [weak cell] isLoading in
            cell?.feedImageContainer.isShimmering = isLoading
        }

        viewModel.onShouldRetryImageLoadingStateChange = { [weak cell] shouldRetry in
            cell?.feedImageRetryButton.isHidden = !shouldRetry
        }

        return cell
    }

    func loadImage() {
        viewModel.loadImageData()
    }

    func preload() {
        viewModel.preloadImageData()
    }
}
