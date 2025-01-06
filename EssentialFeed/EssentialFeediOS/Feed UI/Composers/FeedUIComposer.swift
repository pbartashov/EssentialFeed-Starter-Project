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
        let viewModel = FeedViewModel(feedLoader: feedLoader)
        let refreshViewController = FeedRefreshViewController(viewModel: viewModel)
        let feedController = FeedViewController(refreshController: refreshViewController)
        viewModel.onFeedLoad = adaptFeedToCelControllers(forewardingTo: feedController, loader: imageLoader)

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
