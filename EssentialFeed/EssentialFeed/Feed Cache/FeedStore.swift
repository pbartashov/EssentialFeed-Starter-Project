//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 28/11/2024.
//

import Foundation

public typealias CahedFeed = (feed: [LocalFeedImage], timestamp: Date)

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void

    typealias RetrivalResult = Result<CahedFeed?, Error>
    typealias RetrievalCompletion = (RetrivalResult) -> Void

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate thread, if needed.
    func deleteCachedFeed(_ completion: @escaping DeletionCompletion)

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate thread, if needed.
    func insert(_ feed: [LocalFeedImage], timesStamp: Date, completion: @escaping InsertionCompletion)

    /// The completion handler can be invoked in any thread.
    /// Clients are responsible to dispatch to appropriate thread, if needed.
    func retrieve(completion: @escaping RetrievalCompletion)
}
