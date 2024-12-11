//
//  CoreDataFeedStore.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 11/12/2024.
//

import Foundation

public final class CoreDataFeedStore: FeedStore {

    public init() {

    }

    public func deleteCachedFeed(_ completion: @escaping DeletionCompletion) {

    }

    public func insert(_ feed: [EssentialFeed.LocalFeedImage], timesStamp: Date, completion: @escaping InsertionCompletion) {

    }

    public func retrieve(completion: @escaping RetrievalCompletion) {
        completion(.empty)
    }
}
