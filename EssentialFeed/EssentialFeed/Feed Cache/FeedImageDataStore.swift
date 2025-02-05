//
//  FeedImageDataStore.swift
//  EssentialFeed
//
//  Created by Pavel Bartashov on 5/2/2025.
//

import Foundation

public protocol FeedImageDataStore {
    typealias Result = Swift.Result<Data?, Error>

    func retrieve(dataForURL url: URL, completion: @escaping (Result) -> Void)
}
