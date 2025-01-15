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
        let presentaionAdapter = FeedLoaderPresentationAdapter(loader: feedLoader)
        let refreshViewController = FeedRefreshViewController(delegate: presentaionAdapter)
        let feedController = FeedViewController(refreshController: refreshViewController)
        let presenter = FeedPresenter(
            feedLoadingView: WeakRefVirtualProxy(refreshViewController),
            feedView: FeedViewAdapter(controller: feedController, loader: imageLoader)
        )
        presentaionAdapter.presenter = presenter

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

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?

    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: FeedLoadingView where T: FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel) {
        object?.display(viewModel)
    }
}

final class FeedLoaderPresentationAdapter: FeedRefreshViewControllerDelegate {
    private let loader: FeedLoader
    var presenter: FeedPresenter?

    init(loader: FeedLoader) {
        self.loader = loader
    }

    func didRequestFeedRefresh() {
        presenter?.didStartLoadingFeed()

        loader.load { [weak self] result in
            switch result {
                case let .success(feed):
                    self?.presenter?.didFinishLoadingFeed(with: feed)
                case let .failure(error):
                    self?.presenter?.didFailLoadingFeed(with: error)
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

    func display(_ viewModel: FeedViewModel) {
        controller?.tableModel = viewModel.feed.map { model in
            let viewModel = FeedImageViewModel(model: model, imageLoader: loader, imageTransformer: UIImage.init)
            return FeedImageCellController(viewModel: viewModel)
        }
    }
}
