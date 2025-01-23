//
//  FeedLoaderPresentationAdapter.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 23/1/2025.
//

import EssentialFeed

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
