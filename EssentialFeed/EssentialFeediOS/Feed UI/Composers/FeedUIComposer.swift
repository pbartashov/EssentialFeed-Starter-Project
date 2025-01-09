//
//  FeedUIComposer.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 3/1/2025.
//

import EssentialFeed
import UIKit

public final class FeedUIComposer {
    private init() { }

    public static func feedComposedWith(
        feedLoader: FeedLoader,
        imageLoader: FeedImageDataLoader
    ) -> FeedViewController {
        let presenter = FeedPresenter(feedLoader: feedLoader)
        let refreshViewController = FeedRefreshViewController(presenter: presenter)
        let feedController = FeedViewController(refreshController: refreshViewController)
        presenter.feedLoadingView = refreshViewController
        presenter.feedView = FeedViewAdapter(controller: feedController, loader: imageLoader)

        return feedController
    }

    private static func adaptFeedToCelControllers(
        forewardingTo controller: FeedViewController,
        loader: FeedImageDataLoader
    ) -> ([FeedImage]) -> Void {
        return { [weak controller] feed in
            controller?.tableModel = feed.map { model in
                let viewModel = FeedImageViewModel(model: model, imageLoader: loader, imageTransformer: UIImage.init)
                return FeedImageCellController(viewModel: viewModel)
            }
        }
    }
}

final class FeedViewAdapter: FeedView {
    private weak var controller: FeedViewController?
    private let loader: FeedImageDataLoader

    init(controller: FeedViewController, loader: FeedImageDataLoader) {
        self.controller = controller
        self.loader = loader
    }

    func display(feed: [FeedImage]) {
        controller?.tableModel = feed.map { model in
            let viewModel = FeedImageViewModel(model: model, imageLoader: loader, imageTransformer: UIImage.init)
            return FeedImageCellController(viewModel: viewModel)
        }
    }
}
