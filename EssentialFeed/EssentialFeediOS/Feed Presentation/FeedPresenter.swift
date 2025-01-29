//
//  FeedPresenter.swift
//  EssentialFeediOS
//
//  Created by Pavel Bartashov on 9/1/2025.
//

import Foundation
import EssentialFeed

protocol FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel)
}

protocol FeedView {
    func display(_ viewModel: FeedViewModel)
}

protocol FeedErrorView {
    func display(_ viewModel: FeedErrorViewModel)
}

final class FeedPresenter {
    private let feedLoadingView: FeedLoadingView
    private let feedView: FeedView
    private let feedErrorView: FeedErrorView

    static var title: String {
        NSLocalizedString(
            "FEED_VIEW_TITLE",
            tableName: "Feed",
            bundle: Bundle(for: FeedPresenter.self),
            comment: "Title for the feed view"
        )
    }

    static var loadError: String {
        NSLocalizedString(
            "FEED_VIEW_CONNECTION_ERROR",
            tableName: "Feed",
            bundle: Bundle(for: FeedPresenter.self),
            comment: "Error message displayed when we can't load the image feed from the server")
    }

    init(
        feedView: FeedView,
        feedLoadingView: FeedLoadingView,
        feedErrorView: FeedErrorView
    ) {
        self.feedLoadingView = feedLoadingView
        self.feedView = feedView
        self.feedErrorView = feedErrorView
    }
    
    func didStartLoadingFeed() {
        feedLoadingView.display(FeedLoadingViewModel(isLoading: true))
        feedErrorView.display(.none())
    }

    func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        feedLoadingView.display(FeedLoadingViewModel(isLoading: false))
    }

    func didFailLoadingFeed(with error: Error) {
        feedLoadingView.display(FeedLoadingViewModel(isLoading: false))
        feedErrorView.display(.error(FeedPresenter.loadError))
    }
}
