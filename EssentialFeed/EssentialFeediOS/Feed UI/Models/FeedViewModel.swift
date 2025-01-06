//
//  FeedViewModel.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 6/1/2025.
//


import UIKit
import EssentialFeed

final class FeedViewModel {
    typealias Obsever<T> = (T) -> Void

    private let feedLoader: FeedLoader
    var onLoadingStateChange: Obsever<Bool>?
    var onFeedLoad: Obsever<[FeedImage]>?

    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }

    func loadFeed() {
        onLoadingStateChange?(true)
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onFeedLoad?(feed)
            }
            self?.onLoadingStateChange?(false)
        }
    }
}
