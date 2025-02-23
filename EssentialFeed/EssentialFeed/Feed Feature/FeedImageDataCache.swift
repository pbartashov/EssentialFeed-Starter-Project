//
//  FeedImageDataCache.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 23/2/2025.
//

import Foundation

public protocol FeedImageDataCache {
    typealias Result = Swift.Result<Void, Error>

    func save(_ data: Data, for url: URL, completion: @escaping (Result) -> Void)
}
