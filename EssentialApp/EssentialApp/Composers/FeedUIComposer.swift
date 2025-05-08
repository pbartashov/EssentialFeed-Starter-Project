//
//  FeedUIComposer.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 3/1/2025.
//

import UIKit
import Combine
import EssentialFeed
import EssentialFeediOS

public final class FeedUIComposer {
    private init() { }

    private typealias FeedPresentationAdapter = LoadResourcePresentationAdapter<[FeedImage], FeedViewAdapter>

    public static func feedComposedWith(
        feedLoader: @escaping () -> AnyPublisher<[FeedImage], Error>,
        imageLoader: @escaping (URL) -> FeedImageDataLoader.Publisher,
        selection: @escaping (FeedImage) -> Void = { _ in }
    ) -> ListViewController {
        let presentationAdapter = FeedPresentationAdapter(loader: feedLoader)
        let feedController = makeFeedViewController(title: FeedPresenter.title, onRefresh: presentationAdapter.loadResource)

        presentationAdapter.presenter = LoadResourcePresenter(
            resourceView: FeedViewAdapter(controller: feedController, imageLoader: imageLoader, selection: selection),
            loadingView: WeakRefVirtualProxy(feedController),
            errorView: WeakRefVirtualProxy(feedController),
            mapper: FeedPresenter.map
        )

        return feedController
    }

    private static func makeFeedViewController(title: String, onRefresh: (() -> Void)?) -> ListViewController {
        let bundle = Bundle(for: ListViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        var feedController: ListViewController

        if #available(iOS 13.0, *) {
            feedController = storyboard.instantiateInitialViewController { coder in
                // Initializer Injection on iOS13+
                ListViewController(coder: coder, onRefresh: onRefresh)
            }!
        } else {
            // Property Injection on older iOS versions
            feedController = storyboard.instantiateInitialViewController() as! ListViewController
            feedController.onRefresh = onRefresh
        }

        feedController.title = title

        return feedController
    }
}
