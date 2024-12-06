//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 28/11/2024.
//

import Foundation

public enum RetriedCachedFeedResult {
    case empty
    case found(feed: [LocalFeedImage], timestamp: Date)
    case failure(Error)
}

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void
    typealias RetrievalCompletion = (RetriedCachedFeedResult) -> Void

    func deleteCachedFeed(_ completion: @escaping DeletionCompletion)
    func insert(_ feed: [LocalFeedImage], timesStamp: Date, completion: @escaping InsertionCompletion)
    func retrieve(completion: @escaping RetrievalCompletion)
}
