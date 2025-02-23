//
//  FeedCache.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 23/2/2025.
//


public protocol FeedCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ feed: [FeedImage], completion: @escaping (Result) -> Void)
}
