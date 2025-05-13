//
//  FeedCacheTestHelpers.swift
//  EssentialFeedTests
//
//  Created by Pavel Bartashov on 3/12/2024.
//

import Foundation
import EssentialFeed

func uniqueImage() -> FeedImage {
    FeedImage(id: UUID(), description: "any", location: "any", url: anyURL())
}

func uniqueImageFeed() -> (models: [FeedImage], local: [LocalFeedImage]) {
    let items = [uniqueImage(), uniqueImage()]
    let localItems = items.map { LocalFeedImage(id: $0.id, description: $0.description, location: $0.location, url: $0.url) }

    return (items, localItems)
}

extension Date {
    func minusFeedCacheMaxAge() -> Date {
        adding(days: -feedMaxCacheAgeInDays)
    }

    private var feedMaxCacheAgeInDays: Int {
        7
    }
}
