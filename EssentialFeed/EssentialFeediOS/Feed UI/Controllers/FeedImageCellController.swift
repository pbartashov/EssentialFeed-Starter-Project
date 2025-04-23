//
//  FeedImageCellController.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 3/1/2025.
//

import UIKit
import EssentialFeed

public protocol FeedImageCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

public final class FeedImageCellController: CellController, ResourceView, ResourceLoadingView, ResourceErrorView {
    public typealias ResourceViewModel = UIImage

    private let viewModel: FeedImageViewModel

    private let delegate: FeedImageCellControllerDelegate
    private var cell: FeedImageCell?

    public init(viewModel: FeedImageViewModel, delegate: FeedImageCellControllerDelegate) {
        self.viewModel = viewModel
        self.delegate = delegate
    }

    public func view(in tableView: UITableView) -> UITableViewCell {
        self.cell = tableView.dequeueReusableCell()

        cell?.locationContainer.isHidden = !viewModel.hasLocation
        cell?.locationLabel.text = viewModel.location
        cell?.descriptionLabel.text = viewModel.description
        cell?.feedImageView.image = nil
        cell?.onRetry = { [weak self] in
            self?.delegate.didRequestImage()
        }

        cell?.onReuse = { [weak self] in
            self?.releaseCellForReuse()
        }

        delegate.didRequestImage()

        return cell!
    }

    public func loadImage(for cell: UITableViewCell) {
        self.cell = cell as? FeedImageCell
        delegate.didRequestImage()
    }

    public func preload() {
        delegate.didRequestImage()
    }

    public func cancelLoad() {
        releaseCellForReuse()
        delegate.didCancelImageRequest()
    }

    public func display(_ viewModel: UIImage) {
        cell?.feedImageView.setImageAnimated(viewModel)
    }

    public func display(_ viewModel: ResourceLoadingViewModel) {
        cell?.feedImageContainer.isShimmering = viewModel.isLoading
    }

    public func display(_ viewModel: ResourceErrorViewModel) {
        cell?.feedImageRetryButton.isHidden = viewModel.message == nil
    }

    private func releaseCellForReuse() {
        cell?.onReuse = nil
        cell = nil
    }
}
