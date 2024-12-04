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
        addDays(-feedMaxCacheAgeInDays)
    }

    private var feedMaxCacheAgeInDays: Int {
        7
    }

    func addDays(_ days: Int) -> Date {
        Calendar(identifier: .gregorian).date(byAdding: .day, value: days, to: self)!
    }

    func addSeconds(_ seconds: Int) -> Date {
        Calendar(identifier: .gregorian).date(byAdding: .second, value: seconds, to: self)!
    }
}
