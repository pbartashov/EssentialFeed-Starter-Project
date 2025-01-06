//
//  FeedRefreshViewModel.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 6/1/2025.
//


import UIKit
import EssentialFeed

public final class FeedRefreshViewModel {
    private let feedLoader: FeedLoader
    var onChange: ((FeedRefreshViewModel) -> Void)?
    var onFeedLoad: (([FeedImage]) -> Void)?

    var isLoading = false {
        didSet { onChange?(self) }
    }

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    func loadFeed() {
        isLoading = true
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }
            self?.isLoading = false
        }
    }
}
