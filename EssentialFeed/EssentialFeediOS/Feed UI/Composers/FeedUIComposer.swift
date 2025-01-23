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
        let presentationAdapter = FeedLoaderPresentationAdapter(loader: MainQueueDispatchDecorator(decoratee: feedLoader))
        let feedController = makeFeedViewController(delegate: presentationAdapter, title: FeedPresenter.title)

        presentationAdapter.presenter = FeedPresenter(
            feedView: FeedViewAdapter(controller: feedController, imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader)),
            feedLoadingView: WeakRefVirtualProxy(feedController)
        )

        return feedController
    }

    private static func makeFeedViewController(delegate: FeedViewControllerDelegate, title: String) -> FeedViewController {
        let bundle = Bundle(for: FeedViewController.self)
        let storyboard = UIStoryboard(name: "Feed", bundle: bundle)
        var feedController: FeedViewController

        if #available(iOS 13.0, *) {
            feedController = storyboard.instantiateInitialViewController { coder in
                // Initializer Injection on iOS13+
                FeedViewController(coder: coder, delegate: delegate)
            }!
        } else {
            // Property Injection on older iOS versions
            feedController = storyboard.instantiateInitialViewController() as! FeedViewController
            feedController.delegate = delegate
        }

        feedController.title = title

        return feedController
    }
}
