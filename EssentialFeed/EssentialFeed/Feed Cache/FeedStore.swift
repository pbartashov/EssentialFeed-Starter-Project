//
//  FeedStore.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 28/11/2024.
//

import Foundation

public protocol FeedStore {
    typealias DeletionCompletion = (Error?) -> Void
    typealias InsertionCompletion = (Error?) -> Void

    func deleteCachedFeed(_ completion: @escaping DeletionCompletion)
    func insert(_ items: [LocalFeedItem], timesStamp: Date, completion: @escaping InsertionCompletion)
}
