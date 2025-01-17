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
        let presentationAdapter = FeedLoaderPresentationAdapter(loader: feedLoader)
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        var feedController: FeedViewController

        if #available(iOS 13.0, *) {
            feedController = storyboard.instantiateInitialViewController { coder in
                // Initializer Injection on iOS13+
                FeedViewController(coder: coder, delegate: presentationAdapter)
            }!
        } else {
            // Property Injection on older iOS versions
            feedController = storyboard.instantiateInitialViewController() as! FeedViewController
            feedController.delegate = presentationAdapter
        }

        presentationAdapter.presenter = FeedPresenter(
            feedView: FeedViewAdapter(controller: feedController, imageLoader: imageLoader),
            feedLoadingView: WeakRefVirtualProxy(feedController)
        )

        return feedController
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

final class FeedLoaderPresentationAdapter: FeedViewControllerDelegate {
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
    private let imageLoader: FeedImageDataLoader

    init(controller: FeedViewController, imageLoader: FeedImageDataLoader) {
        self.controller = controller
        self.imageLoader = imageLoader
    }

    func display(_ viewModel: FeedViewModel) {
        controller?.tableModel = viewModel.feed.map { model in
            let adapter = FeedImageDataLoaderPresentationAdapter<WeakRefVirtualProxy<FeedImageCellController>, UIImage>(model: model, imageLoader: imageLoader)

            let view = FeedImageCellController(delegate: adapter)

            adapter.presenter = FeedImagePresenter(
                view: WeakRefVirtualProxy(view),
                imageTransformer: UIImage.init
            )

            return view
        }
    }
}

final class FeedImageDataLoaderPresentationAdapter<View: FeedImageView, Image>: FeedImageCellControllerDelegate where View.Image == Image {
    private let model: FeedImage
    private let imageLoader: FeedImageDataLoader
    private var task: FeedImageDataLoaderTask?

    var presenter: FeedImagePresenter<View, Image>?

    init(model: FeedImage, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }

    func didRequestImage() {
        presenter?.didStartLoadingImageData(for: model)

        let model = self.model
        task = imageLoader.loadImageData(from: model.url) { [weak self] result in
            switch result {
                case let .success(data):
                    self?.presenter?.didFinishLoadingImageData(with: data, for: model)
                case let .failure(error):
                    self?.presenter?.didFinishLoadingImageData(with: error, for: model)
            }
        }
    }

    func didCancelImageRequest() {
        task?.cancel()
    }
}

extension WeakRefVirtualProxy: FeedImageView where T: FeedImageView, T.Image == UIImage {
    func display(_ viewModel: FeedImageViewModel<UIImage>) {
        object?.display(viewModel)
    }
}
