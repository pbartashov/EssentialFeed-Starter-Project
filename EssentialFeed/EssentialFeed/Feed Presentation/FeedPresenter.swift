//
//  FeedPresenter.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 30/1/2025.
//

import Foundation

public protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

public protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

public protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

public final class FeedPresenter {
    public static var title: String {
        NSLocalizedString(
            "FEED_VIEW_TITLE",
            tableName: "Feed",
            bundle: Bundle(for: self),
            comment: "Title for the feed view")
    }

    public static var loadError: String {
        NSLocalizedString(
            "FEED_VIEW_CONNECTION_ERROR",
            tableName: "Feed",
            bundle: Bundle(for: self),
            comment: "Error message displayed when we can't load the image feed from the server")
    }

    private let feedView: FeedView
    private let feedLoadingView: FeedLoadingView
    private let feedErrorView: FeedErrorView

    public init(
        feedView: FeedView,
        feedLoadingView: FeedLoadingView,
        feedErrorView: FeedErrorView
    ) {
        self.feedLoadingView = feedLoadingView
        self.feedView = feedView
        self.feedErrorView = feedErrorView
    }

    public func didStartLoadingFeed() {
        feedErrorView.display(.noError)
        feedLoadingView.display(FeedLoadingViewModel(isLoading: true))
    }

    public func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        feedLoadingView.display(FeedLoadingViewModel(isLoading: false))
    }

    public func didFinishLoadingFeed(with error: Error) {
        feedLoadingView.display(FeedLoadingViewModel(isLoading: false))
        feedErrorView.display(.error(message: FeedPresenter.loadError))
    }
}

