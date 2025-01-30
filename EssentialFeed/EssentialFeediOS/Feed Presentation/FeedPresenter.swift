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
        feedErrorView.display(.noError())
    }

    func didFinishLoadingFeed(with feed: [FeedImage]) {
        feedView.display(FeedViewModel(feed: feed))
        feedLoadingView.display(FeedLoadingViewModel(isLoading: false))
    }

    func didFinishLoadingFeed(with error: Error) {
        feedLoadingView.display(FeedLoadingViewModel(isLoading: false))
        feedErrorView.display(.error(Localized.Feed.loadError))
    }
}
