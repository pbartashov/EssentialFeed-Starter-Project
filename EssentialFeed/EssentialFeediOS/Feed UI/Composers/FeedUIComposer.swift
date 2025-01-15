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
        let presenter = FeedPresenter()
        let presentaionAdapter = FeedLoaderPresentationAdapter(loader: feedLoader, presenter: presenter)
        let refreshViewController = FeedRefreshViewController(loadFeed: presentaionAdapter.loadFeed)
        let feedController = FeedViewController(refreshController: refreshViewController)
        presenter.feedLoadingView = WeakRefVirtualProxy(refreshViewController)
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

final class FeedLoaderPresentationAdapter {
    private let loader: FeedLoader
    private let presenter: FeedPresenter

    init(loader: FeedLoader, presenter: FeedPresenter) {
        self.loader = loader
        self.presenter = presenter
    }

    func loadFeed() {
        presenter.didStartLoadingFeed()

        loader.load { [weak self] result in
            switch result {
                case let .success(feed):
                    self?.presenter.didFinishLoadingFeed(with: feed)
                case let .failure(error):
                    self?.presenter.didFailLoadingFeed(with: error)
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
