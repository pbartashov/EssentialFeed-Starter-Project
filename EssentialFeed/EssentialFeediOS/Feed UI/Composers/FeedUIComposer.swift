//
//  FeedUIComposer.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 3/1/2025.
//

import EssentialFeed

public final class FeedUIComposer {
    private init() { }

    public static func feedComposedWith(
        feedLoader: FeedLoader,
        imageLoader: FeedImageDataLoader
    ) -> FeedViewController {
        let refreshViewModel = FeedRefreshViewModel(feedLoader: feedLoader)
        let refreshViewController = FeedRefreshViewController(viewModel: refreshViewModel)
        let feedController = FeedViewController(refreshController: refreshViewController)
        refreshViewModel.onFeedLoad = adaptFeedToCelControllers(forewardingTo: feedController, loader: imageLoader)

        return feedController
    }

    private static func adaptFeedToCelControllers(
        forewardingTo controller: FeedViewController,
        loader: FeedImageDataLoader
    ) -> ([FeedImage]) -> Void {
        return { [weak controller] feed in
            controller?.tableModel = feed.map { model in
                FeedImageCellController(model: model, imageLoader: loader)
            }
        }
    }
}
